resource "docker_image" "example_app" {
  name = "example_app"
  build {
    context = "${path.cwd}/../../iac-labs/example-app"
    tag  = ["example_app:latest"]
    build_arg = {
      platform : "linux/amd64"
    }
    label = {
      author : "student"
    }
  }
}

resource "docker_image" "postgres" {
  name = "postgres"
  build {
    context = "${path.cwd}/../../iac-labs/postgres"
    tag  = ["postgres:latest"]
    dockerfile = "${path.cwd}/../../iac-labs/postgres/Dockerfile"
    args = {
      POSTGRES_DB = "app"
      POSTGRES_USER = "app_user"
      POSTGRES_PASSWORD = "app_pass"
    }
  }
}

resource "docker_container" "db" {
  name = "db"
  image = "${docker_image.postgres.latest}"
  network_mode = "tfnet"
}