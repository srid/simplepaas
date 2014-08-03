IMG := srid/simplepaas

install:
	docker pull jwilder/nginx-proxy
	# docker pull progrium/logspout
	docker build -t ${IMG} .

run:	run_nginx run_app
	@true

# http routing for containers
run_nginx:
	docker rm -vf nginx || true
	docker run -d --name=nginx \
		-p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy

# log routing for containers.
run_logspout:
	[ ! -z "${SYSLOG_ENDPOINT}" ] || (echo "ERROR: you must first set $SYSLOG_ENDPOINT"; exit 2)
	docker rm -vf logspout || true
	docker run --name=logspout -d \
		-v=/var/run/docker.sock:/tmp/docker.sock progrium/logspout syslog://${SYSLOG_ENDPOINT}

# wehbook app 
run_app:
	docker run --rm --name=simplepaas \
		-v /var/run/docker.sock:/tmp/docker.sock -e VIRTUAL_HOST=${CNAME} ${IMG}

test:
	cd demo && docker build -t ${IMG}-demo-local .
	docker run --rm -p 80 ${IMG}-demo-local

