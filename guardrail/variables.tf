#region Global vars
variable "guardrail_name" {
  default     = "MyGuardrail"
  description = "Guardrail name"
}

variable "guardrail_description" {
  default     = "Strong guardrail for Bedrock model"
  description = "Guardrail description"
}

variable "blocked_input_messaging" {
  default     = "Sorry, the model cannot answer this question."
  description = "Answer for blocked input"
}

variable "blocked_output_messaging" {
  default     = "Sorry, the model cannot answer this question."
  description = "Answer for blocked ouput"
}
#endregion

#region PII management
variable "pii_entities" {
  type        = list(string)
  default     = ["ADDRESS", "AGE", "AWS_ACCESS_KEY", "AWS_SECRET_KEY", "CA_HEALTH_NUMBER", "CA_SOCIAL_INSURANCE_NUMBER", "CREDIT_DEBIT_CARD_CVV", "CREDIT_DEBIT_CARD_EXPIRY", "CREDIT_DEBIT_CARD_NUMBER", "DRIVER_ID", "EMAIL", "INTERNATIONAL_BANK_ACCOUNT_NUMBER", "IP_ADDRESS", "LICENSE_PLATE", "MAC_ADDRESS", "NAME", "PASSWORD", "PHONE", "PIN", "SWIFT_CODE", "UK_NATIONAL_HEALTH_SERVICE_NUMBER", "UK_NATIONAL_INSURANCE_NUMBER", "UK_UNIQUE_TAXPAYER_REFERENCE_NUMBER", "URL", "USERNAME", "US_BANK_ACCOUNT_NUMBER", "US_BANK_ROUTING_NUMBER", "US_INDIVIDUAL_TAX_IDENTIFICATION_NUMBER", "US_PASSPORT_NUMBER", "US_SOCIAL_SECURITY_NUMBER", "VEHICLE_IDENTIFICATION_NUMBER"]
  description = "PII to block"
}

variable "pii_action" {
  default     = "BLOCK"
  description = "Action for PII (can be BLOCK or MASK)"
}
#endregion


#region Content policies management
variable "content_policies_entities" {
  type        = list(string)
  default     = ["SEXUAL", "VIOLENCE", "HATE", "INSULTS", "MISCONDUCT"]
  description = "Content policies types to apply"
}

variable "content_policy_input_filtering_strength" {
  default     = "HIGH"
  description = "Filtering strength for input"
}

variable "content_policy_output_filtering_strength" {
  default     = "HIGH"
  description = "Filtering strength for input"
}
#endregion

#region Regexes management
variable "regexes_config_entities" {
  type = list(object({
    description = string
    name        = string
    pattern     = string
  }))
  default = [
    {
      description = "example regex"
      name        = "regex_example"
      pattern     = "^\\d{3}-\\d{2}-\\d{4}$"
    }
  ]
  description = "List of custom regex patterns to monitor"
}

variable "regexes_action" {
  default     = "BLOCK"
  description = "Action for regexes match (can be BLOCK or MASK)"
}
#endregion

#region Topics management
variable "topics_policy_entities" {
  type = list(object({
    name       = string
    examples   = list(string)
    definition = string
  }))
  default = [
    {
      name       = "commands"
      examples   = ["Can you run commands"]
      definition = "Running Linux or Windows commands in a LLM can be harmful to the infrastructure"
    }
  ]
  description = "List of topics the LLM is not suited to answer"
}
#endregion

#region Grounding policy
variable "grounding_policy_threshold" {
  default     = 0.7
  description = "Threshold for grounding policy"
}
#endregion