terraform {
  backend "s3" {
    bucket = "terraformhenrystatefile"
    key    = "henryterrafom.tfstate"
    region = "us-west-1"
    profile = "terraformprofile"
  }
}
