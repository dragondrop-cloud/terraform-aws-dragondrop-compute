data "aws_iam_policy_document" "ecs_task_executor" {
  statement {
    actions = [
      "ecs:RunTask",
      "ecs:StartTask",
    ]
    effect    = "Allow"
    resources = [var.ecs_task_arn]
  }
}
