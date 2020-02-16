# frozen_string_literal: true

class ExpenseGroup < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :user, presence: true
end
