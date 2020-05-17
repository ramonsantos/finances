# frozen_string_literal: true

class ExpenseCategory < ApplicationRecord
  include FormatName

  belongs_to :user
  has_many :expenses, dependent: :restrict_with_exception

  validates :user,        presence: true
  validates :name,        presence: true
  validates :description, presence: false

  before_save :format_name!
end
