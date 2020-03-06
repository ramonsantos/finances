# frozen_string_literal: true

class Loan < ApplicationRecord
  paginates_per 20

  belongs_to :user

  validates :user,                       presence: true
  validates :person,                     presence: true
  validates :description,                presence: true
  validates :borrowed_amount,            presence: true
  validates :loan_date,                  presence: true
  validates :estimated_receipt_at,       presence: false
  validates :expected_amount_to_receive, presence: false
  validates :received_amount,            presence: false
  validates :received_at,                presence: false

  encrypts :person
  encrypts :description
  encrypts :borrowed_amount,            type: :float
  encrypts :expected_amount_to_receive, type: :float
  encrypts :received_amount,            type: :float
end
