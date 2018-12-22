.PHONY: all lint test build clean docker-build docker-publish

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
	@docker build -t github-actions-test .

docker-publish:
	@docker push github-actions/github-actions-test