.PHONY: all lint test build clean

all: clean build

lint:
	@go vet ./...

test:
	@go test -v -race

build:
	@go build -o out.bin .

clean:
	@if [ -a out.bin ]; then rm out.bin; fi