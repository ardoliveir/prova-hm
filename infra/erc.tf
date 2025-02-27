module "ecr_backend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "backend"

  # IAM roles with read/write access to the repository
  repository_read_write_access_arns = ["arn:aws:iam::715841332943:user/anderson"]

  # Lifecycle policy: Keep the last 30 images with tag prefix "v"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  # Apply default tags
  tags = var.additional_tags
}

module "ecr_frontend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "frontend"

  repository_read_write_access_arns = ["arn:aws:iam::715841332943:user/anderson"]

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["release"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  # Apply default tags
  tags = var.additional_tags
}
