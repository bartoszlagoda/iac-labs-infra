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

  env = {
    POSTGRES_DB       = "app",
    POSTGRES_USER     = "app_user",
    POSTGRES_PASSWORD = "app_pass",
  }

  network {
    mode    = "bridge"
    networks = [docker_network.tfnet.name]
  }

  depends_on = [docker_image.postgres]
}

resource "docker_network" "tfnet" {
  name = "tfnet"
}

resource "docker_image" "postgres" {
  name = "postgres:latest"
}

resource "docker_container" "db" {
  name  = "my_postgres_db"
  image = docker_image.postgres.image_id

  env = {
    POSTGRES_DB       = "my_database",
    POSTGRES_USER     = "my_user",
    POSTGRES_PASSWORD = "my_password",
  }

  ports {
    internal = 5432
    external = 5432
  }
}