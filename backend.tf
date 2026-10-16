terraform {
  backend "gcs" {
    bucket = "itsx25-comerit-team1-tfstate"
    prefix = "terraform/state"
  }
}
