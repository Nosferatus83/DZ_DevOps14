variable "kol" {
  description = "Count VM instance" 
  default = 1 // AMOUNT_OF_MEMORY_MB Gb*1024=Mb
}

variable "vCPU" {
  type    = string
  default = "2"
}

variable "RAM" {
  type    = string
  default = "8192" // AMOUNT_OF_MEMORY_MB Gb*1024=Mb
}