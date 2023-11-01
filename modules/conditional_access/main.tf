resource "azuread_conditional_access_policy" "policy" {
  for_each     = { for policy in var.policies : policy.name => policy }
  display_name = each.value.name
  state        = each.value.state

  conditions {
    client_app_types    = each.value.conditions.client_app_types
    sign_in_risk_levels = each.value.conditions.sign_in_risk_levels
    user_risk_levels    = each.value.conditions.user_risk_levels

    applications {
      excluded_applications = each.value.conditions.applications.excluded_applications
      included_applications = each.value.conditions.applications.included_applications
      included_user_actions = each.value.conditions.applications.included_user_actions
    }

    dynamic "devices" {
      for_each = each.value.conditions.devices_rule != null ? [1] : []
      content {
        filter {
          mode = each.value.conditions.devices_rule.mode
          rule = each.value.conditions.devices_rule.rule
        }
      }
    }

    users {
      excluded_groups = each.value.conditions.users.excluded_groups
      excluded_roles  = each.value.conditions.users.excluded_roles
      excluded_users  = each.value.conditions.users.excluded_users
      included_groups = each.value.conditions.users.included_groups
      included_roles  = each.value.conditions.users.included_roles
      included_users  = each.value.conditions.users.included_users
    }

    locations {
      included_locations = each.value.conditions.locations.included_locations
      excluded_locations = each.value.conditions.locations.excluded_locations
    }

    platforms {
      included_platforms = each.value.conditions.platforms.included_platforms
      excluded_platforms = each.value.conditions.platforms.excluded_platforms
    }

  }

  grant_controls {
    built_in_controls             = each.value.grant_controls.built_in_controls
    operator                      = each.value.grant_controls.operator
    custom_authentication_factors = each.value.grant_controls.custom_authentication_factors
    terms_of_use                  = each.value.grant_controls.terms_of_use
  }

  dynamic "session_controls" {
    for_each = each.value.session_controls != null ? [1] : []
    content {
      application_enforced_restrictions_enabled = each.value.session_controls.application_enforced_restrictions_enabled
      cloud_app_security_policy                 = each.value.session_controls.cloud_app_security_policy
      persistent_browser_mode                   = each.value.session_controls.persistent_browser_mode
      sign_in_frequency                         = each.value.session_controls.sign_in_frequency
      sign_in_frequency_period                  = each.value.session_controls.sign_in_frequency_period
    }
  }
}
