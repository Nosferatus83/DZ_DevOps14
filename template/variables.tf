variable "vm" {
  description = "Count VM instance" 
  type    = number
  default = 2 
}

variable "cpu" {
  type    = number
  default = 2
}

variable "ram" {
  type    = number
  default = 8 // AMOUNT_OF_MEMORY_MB Gb*1024=Mb
}