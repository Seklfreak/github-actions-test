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
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"
}
