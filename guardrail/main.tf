locals {
  words_config_entities = split("\n", file("words.txt"))
}


resource "aws_bedrock_guardrail" "strong_guardrail" {
  name                      = var.guardrail_name
  blocked_input_messaging   = var.blocked_input_messaging
  blocked_outputs_messaging = var.blocked_output_messaging
  description               = var.guardrail_description

  # Filter inputs and outputs based on potential offensive speech
  content_policy_config {

    dynamic "filters_config" {
      for_each = var.content_policies_entities
      content {
        input_strength  = var.content_policy_input_filtering_strength
        output_strength = var.content_policy_output_filtering_strength
        type            = filters_config.value
      }
    }

    filters_config {
      input_strength  = var.content_policy_input_filtering_strength
      output_strength = "NONE"
      type            = "PROMPT_ATTACK"
    }
  }

  # Filter inputs and outputs based on common PII patterns
  sensitive_information_policy_config {
    dynamic "pii_entities_config" {
      for_each = var.pii_entities
      content {
        action = var.pii_action
        type   = pii_entities_config.value
      }
    }

    # Filter inputs and outputs based on common custom regex patterns
    dynamic "regexes_config" {
      for_each = var.regexes_config_entities
      content {
        action      = var.regexes_action
        description = regexes_config.value.description
        name        = regexes_config.value.name
        pattern     = regexes_config.value.pattern
      }
    }
  }

  # Filter sensitive topics
  topic_policy_config {
    dynamic "topics_config" {
      for_each = var.topics_policy_entities
      content {
        name       = topics_config.value.name
        examples   = topics_config.value.examples
        definition = topics_config.value.definition
        type       = "DENY"
      }
    }
  }

  # Filter some offensive words
  word_policy_config {
    managed_word_lists_config {
      type = "PROFANITY"
    }
    dynamic "words_config" {
      for_each = local.words_config_entities
      content {
        text = words_config.value
      }
    }
  }

  contextual_grounding_policy_config {
    filters_config {
      threshold = var.grounding_policy_threshold
      type      = "GROUNDING"
    }

    filters_config {
      threshold = var.grounding_policy_threshold
      type      = "RELEVANCE"
    }
  }
}