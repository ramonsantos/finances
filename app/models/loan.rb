# frozen_string_literal: true

class Loan < ApplicationRecord
  paginates_per 20

  belongs_to :user

  validates :user,            presence: true
  validates :person,          presence: true
  validates :description,     presence: true
  validates :borrowed_amount, presence: true
  validates :loan_date,       presence: true
  validates :received_amount, presence: false
  validates :received_at,     presence: false

  encrypts :person
  encrypts :description
  encrypts :borrowed_amount, type: :float
  encrypts :received_amount, type: :float

  scope :fetch_order_by_loan_date, lambda { |user|
    where(user: user).order(:loan_date)
  }
end
