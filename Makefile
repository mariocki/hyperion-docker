
all: hyperion-docker_1.0-1.deb

hyperion-docker_1.0-1.deb: Makefile Dockerfile
	docker build -t mariocki/hyperion-docker .
	docker create -ti --name builder mariocki/hyperion-docker bash
	docker cp builder:/build/hyperion-docker_1.0-1.deb .
	docker rm -f builder
