resource "aws_ecr_repository" "market_tracker_repo" {
  name                 = "market-tracker-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}