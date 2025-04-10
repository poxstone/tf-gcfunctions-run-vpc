# DEPLOY

## scripts

- Deploy
´´´bash
gcloud auth print-access-token > token.txt;
terraform apply --auto-approve;
´´´
- enable services
´´´bash
gcloud services enable containeranalysis.googleapis.com;
# shared/host and service net project
gcloud services enable vpcaccess.googleapis.com;
´´´

- Test
´´´bash
HOST="https://gcf-test-network-01-${HOST_PROJECT_NUM}.us-central1.run.app";
HOST="https://us-central1-${PROJECT_ID}.cloudfunctions.net/gcf-test-network-01";
HOST="https://gcf-test-network-01-ezada3dyfq-uc.a.run.app";

curl -X GET "${HOST}?url=https://example.com&method=GET"  \
-H "Authorization: Bearer $(gcloud auth print-identity-token)";
´´´

- vpc connection permissions
´´´bash
HOST_PROJECT_ID="p4-net0-01";
SERVICE_PROJECT_NUMBER="28443687020";
gcloud projects add-iam-policy-binding ${HOST_PROJECT_ID} \
  --member="serviceAccount:service-${SERVICE_PROJECT_NUMBER}@serverless-robot-prod.iam.gserviceaccount.com" \
  --role="roles/compute.networkUser"

gcloud projects add-iam-policy-binding ${HOST_PROJECT_ID} \
  --member="serviceAccount:service-${SERVICE_PROJECT_NUMBER}@gcp-sa-vpcaccess.iam.gserviceaccount.com" \
  --role="roles/compute.networkUser"

´´´

- rangos vpc host shared
-- Rango de IP de la infraestructura sin servidores: 35.199.224.0/19
-- Rangos de IP de sondeo de verificación de estado: 35.191.0.0/16, 35.191.192.0/18 y 130.211.0.0/22

# Cloud Functions API
- obtener las politicas sde la organizacion
gcloud org-policies list-custom-constraints --organization=ORGANIZATION_ID