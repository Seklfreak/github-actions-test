.PHONY: all lint test build clean docker-build docker-publish k8s-rollout

all: clean build

lint:
	@go vet ./...

test:
	@go test -v -race

build:
	@go build -o out.bin .

clean:
	@if [ -a out.bin ]; then rm out.bin; fi

docker-build:
	@docker build -t sekl/github-actions-test .

docker-publish:
	@docker push sekl/github-actions-test

k8s-rollout:
	@sh ./rollout.sh