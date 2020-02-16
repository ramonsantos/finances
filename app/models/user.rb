# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :expenses,       dependent: :delete_all
  has_many :places,         dependent: :delete_all
  has_many :expense_groups, dependent: :delete_all
end
