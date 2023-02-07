resource "aws_ecs_cluster" "-" {
  name = "weather-app-demo"
}

resource "aws_ecs_task_definition" "-" {
  family                   = "weather-app-demo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "weather-app-demo",
    "image": "${var.image_repo_url}:${var.image_tag}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.-.name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "weather-app-demo"
      }
    }
  }
]
DEFINITION

  execution_role_arn = aws_iam_role.task_definition_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_cloudwatch_log_group" "-" {
  name = "/ecs/weather-app-demo"
}

resource "aws_ecs_service" "-" {
  name            = "weather-app-demo"
  cluster         = aws_ecs_cluster.-.id
  task_definition = aws_ecs_task_definition.-.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.-.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.-.arn
    container_name   = "weather-app-demo"
    container_port   = 5000
  }
}

resource "aws_security_group" "-" {
  name        = "weather-app-demo"
  description = "Allow inbound traffic to weather app"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP from anywhere"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb_target_group" "-" {
  name        = "weather-app-demo"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "weather-app-demo" {
  name               = "weather-app-demo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.weather-app-demo.id]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "weather-app-demo"
  }
}

resource "aws_lb_listener" "-" {
  load_balancer_arn = aws_lb.weather-app-demo.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.-.arn
  }
}

resource "aws_lb_listener_rule" "-" {
  listener_arn = aws_lb_listener.-.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.-.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}


resource "aws_iam_role" "task_definition_role" {
  name = "weather_demo_task_definition"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "task_definition_policy" {
  name = "weather_demo_task_definition_policy"
  role = aws_iam_role.task_definition_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "secretsmanager:GetSecretValue",
        "ssm:GetParameters"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
