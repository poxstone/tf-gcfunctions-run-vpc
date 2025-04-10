provider "google" {
  project      = "p4-operations-dev"
  region       = "US"
  zone         = "us-central1"
  access_token = replace(file("token.txt"), "\n", "")
}