all: build

build: Makefile Dockerfile
	docker build -t mariocki/hyperion-docker .

run-tk5:
	docker run -it --rm -p 3270:3270 -p 8038:8038 --name hyperion-docker --mount type=bind,source=/mnt/data/mvs-tk5,destination=/tk4 mariocki/hyperion-docker

run:
	docker run -it --rm -p 3270:3270 -p 8038:8038 --name hyperion-docker --mount type=bind,source=/mnt/data/tk4,destination=/tk4 mariocki/hyperion-docker
