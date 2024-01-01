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
}

resource "docker_container" "db" {
  name  = "db"
  image = docker_image.postgres.image_id

  env = {
    "POSTGRES_DB" = "app",
    "POSTGRES_USER" = "app_user",
    "POSTGRES_PASSWORD" = "app_pass",
  }

  network {
    mode    = "bridge"
    networks = [docker_network.tfnet.name]
  }
}

resource "docker_network" "tfnet" {
  name = "tfnet"
}