# Simple PaaS for the lazy

TODO: simplify instructions

## install

on a bare Ubuntu 14.04 server VM, run:

```
# install latest docker, *not* the ubuntu docker.io package:
curl -sSL https://get.docker.io/ubuntu/ | sudo sh
# install simplepaas
make
```

## running

if running from this repo:

```
make run CNAME=yourpaas.yourdomain.com
```

else:

```
docker run --rm --name=simplepaas \
		-v /var/run/docker.sock:/tmp/docker.sock \
        -e VIRTUAL_HOST=yourpaas.yourdomain.com srid/simplepaas
```

and then:

* go to hub.docker.com and add a wehbook for
  yourpaas.yourdomain.com/webhook in your trusted build for the ./demo
  app

* push the image; your app should be deployed (per CNAME specified in
  demo/Dockerfile)

## extras

* **logging**: redirect output of all containers to an external
  aggregator (such as [papertrail](https://papertrailapp.com/)). this
  can be done using a single command: `docker run --name=logspout -d
  -v=/var/run/docker.sock:/tmp/docker.sock progrium/logspout
  syslog://${SYSLOG_ENDPOINT}`
