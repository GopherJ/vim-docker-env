.PHONY: image
image:
	DOCKER_BUILDKIT=1 docker build \
		-c 512 \
		-t alexcj96/vim-docker-env:latest \
		-f Dockerfile .

