resource "aws_ecs_task_definition" "cs_ui_task" {
    family                   = "cs-ui-task-${var.env}" # Naming our first task
    container_definitions    = <<DEFINITION
    [
        {
        "name": "cs-ui-task-${var.env}",
        "image": "${var.ecr_ui_repo_url}",
        "essential": true,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "${var.app_name}-${var.env}"
            }
        },
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            },
            {
                "containerPort": 443,
                "hostPort": 443
            }
        ],
            "memory": 512,
            "cpu": 256
        },
        "secrets": [
            {
                "name": "ENV_VARS",
                "value": "${ecs__servcie_secrets}"
            }
        ]
    ]
    DEFINITION
    requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
    network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
    memory                   = 512         # Specifying the memory our container requires
    cpu                      = 256         # Specifying the CPU our container requires
    execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
    task_role_arn            = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name               = "ecsTaskExecutionRole"
    assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "cs_ui_service" {
    name            = "cs-ui-service-${var.env}"                             # Naming our first service
    cluster         = local.ecs_cluster             # Referencing our created Cluster
    task_definition = "${aws_ecs_task_definition.cs_ui_task.arn}" # Referencing the task our service will spin up
    launch_type     = "FARGATE"
    desired_count   = 1 # Setting the number of containers we want deployed to 1
    network_configuration {
        subnets = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
        assign_public_ip = true
        security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
    }
    load_balancer {
        target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
        container_name   = "${aws_ecs_task_definition.cs_ui_task.family}"
        container_port   = 80 # Specifying the container port
    }
}

resource "aws_alb" "application_load_balancer" {
    name               = "cs-alb" # Naming our load balancer
    load_balancer_type = "application"
    subnets = [ # Referencing the default subnets
        "${aws_default_subnet.default_subnet_a.id}",
        "${aws_default_subnet.default_subnet_b.id}"
    ]
    # Referencing the security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
    ingress {
        from_port   = 80 # Allowing traffic in from port 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
    }

    ingress {
        from_port   = 443 # Allowing traffic in from port 80
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
    }

    egress {
        from_port   = 0 # Allowing any incoming port
        to_port     = 0 # Allowing any outgoing port
        protocol    = "-1" # Allowing any outgoing protocol
        cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
    }
}

resource "aws_security_group" "service_security_group" {
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        # Only allowing traffic in from the load balancer security group
        security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
    }

    egress {
        from_port   = 0 # Allowing any incoming port
        to_port     = 0 # Allowing any outgoing port
        protocol    = "-1" # Allowing any outgoing protocol
        cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
    }
}
resource "aws_lb_target_group" "target_group" {
    name        = "cs-target-group-${var.env}"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = "${aws_default_vpc.default_vpc.id}" # Referencing the default VPC
    health_check {
        matcher = "200,301,302"
        path = "/"
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = "${aws_alb.application_load_balancer.arn}" # Referencing our load balancer
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our tagrte group
    }
}

resource "aws_cloudwatch_log_group" "log-group" {
    name = "cs-ui-logs-${var.env}"

    tags = {
        Application = var.app_name
        Environment = var.env
    }
}

# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
    tags = {
        Name = "Default VPC"
    }
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
    availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
    availability_zone = "us-east-1b"
}

locals {
    ecs_cluster = var.env == "prod" ? aws_ecs_cluster.scp_cluster_prod.id : var.env == "stage" ? aws_ecs_cluster.scp_cluster_stage.id : aws_ecs_cluster.scp_cluster_qa.id
    ecs__servcie_secrets = var.env == "qa" ? "arn:aws:secretsmanager:us-east-1:482352589093:secret:qa-cs-config-bNTQ2q" : ""
}