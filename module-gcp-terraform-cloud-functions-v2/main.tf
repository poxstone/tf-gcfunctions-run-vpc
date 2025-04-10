# require "roles/pubsub.publisher" for "serviceAccount:service-${data.google_project.project_id.number}@cloudcomposer-accounts.iam.gserviceaccount.com"

locals {
  fc_prefix_name = var.name
  str_date       = formatdate("YYMMDDhhmmss", timestamp())
}

data "archive_file" "zip_cloud_function" {
  type        = "zip"
  source_dir  = var.source_path
  output_path = "${local.fc_prefix_name}.zip"
}

resource "google_storage_bucket_object" "obj_function" {
  name = "${local.fc_prefix_name}.zip#${data.archive_file.zip_cloud_function.output_md5}"
  #  name       = "${local.fc_prefix_name}.zip"
  bucket     = var.bucket_functions
  source     = data.archive_file.zip_cloud_function.output_path
  depends_on = [data.archive_file.zip_cloud_function]
}

resource "google_cloudfunctions2_function" "cloud_function2_deploy" {
  project     = var.project
  name        = local.fc_prefix_name
  location    = var.region
  description = var.description

  build_config {
    runtime         = var.runtime
    entry_point     = var.entrypoint
    service_account = var.build_service_account_email == null ? "projects/${var.project}/serviceAccounts/${var.sa_cloud_functions}" : "projects/${var.project}/serviceAccounts/${var.build_service_account_email}"
    source {
      storage_source {
        bucket = var.bucket_functions
        object = google_storage_bucket_object.obj_function.name
      }
    }
  }

  service_config {
    max_instance_request_concurrency = var.max_instance_request_concurrency
    max_instance_count               = var.max_instance_count
    available_memory                 = var.available_memory
    available_cpu                    = var.available_cpu
    timeout_seconds                  = var.timeout_seconds
    service_account_email            = var.sa_cloud_functions
    environment_variables            = var.environment_variables
    vpc_connector                    = var.vpc_connector
    vpc_connector_egress_settings    = var.vpc_connector_egress_settings
    ingress_settings                 = var.ingress_settings

    dynamic "secret_environment_variables" {
      for_each = var.secret_environment_variables
      content {
        key        = secret_environment_variables.value["key"]        # MI_VAR
        project_id = secret_environment_variables.value["project_id"] # project-id
        secret     = secret_environment_variables.value["secret"]     # secret-name
        version    = secret_environment_variables.value["version"]    # latest
      }
    }

    dynamic "secret_volumes" {
      for_each = var.secret_volumes
      content {
        mount_path = secret_volumes.value["mount_path"] # /variable.txt
        project_id = secret_volumes.value["project_id"] # project-id
        secret     = secret_volumes.value["secret"]     # secret-name
        versions {
          path    = secret_volumes.value["path"]    # secret-name
          version = secret_volumes.value["version"] # latest
        }
      }
    }

  }

  dynamic "event_trigger" {
    for_each = var.event_type != null ? [1] : []
    content {
      event_type            = var.event_type
      trigger_region        = var.event_region
      pubsub_topic          = var.event_pubsub_topic
      retry_policy          = var.event_retry_policy
      service_account_email = var.event_service_account_email == "" ? var.sa_cloud_functions : var.event_service_account_email

      dynamic "event_filters" {
        for_each = var.event_filters
        content {
          attribute = event_filters.value["attribute"]
          value     = event_filters.value["value"]
        }
      }
    }
  }

  depends_on = [google_storage_bucket_object.obj_function]
  labels     = var.labels
}
