
resource "aws_ecr_repository" "desafio-devops" {
  name                 = "desafio-devops"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "desafio-devops" {
  repository = aws_ecr_repository.desafio-devops.name
  policy     = data.aws_iam_policy_document.ecr-policy.json
}


data "aws_iam_policy_document" "ecr-policy" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["339712957572"]
    }

    actions = [
      "ecr:*",
    ]
  }
}