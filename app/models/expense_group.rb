# frozen_string_literal: true

class ExpenseGroup < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :user, presence: true
end
