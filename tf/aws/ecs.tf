resource "aws_ecs_task_definition" "scp_cs_ui_task" {
    family                   = "scp-cs-ui-task-${var.env}" # Naming our first task
    container_definitions    = <<DEFINITION
    [
        {
        "name": "scp-cs-ui-task-${var.env}",
        "image": "${var.ecr_ui_repo_url}",
        "essential": true,
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
        }
    ]
    DEFINITION
    requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
    network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
    memory                   = 512         # Specifying the memory our container requires
    cpu                      = 256         # Specifying the CPU our container requires
    execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
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
    task_definition = "${aws_ecs_task_definition.scp_cs_ui_task.arn}" # Referencing the task our service will spin up
    launch_type     = "FARGATE"
    desired_count   = 1 # Setting the number of containers we want deployed to 1
    network_configuration {
        subnets = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
        assign_public_ip = true
    }
}

# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
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
}