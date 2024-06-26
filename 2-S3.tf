resource "aws_s3_bucket" "bucket" {
  bucket        = "joshbucke1986"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  /*error_document {
    key = "error.html"
  }*/
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "upload_images" {
  for_each     = fileset("${path.module}/", "*.png")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "image/png"
}

