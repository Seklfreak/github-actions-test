workflow "Test, Build, and Rollout" {
  on = "push"
  resolves = [
    "GitHub Action for Discord",
    "GitHub Action for Discord-1",
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

action "GitHub Action for Discord" {
  uses = "./.github/actions/discord"
  needs = ["Docker Publish"]
  secrets = ["WEBHOOK_ID", "WEBHOOK_TOKEN"]
  env = {
    MESSAGE = "Deployment started…"
    USERNAME = "github-actions-test"
  }
}

action "GitHub Action for Discord-1" {
  uses = "./.github/actions/discord"
  needs = ["K8s Rollout"]
  secrets = ["WEBHOOK_TOKEN", "WEBHOOK_ID"]
  env = {
    USERNAME = "github-actions-test"
    MESSAGE = "Deployment completed!"
  }
}
