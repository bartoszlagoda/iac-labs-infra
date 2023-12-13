# Laboratorium numer 2

Terraform:

- Składnia
- Modularyzacja
- Idempotentność

Tworzenie stosów na platformie AWS

Pulumi:

- Składnia
- Modularyzacja
- Idempotentność

Tworzenie stosów na platformie AWS

## Przed laboratorium

Dokumentacja narzędzi użytych do realizacji zadania:

-[Terraform](https://developer.hashicorp.com/terraform/docs)
-[Pulumi](https://www.pulumi.com/docs/get-started/)

-[Dokumentacja zasobów terraform](https://registry.terraform.io/browse/providers)
-[Dokumentacja zasobów pulumi](https://www.pulumi.com/registry/)

Instalacja zależności:

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Pulumi](https://www.pulumi.com/docs/get-started/aws/begin/)

Adres repozytorium:
[https://github.com/mwidera/iac-labs-infra](https://github.com/mwidera/iac-labs-infra)

Instalacja narzędzi na platformie VDI:

- Sprawdź działanie aplikacji: `terraform --version`
- Wykonaj polecenie: `curl -fsSL https://get.pulumi.com | sh`
- Ustaw zmienną PATH: `export PATH=$PATH:/root/.pulumi/bin`
- Zweryfikuj działanie `pulumi version`

## Zadanie 1: Terraform składnia, idempotentność, modularność

- Instrukcja dla osób **nie** korzystających z AWSa:
  
  1. Wydaj polecenie: `pip install terraform-local pulumi-local`
  2. Ustaw alias: `alias terraform=terraform-local`
  3. Ustaw alias: `alias pulumi=pulumilocal`
  
- Ustaw następujące zmienne systemowe (klucz i sekret pobierz z konta AWSowego)

  ```bash
  export AWS_ACCESS_KEY_ID=ALAMAKOTAASDASDX
  export AWS_SECRET_ACCESS_KEY="przykladowykluczo2KyARbABVJavS2b1234"
  ```

- Wykonaj klonowanie repozytorium do przestrzeni roboczej
- Wydaj polecenie pobrania git modułu (potrzebne do zadań 3 i 6):

  ```bash
  git submodule init
  git submodule update
  ```

- Przejdź do katalogu terraform/zad1
- Kolejne zadania 1-import, 2-zmienne, 3-moduły pozwolą poznać składnie
- Przejdź do każdego z wymienionych wyżej katalogów otwierając plik `main.tf` jako funkcje główną programu
- Wykonaj polecenie inicjujące narzędzie: `terraform init`
- Zaobserwuj jakie zależności zostały pobrane
- Wykonaj polecenie tworzące plan aplikowania infrastruktury: `terraform plan`
- Zaaplikuj plan poleceniem `terraform apply`
- Zweryfikuj działanie stworzonej infrastruktury
- Wydaj raz jeszcze polecenie `terraform plan/apply` by sprawdzić, czy stos jest idempotentny
- (Podczas zadania 3-moduły): Wydaj polecenie `terraform taint <nazwa_zasobu>` by oznaczyć zasób jako element do zastąpienia i ponów krok wcześniejszy
- Wydaj polecenie `terraform state list` a następnie `terraform state show <nazwa_zasobu>` by poznać stan zasobów
- Zanotuj efekty powyzszych poleceń w sprawozdaniu - jako tekst (**nie** zrzut ekranu, albo załącznik)
- Zniszcz środowisko poleceniem `terraform destroy`

Notka:

- Dla zadania 3-module w linii 47 pliku `main.tf` zmodyfikuj AMI przed zaaplikowaniem w chmurze AWS!

Pytania:

- Wyjaśnij zasadę działania sekcji `variables` oraz `outputs`
- Jakie ma zastosowanie blok kodu umieszczony poniżej?
- W jakim celu stosujemy `terraform taint`?

  ```terraform
  provider "aws" {
    region = "eu-central-1"
  }

  provider "aws" {
    alias  = "east"
    region = "us-east-1"
  }
  ```

## Zadanie 2: Terraform z Docker'em

Zadanie jest zbliżone do poprzedniego z tym wyjątkiem, iz do jego realizacji nie jest niezbędny AWS

- Wykonaj polecenie inicjujące narzędzie: `terraform init`
- Zaobserwuj jakie zależności zostały pobrane
- Wykonaj polecenie tworzące plan aplikowania infrastruktury: `terraform plan`
- Zaaplikuj plan poleceniem `terraform apply`
- Zweryfikuj działanie stworzonej infrastruktury
- Zmodyfikuj infrastrukturę zmieniając oznaczenie obrazu wykorzystując zasób [docker_tag](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/tag)
  Przykładowy zasób jaki należy dodać do :

  ```terraform
  resource "docker_tag" "tag_<indeks>" {
    <<wykorzystaj_dokumentacje>>
  }
  ```

- Zaaplikuj zmiany poleceniami `terraform plan` i `terraform apply`
- Wydaj polecenie `terraform state list` a następnie `terraform show` by poznać stan zasobów
- Zanotuj efekty powyzszych poleceń w sprawozdaniu - jako tekst (**nie** zrzut ekranu, albo załącznik)
- Zniszcz środowisko poleceniem `terraform destroy`

Pytania:

- Wyjaśnij jest plik `terraform.tfstate`
- Wyjaśnij w jaki sposób współdzielenie `terraform.tfstate` zagwarantuje idempotentne podejście tworzenia infrastruktury

## Zadanie 3: Uruchomienie example-app

Uruchomienie aplikacji lokalnie jako element odwzorowania środowiska docelowego

- Przejdź do katalogu terraform/zad3
- Zapoznaj się ze składnią stworzonego stosu
- Dodaj brakujący zasób (bazę danych) z wykorzystaniem sekcji `resource`
  Składnia kontenera dostępna jest pod tym [adresem](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container)
  
  Kontener nazwij `db`
  
  Obraz na którym bazujesz to `resource "docker_image" "postgres"` opisany w pliku `images.tf`
  
  Podepnij kontener do wspólnej wirtualnej sieci `tfnet`
  
  Dodaj zmienne środowiskowe niezbędne do poprawnego działania stworzonego kontenera:

  ```bash
    "POSTGRES_DB=app",
    "POSTGRES_USER=app_user",
    "POSTGRES_PASSWORD=app_pass"
  ```

Pytania:

- Porównaj podejście do tworzenia lokalnego środowiska z wykorzystaniem docker-compose oraz terraform
- Podaj zalety tak realizowanego lokalnego środowiska

## Zadanie 4 - Pulumi

- Przejdź do katalogu pulumi/zad1
- Wykonaj polecenie `pulumi new aws-python --force`
- Podaj parametry wykonania np. `project name: zad1`, `project description: Empty`, `stack name: nr_indeksu`
- Zapoznaj się z zawartością stworzonego projektu w pliku `__main__.py`
- Wydaj polecenie `pulumi up`
- Na potrzeby tego zadania każdy z uczestników musi dodać swoje środowisko do zdalnego zasobu zarządzania stanem (app.pulumi.com)
- Stwórz konto na potrzeby realizacji tego zadania (jest darmowe oraz można je stworzyć z wykorzystaniem GitHuba)
- Dodaj plik `index.html` w obecnym katalogu:

  ```html
  <html>
    <body>
        <h1>Hello, World!</h1>
    </body>
  </html>
  ```

- Zmodyfikuj plik `__main__.py` dodając:
  
  ```python
  public_access_block = s3.BucketPublicAccessBlock(
    'public-access-block', 
    bucket=bucket.id, 
    block_public_acls=False
  )
  def public_read_policy_for_bucket(bucket_name):
    return pulumi.Output.json_dumps({
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                pulumi.Output.format("arn:aws:s3:::{0}/*", bucket_name),
            ]
        }]
    })
  s3.BucketPolicy('bucket-policy',
    bucket=bucket.id,
    policy=public_read_policy_for_bucket(bucket.id), 
    opts=pulumi.ResourceOptions(depends_on=[public_access_block])
  )

  bucketObject = s3.BucketObject(
    'index.html',
    content_type='text/html',
    bucket=bucket.id,
    source=pulumi.FileAsset('index.html'),
  )
  ```

  zmień s3 bucket w następujący sposób:
  
  ```python
  bucket = s3.Bucket('my-bucket',
    website=s3.BucketWebsiteArgs(index_document="index.html")
  )
  ```
  
  ostatecznie zmień efekt końcowy tak by poznać adres statycznie stworzonej strony:

  ```python
  pulumi.export('bucket_endpoint', pulumi.Output.concat('http://', bucket.website_endpoint))
  ```

- Wydaj polecenie `pulumi preview` by zweryfikować wprowadzone zmiany
- Wykonaj polecenie `pulumi up` by wdrożyć zmiany
- Czy strona wynikowa działa?
- Zniszcz środowisko `pulumi down`

Pytania:

- Jakie języki programowania są wspierane przez Pulumi?
- Gdzie jest trzymany stan tworzonego stosu?

## Zadanie 5 - tworzenie lokalnego stosu

- Przejdź do katalogu pulumi/zad2
- Na potrzeby tego zadania zarówno jak i `__main__.py` zostały wstępnie przygotowane
- Zapoznaj się z plikiem i zaaplikuj go (tym razem nie ma obowiązku wydawania polecenia `pulumi new`)

Pytania:

- Porównaj tworzenie stosu z wykorzystaniem Pulumi do tworzenia stosu Terraform
