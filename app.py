import json
import docker
from bottle import route, run, template, request

@route("/webhook", method='POST')
def webhook():
    data = json.loads(request.body.read().decode('utf8'))
    print("got hooked: %s", data)
    repo_name = data["repository"]["repo_name"]
    print("pulling and restarting container %s" % repo_name)
    c = docker.Client(base_url='unix://tmp/docker.sock', timeout=10)
    c.pull(repo_name, tag='latest')

if __name__ == "__main__":
    run(host='0.0.0.0', port=80)

