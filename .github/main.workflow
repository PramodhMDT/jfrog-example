workflow "New workflow" {
  on = "push"
  resolves = ["Step2 - Collect Build Info"]
}

action "Step1 - Publish package" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["go-publish go v1.0.0 --build-name=my-build --build-number=1"]
  env = {
    CRED = "username"
  }
}

action "Step2 - Collect Build Info" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["build-collect-env my-build 1","build-publish my-build 1"]
  env = {
    CRED = "username"
  }
  needs = ["Step1 - Publish package"]
}