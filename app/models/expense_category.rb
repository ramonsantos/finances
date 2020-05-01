# frozen_string_literal: true

class ExpenseCategory < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :restrict_with_exception

  validates :user,        presence: true
  validates :name,        presence: true
  validates :description, presence: false
end
