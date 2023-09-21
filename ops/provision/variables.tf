variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "keel_password" {
}

variable "pg_bucket" {
  default = "samvera-pg"
}

variable "aws_access_key_id" {
}

variable "aws_secret_access_key" {
}

variable "pg_alpha_databases" {
  default = "fcrepo,hyku-dev-hyrax,hyku-production-hyrax"
}
