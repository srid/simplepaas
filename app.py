import json
import docker
from bottle import route, run, template, request


# Allow only selected images, for now.
WHITELIST = set(["srid/simplepaas-demo"])


@route("/webhook", method='POST')
def webhook():
    data = json.loads(
        request.body.read().decode('utf8'))
    print("Hooked from hub.docker.com: %s", data)
    
    repo_name = data["repository"]["repo_name"]
    if repo_name not in WHITELIST:
        raise ValueError("Blocking hook; %s not in whitelist" % repo_name)

    d = get_docker()
    print("Downloading image %s" % repo_name)
    d.pull(repo_name, tag='latest')

    name=create_uniq_container_name_for(repo_name)

    existing_container = get_container_by(d, name=name)
    if existing_container:
        print("Killing existing container: %s" % name)
        d.kill(existing_container)
        d.remove_container(existing_container, v=True)
    
    print("Starting container off image %s" % repo_name)
    cont = d.create_container(
        repo_name,
        # Give an unique name, so we can delete this container later.
        name=name,
        # Limit memory usage
        # mem_limit=
    )
    d.start(cont)


def get_docker():
    return docker.Client(base_url='unix://tmp/docker.sock', timeout=10)

def get_container_by(d, name):
    name = '/' + name  # docker uses / at front
    for container in d.containers():
        if name in container['Names']:
            return container

def create_uniq_container_name_for(repo_name):
    return "simplepaas-%s" % repo_name.replace('/', '-')
    
if __name__ == "__main__":
    run(host='0.0.0.0', port=80)

