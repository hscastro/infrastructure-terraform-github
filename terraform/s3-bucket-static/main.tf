provider "aws"{
    region = "us-east-1"
}

variable "bucket_name" {
    type = String
}


resource  "aws_s3_bucket" "static_site_bucket" {
    bucket = "static-site-${var.bucket_name}"

    website {
        index_document = "index.html"
        error_document = "400.html"
    } 

    tags {
        Name = "Static Site Bucket"
        Environment = "Production"
    }
}


resource "aws_s3_bucket_public_access_block" "static_site_bucket" {
    bucket = aws_s3_bucket.static_site_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_bucket = false
 }


resource "aws_s3_bucket_ownership_controls" "static_site_bucket" {
    bucket = aws_s3_bucket.static_site_bucket.id

    rule {
        object_ownership = "BucketOwnershipPreferred"
    }
 }


resource "aws_s3_bucket_acls" "static_site_bucket" {
    
    depends_on = [
        aws_s3_bucket_public_access_block.static_site_bucket,
        aws_s3_bucket_ownership_controls.static_site_bucket,        
    ]
    
    bucket = aws_s3_bucket.static_site_bucket.id
    acls = "public-read"
    
 }