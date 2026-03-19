variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "mandatory_tags" {
  type = map(string)
  default = {
    owner       = "equipo-devops"
    environment = "produccion"
    app         = "backend-api"
    controlcost = "cc-10293"
  }
}