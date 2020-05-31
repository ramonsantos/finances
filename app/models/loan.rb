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

  scope :to_receive, ->(user) { where(user: user, received_amount_ciphertext: nil) }

  scope :received, ->(user) { where(user: user).where.not(received_amount_ciphertext: nil) }

  def self.amount_of_loans_to_receive(user)
    to_receive(user).select(:borrowed_amount_ciphertext).reduce(0) do |sum, loan|
      sum + loan.borrowed_amount
    end
  end
end
