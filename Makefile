IMG := srid/simplepaas

all:
	docker build -t ${IMG} .

run:
	docker rm -vf simplepaas || true
	docker rm -vf simplepaas-nginx || true
	docker run -d --name=simplepaas \
		-v /var/run/docker.sock:/tmp/docker.sock -e VIRTUAL_HOST=${CNAME} ${IMG}
	docker logs -f simplepaas

logs:
	docker logs -f simplepaas

# for debugging.
shell:
	docker run --rm --name=simplepaas-shell \
		-i -t -v /var/run/docker.sock:/tmp/docker.sock ${IMG} bash


