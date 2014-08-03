import json
import docker
from bottle import route, run, template, request


WHITELIST = set(["srid/simplepaas-demo"])


@route("/webhook", method='POST')
def webhook():
    data = json.loads(request.body.read().decode('utf8'))
    print("Hooked from hub.docker.com: %s", data)
    repo_name = data["repository"]["repo_name"]
    if repo_name not in WHITELIST:
        raise ValueError("Blocking hook; %s not in whitelist" % repo_name)
    print("Downloading image %s" % repo_name)
    d = get_docker()
    d.pull(repo_name, tag='latest')
    print("Starting container off image %s" % repo_name)
    cont = d.create_container(repo_name)
    d.start(cont)
    # TODO: kill existing container, and start new one
    # ensure that old one is killed only after new one is ready to be spawned.

    # TODO: pass some env vars to container, like image id.


def get_docker():
    return docker.Client(base_url='unix://tmp/docker.sock', timeout=10)
    
if __name__ == "__main__":
    run(host='0.0.0.0', port=80)

