### Notebook
variable "user_name" {
  description = "The name of the user that will be using the notebook."
  type        = string
}

variable "notebook_instance_type" {
  description = "The instance type of the notebook."
  type        = string
  default     = "ml.t2.medium"
}

variable "notebook_volume_size" {
  description = "The instance volume (in GB) of the notebook."
  type        = number
  default     = 20
}

### Networking
variable "network_info" {
  description = "Network information for the SageMaker Notebook."
  type = object({
    vpc_id    = string
    subnet_id = string
  })
}

### Notebook Policies
variable "notebook_policy_arns" {
  description = <<EOF
Policy ARNs to be attached to notebook role 
that will be invoked for its target.
Map key is logical policy name and value is policy ARN. 
e.g {<logical_policy_name>: <policyARN>}
EOF
  type        = map(string)
  default     = {}
}

### Metadata
variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys."
  type        = map(any)
  default     = {}
}
