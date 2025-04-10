locals {
  ENV_ONLY_DEV                = 1
  env                         = "dev"
  datalake_project_id         = "emp-data-sto-dev"
  datalake_project_num        = "28443687020"
  network_project_id          = "p4-net0-01"
  network_project_num         = "500280478445"
  operations_project_id       = "p4-operations-dev"
  sa_cloud_functions          = "sa-app-test1@p4-operations-dev.iam.gserviceaccount.com"
  build_service_account_email = "28443687020-compute@developer.gserviceaccount.com"
  default_location            = "US"
  #sa_cloud_functions  = "sa-gcf-raw-sync-to-dtlk@p4-operations-dev.iam.gserviceaccount.com"
}

module "cloudfunction_gcf_test_network_01" {
  source                        = "./module-gcp-terraform-cloud-functions-v2"
  count                         = local.ENV_ONLY_DEV
  project                       = local.operations_project_id
  name                          = "gcf-test-network-01"
  source_path                   = "src/cloud_functions/gcf-test-network-01/"
  runtime                       = "python311"
  entrypoint                    = "test_http"
  bucket_functions              = "${local.operations_project_id}-gcf-source"
  description                   = "Test for vpc shared ${local.env}"
  sa_cloud_functions            = local.sa_cloud_functions
  build_service_account_email   = local.build_service_account_email
  available_memory              = "128Mi"
  available_cpu                 = 0.333
  max_instance_count            = 2
  vpc_connector                 = "projects/${local.operations_project_id}/locations/us-central1/connectors/vpcless-shared-dev"
  vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"
  environment_variables = {
    PROJECT_ID          = local.operations_project_id
    PROJECT_ID_DATALAKE = local.datalake_project_id
    LOCATION            = local.default_location
  }
  labels = {
    label_1 = "value_1"
  }
}

/*
data "google_cloud_run_service" "cloudfunction_gcf_test_network_01" {
  project  = local.operations_project_id
  name     = "gcf-test-network-01"
  location = "us-central1"
}
*/
