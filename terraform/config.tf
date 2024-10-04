provider "aws" { 
    region = "us-east-1"
    alias= "default_region"
    
    default_tags {
    tags = {
      Project     = "devsu-test"
      DevOps      = "Enrique Cruz"
    }
  }


}

terraform {
    required_version = "~> 1.9.6"

    required_providers {
      aws = {
        source= "hashicorp/aws"
        version = "~> 5.68.0"
      }
    }
    
    backend "s3" {
        region= "us-east-1"
    }

}
