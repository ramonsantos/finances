# frozen_string_literal: true

json.array! @expense_groups, partial: 'expense_groups/expense_group', as: :expense_group
