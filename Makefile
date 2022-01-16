
all: hyperion-docker_1.0-1.deb

hyperion-docker_1.0-1.deb: Makefile Dockerfile
	docker build --build-arg LAST_SERVER_COMMIT="`git ls-remote https://github.com/SDL-Hercules-390/hyperion.git "refs/heads/master" | grep -o "^\S\+"`" -t mariocki/hyperion-docker .
	docker create -ti --name builder mariocki/hyperion-docker bash
	docker start builder
	./copy_file_from_docker.sh
	docker rm -f builder
