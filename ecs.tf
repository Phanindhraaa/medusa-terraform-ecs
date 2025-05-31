resource "aws_ecs_cluster" "medusa_cluster" {
  name = var.cluster_name

  tags = {
    Environment = "medusa"
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "medusa-lb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-lb-sg"
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "medusa-ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # only allow from ALB SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-ecs-sg"
  }
}

resource "aws_lb" "alb" {
  name               = "medusa-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id

  tags = {
    Name = "medusa-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "medusa-tg"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/health"
  }

  tags = {
    Name = "medusa-tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                   = var.service_name
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = var.container_name
    image = var.container_image
    portMappings = [{
      containerPort = var.port
    }]
    environment = [
      { name = "MEDUSA_ADMIN_CORS", value = "*" },
      { 
        name  = "DATABASE_URL", 
        value = format(
          "postgresql://%s:%s@%s:%d/%s",
          var.db_username,
          var.db_password,
          aws_db_instance.medusa_rds.address,
          5432,
          var.db_name
        )
      }
    ]
  }])
}


resource "aws_ecs_service" "medusa_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public.*.id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.container_name
    container_port   = var.port
  }
}
