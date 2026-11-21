# frozen_string_literal: true

class Loan < ApplicationRecord
  include NormalizesCurrency

  normalizes_currency :borrowed_amount, :received_amount

  validates :person, :description, :borrowed_amount, :loan_date, presence: true
  validates :borrowed_amount, comparison: { greater_than_or_equal_to: 0.01 }
  validates :received_amount, comparison: { greater_than_or_equal_to: 0.01 }, allow_nil: true
  validates_with(LoanReceivedAtRequiresAmountValidator)

  before_validation :clear_blank_amounts
  before_validation :apply_received_at_default

  scope :to_receive, -> { where(received_amount: nil) }
  scope :received, -> { where.not(received_amount: nil) }

  def self.amount_to_receive
    to_receive.sum(:borrowed_amount)
  end

  private

  def clear_blank_amounts
    self.received_amount = nil if received_amount.blank?
  end

  def apply_received_at_default
    return if received_amount.blank?

    self.received_at = Time.zone.today if received_at.blank?
  end
end
