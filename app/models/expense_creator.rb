# frozen_string_literal: true

class ExpenseCreator < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :date, presence: true
end
