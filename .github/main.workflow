workflow "Lint, Test, and Build" {
  on = "push"
  resolves = ["Build"]
}

action "Lint" {
  uses = "Seklfreak/github-actions/actions/go@master"
  runs = "make"
  args = "lint"
}

action "Test" {
  uses = "Seklfreak/github-actions/actions/go@master"
  runs = "make"
  args = "test"
}

action "Build" {
  needs = ["Lint", "Test"]
  uses = "actions/docker/cli@master"
  args = ["build", "-t", "aws-example", "."]
}

action "Docker Login" {
  needs = ["Build"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Publish" {
  needs = ["Docker Login"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "publish"
}
