workflow "Lint, Test, and Build" {
  on = "push"
  resolves = ["Publish"]
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
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"
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
