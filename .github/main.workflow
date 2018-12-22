workflow "Lint, Test, and Build" {
  on = "push"
  resolves = [
    "Publish",
    "Docker Login",
    "Docker Tag",
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
  needs = ["Docker Tag"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Publish" {
  needs = ["Docker Login"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "docker-publish"
}
