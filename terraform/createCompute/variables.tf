variable "dataTagName" {
  description = "Type Tag Name to be used as to fetch values to existing resources"
  default = "kul"
}
variable "tagName" {
  description = "Type your Name to be used as TAGNAME for resources"
  type = string
}
variable "keyPath" {
  description = "Provide path to your pem file in c:/keys/key.pem format"
  type = string
}