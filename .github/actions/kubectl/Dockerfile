FROM gcr.io/cloud-builders/kubectl

LABEL "com.github.actions.name"="Kubectl Action Builder"
LABEL "com.github.actions.description"="Actions with kubectl"
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="blue"

RUN apt-get update -y && \
    apt-get install -y curl

ENTRYPOINT ["/bin/make"]