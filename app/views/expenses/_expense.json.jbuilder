# frozen_string_literal: true

json.extract! expense, :id, :description, :amount, :date, :fixed, :remark, :created_at, :updated_at
json.url expense_url(expense, format: :json)