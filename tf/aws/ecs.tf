
resource "aws_ecs_task_definition" "scp_cs_ui_task" {
    family                   = "scp-cs-ui-task" # Naming our first task
    container_definitions    = <<DEFINITION
    [
        {
        "name": "scp-cs-ui-task",
        "image": "${var.ecr_ui_repo_url}",
        "essential": true,
        "portMappings": [
            {
            "containerPort": 3000,
            "hostPort": 3000
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

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
        type        = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}