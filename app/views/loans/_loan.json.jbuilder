# frozen_string_literal: true

json.extract! loan, :id, :description, :loan_date, :estimated_receipt_at, :received_at, :borrowed_amount, :expected_amount_to_receive, :person, :received_amount, :created_at, :updated_at
json.url loan_url(loan, format: :json)
