resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.aws_ecs_cluster_name
}

data "template_file" "demo_ecs_app" {
  template = file("./templates/lara_ecs_app.json.tpl")
  vars = {
    app_image      = aws_ecr_repository.demo_ecs_app.repository_url
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    tag            = var.tag
    name           = var.aws_ecr_repository
  }
}




resource "aws_ecs_task_definition" "demo_ecs_app_def" {

  family                   = var.aws_ecs_task_def_fam
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  #   container_definitions    = data.template_file.demo_ecs_app.render
  container_definitions = jsonencode([
    {
      name   = var.aws_ecr_repository
      image  = "810456314582.dkr.ecr.ap-south-1.amazonaws.com/my-first-ecr-repo"
      cpu    = var.fargate_cpu
      memory = var.fargate_memory
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = var.aws_ecs_service_name
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.demo_ecs_app_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  


}