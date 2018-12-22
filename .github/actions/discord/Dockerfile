FROM golang:1.11

LABEL "com.github.actions.name"="GitHub Action for Discord"
LABEL "com.github.actions.description"="Send messages to Discord."
LABEL "com.github.actions.icon"="message-circle"
LABEL "com.github.actions.color"="blue"

RUN mkdir /app
ADD . /app/
WORKDIR /app

RUN go build -o discord.out .

ENTRYPOINT ["/app/discord.out"]