variable "trusted_state_accounts" {
  description = "AWS accounts allowed to receive IAM access to specific state prefixes. Identity policies must still grant access to individual state objects."
  type = map(object({
    account_id = string
    prefixes   = list(string)
  }))

  default = {
    development = {
      account_id = "904054820030"
      prefixes = [
        "bootstrap/identity/development/*",
        "development/*"
      ]
    }
  }

  validation {
    condition = alltrue([
      for name, account in var.trusted_state_accounts : (
        can(regex("^[A-Za-z0-9]+$", name)) &&
        can(regex("^[0-9]{12}$", account.account_id)) &&
        length(account.prefixes) > 0 &&
        alltrue([
          for prefix in account.prefixes : (
            length(trimspace(prefix)) > 0 &&
            !startswith(prefix, "/")
          )
        ])
      )
    ])
    error_message = "Each trusted state account must have an alphanumeric name, a 12-digit account ID, and at least one relative S3 prefix."
  }
}
