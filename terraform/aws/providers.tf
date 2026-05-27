provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.default_tags,
      {
        ManagedBy = "terraform"
        Project   = var.project_name
      }
    )
  }
}
