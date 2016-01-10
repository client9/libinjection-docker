
CONTAINER=nickg/libinjection-docker
build:
	docker build -t ${CONTAINER} .
console: build
	docker run --rm -it ${CONTAINER} sh
