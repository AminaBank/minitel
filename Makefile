TAG := amina-minitel
PORT ?= 80


build:
	docker build \
		-t ${TAG} \
		.

run:
	docker run \
		-p ${PORT}:80 \
		${TAG}
