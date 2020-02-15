# frozen_string_literal: true

json.extract! expense_group, :id, :name, :created_at, :updated_at
json.url expense_group_url(expense_group, format: :json)
