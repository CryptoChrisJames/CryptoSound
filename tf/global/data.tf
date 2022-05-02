data "google_container_registry_repository" "gcp_container_repo" {
    project = var.gcp_project
}