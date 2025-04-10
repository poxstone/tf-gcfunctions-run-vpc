variable "name" {
  type        = string
  description = ""
}

variable "region" {
  type        = string
  description = ""
  default     = "us-central1"
}

variable "project" {
  type        = string
  description = ""
}

variable "source_path" {
  type        = string
  description = "example: /src/cloud-functions/cf-bq-copy-sync/"
}

variable "description" {
  type        = string
  description = "descripcion para la funcion"
  default     = ""
}

variable "runtime" {
  type        = string
  description = "example: python310"
}

variable "entrypoint" {
  type        = string
  description = "nombre de la función principal del codigo. example: copy_qb"
}

variable "max_instance_request_concurrency" {
  type        = number
  description = "Cantidad de solicitudes por instancia"
  default     = 1
}

variable "max_instance_count" {
  type        = number
  description = "Maxima cantidad de instancia"
  default     = 100
}

variable "available_memory" {
  type        = string
  description = "Cantidad de memoria por instancia Mi"
  default     = "512Mi"
}

variable "available_cpu" {
  type        = number
  description = "Cantidad de memoria por instancia Mi"
  default     = 0.3333
}

variable "timeout_seconds" {
  type        = number
  description = "Timeout en segundos"
  default     = 300
}

variable "sa_cloud_functions" {
  type        = string
  description = "Email de la cuenta de servicio"
}

variable "default_location" {
  type        = string
  description = "Ubicación geografica"
  default     = "US"
}

variable "environment_variables" {
  type        = any
  description = "Variables de entorno"
  default     = {}
}

variable "event_region" {
  type        = string
  description = "Region del Evento"
  default     = "us-central1"
}

variable "event_type" {
  type        = string
  description = "evento example: google.cloud.pubsub.topic.v1.messagePublished"
  default     = null
}

variable "event_pubsub_topic" {
  type        = string
  description = "topic example: projects/_PROJECT_/topics/ps-bigquery-sync-tables-datalakes"
  default     = null
}

variable "event_retry_policy" {
  type        = string
  description = "Valor de constante para Reintentos"
  default     = "RETRY_POLICY_DO_NOT_RETRY"
}

variable "event_service_account_email" {
  type        = string
  description = "service account for event logs"
  default     = ""
}

variable "build_service_account_email" {
  type        = string
  description = "service account for event logs"
  default     = null
}

variable "event_filters" {
  type        = any
  description = "Filtro del evento"
  default     = []
}

variable "bucket_functions" {
  type        = string
  description = "Bucket para cloud functions"
}

variable "secret_environment_variables" {
  type        = any
  description = "Listado de configuraciones para variables de secretos"
  default     = []
}

variable "secret_volumes" {
  type        = any
  description = "Listado de configuraciones para volumenes de secretos"
  default     = []
}

variable "labels" {
  type        = any
  description = "Etiquetas de servicio para categorizar"
  default     = {}
}

variable "vpc_connector" {
  type        = string
  description = "VPC connector for enrute trafict"
  default     = null
}

variable "vpc_connector_egress_settings" {
  type        = string
  description = "VPC connector Eggress options (VPC_CONNECTOR_EGRESS_SETTINGS_UNSPECIFIED, PRIVATE_RANGES_ONLY, ALL_TRAFFIC)"
  default     = null
}

variable "ingress_settings" {
  type        = string
  description = "VPC connector Eggress options (ALLOW_ALL, ALLOW_INTERNAL_ONLY, ALLOW_INTERNAL_AND_GCLB.)"
  default     = null
}
