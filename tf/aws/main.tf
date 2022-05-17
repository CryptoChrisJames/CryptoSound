resource "aws_ecs_cluster" "scp_cluster_qa" {
    name = "scp-cluster-qa"
}

resource "aws_ecs_cluster" "scp_cluster_stage" {
    name = "scp-cluster-stage"
}

resource "aws_ecs_cluster" "scp_cluster_prod" {
    name = "scp-cluster-prod"
}