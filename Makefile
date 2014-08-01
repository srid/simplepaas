install:
	docker pull jwilder/nginx-proxy
	# docker pull progrium/logspout
	docker build -t srid/simplepaas .

run:	run_nginx run_app
	@true

# http routing for containers
run_nginx:
	docker rm -vf nginx || true
	docker run -d --name=nginx -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

# log routing for containers.
run_logspout:
	[ ! -z "${SYSLOG_ENDPOINT}" ] || (echo "no endpoint set"; exit 2)
	docker rm -vf logspout || true
	docker run --name=logspout -d -v=/var/run/docker.sock:/tmp/docker.sock progrium/logspout syslog://${SYSLOG_ENDPOINT}

# wehbook app 
run_app:
	docker run --rm --name=simplepaas -p 80 -v /var/run/docker.sock:/tmp/docker.sock -e VIRTUAL_HOST=${CNAME} srid/simplepaas

test:
	cd demo && docker build -t srid/simplepaas-demo-local .
	docker run --rm -p 80 -e VIRTUAL_HOST=${CNAME} srid/simplepaas-demo-local

