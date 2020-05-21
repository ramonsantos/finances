# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  # User
  :password,

  # Expense
  :description,
  :amount,
  :date,
  :fixed,
  :remark,

  # Loan
  :person,
  :borrowed_amount,
  :loan_date,
  :received_amount,
  :received_at
]
