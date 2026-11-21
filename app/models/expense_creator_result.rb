# frozen_string_literal: true

class ExpenseCreatorResult < ApplicationRecord
  belongs_to :expense_creator, counter_cache: :expense_creator_results_count

  validates :raw_content, :details, presence: true
end
