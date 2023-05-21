resource "aws_security_group" "lb" {
  name   = var.aws_sg_name
  vpc_id = module.vpc.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = var.app_port
    protocol    = "tcp"
    to_port     = var.app_port
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}