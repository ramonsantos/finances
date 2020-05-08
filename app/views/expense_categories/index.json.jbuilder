# frozen_string_literal: true

json.array! @expense_categories, partial: 'expense_categories/expense_category', as: :expense_category
