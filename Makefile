IMG := srid/simplepaas

all:
	docker build -t ${IMG} .

run:
	docker run --rm --name=simplepaas \
		-v /var/run/docker.sock:/tmp/docker.sock -e VIRTUAL_HOST=${CNAME} ${IMG}

# for debugging.
shell:
	docker run --rm --name=simplepaas-shell \
		-i -t -v /var/run/docker.sock:/tmp/docker.sock ${IMG} bash


