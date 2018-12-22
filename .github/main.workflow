workflow "Test, Build, and Rollout" {
  on = "push"
  resolves = [
    "K8s Rollout",
  ]
}

action "Lint" {
  uses = "./.github/actions/go"
  runs = "make"
  args = "lint"
}

action "Test" {
  uses = "./.github/actions/go"
  runs = "make"
  args = "test"
}

action "Build" {
  needs = ["Lint", "Test"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "docker-build"
}

action "Docker Tag" {
  uses = "actions/docker/tag@master"
  needs = ["Build"]
  args = "sekl/github-actions-test sekl/github-actions-test"
}

action "Docker Login" {
  needs = ["Build"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Docker Tag", "Docker Login"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "docker-publish"
}

action "K8s Rollout" {
  needs = ["Docker Publish"]
  uses = "./.github/actions/kubectl"
  runs = "make"
  args = "k8s-rollout"
  secrets = [
    "DIGITALOCEAN_TOKEN",
    "DIGITALOCEAN_K8S_CLUSTER_ID",
  ]
}
