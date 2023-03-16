variable "region" {
  description = "AWS region. Default is eu-west-2 (London)."
  default     = "eu-west-2"
}

variable "profile" {
  description = "AWS profile to use. I have multiple configured on my machine."
  default     = "personal"
}

variable "availability_zones" {
  description = "Two availability zones to use in this region."
  type = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}