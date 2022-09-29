terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.44.3"
    }
    # http = {
    #   source  = "hashicorp/http"
    #   version = "3.0.0"
    # }
    http-full = {
      source = "salrashid123/http-full"
    }
  }
  required_version = ">= 1.0.4"
}
