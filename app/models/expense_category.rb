# frozen_string_literal: true

class ExpenseCategory < ApplicationRecord
  belongs_to :user

  validates :user,        presence: true
  validates :name,        presence: true
  validates :description, presence: false
end
