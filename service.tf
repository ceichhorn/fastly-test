
variable "fastly_name" {
  type    = string
  default = "test.ceichhorn.com"
}

variable "s3_access_key_cust_log" {
  type    = string
  default = "default_access"
}

variable "s3_secret_key_cust_log" {
  type    = string
  default = "default_secret"
}

provider "fastly" {
	version = "~> 0.24.0"
}

resource "fastly_service_v1" "fastly" {
  name = "test.ceichhorn.com"

  ##### ceichhorn.com config #####
  domain {
    name = "${terraform.workspace == "production" ? "ceichhorn.com" : format("%s-%s", terraform.workspace, "ceichhorn.com")}"
  }
  domain {
    name = "${terraform.workspace == "production" ? "www.ceichhorn.com" : format("%s-%s", terraform.workspace, "www.ceichhorn.com")}"
  }
  backend {
    address               = "${terraform.workspace == "origin-staging" ? "stage.ydr.com" : "ux-east.ydr.com"}"
    name                  = "ux-east.ydr.com"
    shield                = "bwi-va-us"
    port                  = 443
    use_ssl               = true
    ssl_check_cert        = true
    ssl_sni_hostname      = "${terraform.workspace == "origin-staging" ? "stage.ydr.com" : "ux-east.ydr.com"}"
    ssl_cert_hostname     = "${terraform.workspace == "origin-staging" ? "stage.ydr.com" : "ux-east.ydr.com"}"
    request_condition     = "no_default_host"
    auto_loadbalance      = false
    between_bytes_timeout = 30000
    first_byte_timeout    = 30000
    connect_timeout       = 6000
  }

}
