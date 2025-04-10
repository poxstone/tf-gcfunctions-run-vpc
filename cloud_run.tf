resource "google_cloud_run_v2_service" "tf_flask_any_response" {
  name                 = "tf-flask-any-response"
  client               = "cloud-console"
  project              = local.operations_project_id
  invoker_iam_disabled = true
  location             = "us-central1"
  deletion_protection  = false
  ingress              = "INGRESS_TRAFFIC_ALL"

  build_config {
    service_account = local.sa_cloud_functions
  }

  template {
    service_account = local.sa_cloud_functions
    containers {
      name  = "flask-any-response-1"
      image = "poxstone/flask_any_response"
      env {
        name  = "variable1"
        value = "valor1"
      }
    }

    vpc_access {
      # only use if "network_interfaces" is not set
      #connector = "projects/${local.operations_project_id}/locations/us-central1/connectors/vpcless-local-dev"
      connector = "projects/${local.operations_project_id}/locations/us-central1/connectors/vpcless-shared-dev"
      egress    = "ALL_TRAFFIC" # PRIVATE_RANGES_ONLY, ALL_TRAFFIC

      ## only use if "connector" is not set
      #network_interfaces {
      #  #network    = "vpc-local"
      #  #subnetwork = "us-central-local"
      #  # shared vpc (vpc-direct-vpc) https://cloud.google.com/run/docs/configuring/vpc-direct-vpc?hl=es-419
      #  network    = "projects/${local.network_project_id}/global/networks/vpc-emp-datalake-dev"
      #  subnetwork = "projects/${local.network_project_id}/regions/us-central1/subnetworks/subnet-datalake-dev"
      #  tags = [
      #    "gcr",
      #  ]
      #}
    }
  }

  labels = {
    label_1 = "value_1"
  }
}
# export URL="https://tf-flask-any-response-28443687020.us-central1.run.app";
# curl -X GET "${URL}/requests/http/10.20.136.2/80?path=/";

output "cloudrun" {
  value = google_cloud_run_v2_service.tf_flask_any_response
}
