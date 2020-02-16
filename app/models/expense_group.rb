# frozen_string_literal: true

class ExpenseGroup < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :delete_all

  validates :name, presence: true
  validates :user, presence: true
end
