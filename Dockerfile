# build
FROM golang:1.11.4-stretch as builder

RUN mkdir /app
ADD . /app/
WORKDIR /app

RUN make all

# run
FROM ubuntu:bionic

EXPOSE 8080

ENTRYPOINT [ "/out.bin" ]
COPY --from=builder "/app/out.bin" /