variable "oci_private_key" {
  default     = "/root/.oci/oci_api_key.pem"
  description = "description"
}

variable "ssh_public_key" {
  default     = "/root/.oci/my_public_key.pub"
  description = "description"
}

#variable "BootStrapFile_ol7" {
    #default = "/home/ubuntu/Downloads/install_kubernetes.sh"
#}


variable "assign_public_ip" {
  #! Deprecation notice: will be removed at next major release. Use `var.public_ip` instead.
  description = "Deprecated: use `var.public_ip` instead. Whether the VNIC should be assigned a public IP address (Always EPHEMERAL)."
  type        = bool
  default     = false
}

variable "public_ip" {
  description = "Whether to create a Public IP to attach to primary vnic and which lifetime. Valid values are NONE, RESERVED or EPHEMERAL."
  type        = string
  default     = "NONE"

   validation {
    condition     = contains(["NONE", "RESERVED", "EPHEMERAL"], var.public_ip)
    error_message = "Accepted values are NONE, RESERVED or EPHEMERAL."
  }

}
