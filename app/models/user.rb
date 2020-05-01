# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :expenses,           dependent: :delete_all
  has_many :places,             dependent: :delete_all
  has_many :expense_groups,     dependent: :delete_all
  has_many :expense_categories, dependent: :delete_all

  after_create :create_dafult_expense_categories

  private

  def create_dafult_expense_categories
    ExpenseCategory.create!(
      [
        { user: self, name: 'Alimentação' },
        { user: self, name: 'Doação e Presentes' },
        { user: self, name: 'Educação' },
        { user: self, name: 'Lazer' },
        { user: self, name: 'Pet' },
        { user: self, name: 'Saúde' },
        { user: self, name: 'Trabalho e Prospecção' },
        { user: self, name: 'Transporte' },
        { user: self, name: 'Vestuário e Cosmético' }
      ]
    )
  end
end
