# frozen_string_literal: true

class LoanReceivedAtRequiresAmountValidator < ActiveModel::Validator
  def validate(record)
    return if record.received_at.blank? || record.received_amount.present?

    record.errors.add(:received_at, :invalid)
  end
end
