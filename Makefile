TAG := amina-minitel
PORT ?= 8355


build:
	docker build \
		-t ${TAG} \
		.

run:
	docker run \
		-p ${PORT}:80 \
		${TAG}
