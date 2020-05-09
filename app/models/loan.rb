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

  scope :fetch_order_by_loan_date, lambda { |user, filters = {}|
    search_criteria = { user: user, received_amount_ciphertext: nil }.merge!(filters)
    where(search_criteria).order(:loan_date)
  }

  class << self
    def fetch_amount_of_loans_to_receive(user)
      Loan.where(user: user, received_amount_ciphertext: nil).reduce(0) do |sum, element|
        sum + element.borrowed_amount
      end
    end
  end
end
