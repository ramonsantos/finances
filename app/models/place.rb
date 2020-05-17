# frozen_string_literal: true

class Place < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :user, presence: true
end
