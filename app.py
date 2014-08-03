import json
import docker
from bottle import route, run, template, request


# Allow only selected users for now.
USERS_WHITELIST = set(["srid"])


@route("/webhook", method='POST')
def webhook():
    data = json.loads(
        request.body.read().decode('utf8'))
    print("Hooked from hub.docker.com: %s", data)
    
    repo_name = data["repository"]["repo_name"]
    if repo_name.split('/', 1)[0] not in USERS_WHITELIST:
        raise ValueError("Image %s not allowed" % repo_name)

    d = get_docker()
    pull_image(d, repo_name)

    name=create_uniq_container_name_for(repo_name)

    existing_container = get_container_by(d, name=name)
    if existing_container:
        print("Killing existing container: %s" % name)
        d.kill(existing_container)
        d.remove_container(existing_container, v=True)

    run_container(d, repo_name, name=name)


def get_docker():
    return docker.Client(base_url='unix://tmp/docker.sock', timeout=10)

def get_container_by(d, name):
    name = '/' + name  # docker uses / at front
    for container in d.containers():
        if name in container['Names']:
            return container

def create_uniq_container_name_for(image_name):
    return "simplepaas-%s" % image_name.replace('/', '-')
    
def pull_image(d, image_name):
    print("Downloading image %s" % image_name)
    d.pull(image_name, tag='latest')

def run_container(d, image_name, **kwargs):
    """
    Convenient function merging separate 'create' and 'start'
    functions. We just want a Python function representing `docker run`
    """
    print("Starting container using image %s and args: %s" % (image_name, kwargs))

    # Split kwargs to pass a subset to start, instead of create
    start_kwargs = {}
    start_kwargs_accepted = ['port_bindings', 'binds']
    for k in start_kwargs_accepted:
        if k in kwargs:
            start_kwargs[k] = kwargs[k]
            del kwargs[k]
        
    container = d.create_container(
        image_name, **kwargs)
    d.start(container, **start_kwargs)

def start_nginx_proxy():
    """
    Start jwilder/nginx-proxy if it is not already running
    """
    d = get_docker()
    image = 'jwilder/nginx-proxy'
    name = 'simplepaas-nginx'
    if not get_container_by(d, name):
        pull_image(d, image)
        # -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock
        run_container(
            d,
            image,
            name=name,
            port_bindings={80: 80},
            volumes=['/tmp/docker.sock'],
            binds={'/var/run/docker.sock': {'bind': '/tmp/docker.sock', 'ro': False}}
        )


if __name__ == "__main__":
    start_nginx_proxy()
    run(host='0.0.0.0', port=80)

