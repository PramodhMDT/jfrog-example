workflow "New workflow" {
  on = "push"
  resolves = ["Step4 - Run app"]
}

action "Step1 - Get sources" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["go build go --no-registry"]
  env = {
    CRED = "username"
  }
}

action "Step2 - Publish modules" {
  uses = "retgits/actions/jfrog-cli-go@master"
  needs = ["Step1 - Get sources"]
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["go-publish go --self=false --deps=all"]
  env = {
    CRED = "username"
  }
}

action "Step3 - Build Info" {
  uses = "retgits/actions/jfrog-cli-go@master"
  needs = ["Step2 - Publish modules"]
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["go build go --build-name=my-build --build-number=1"]
  env = {
    CRED = "username"
  }
}

action "Step4 - Run app" {
  uses = "actions/bin/sh@master"
  needs = ["Step3 - Build Info"]
  args = "./hello"
}
