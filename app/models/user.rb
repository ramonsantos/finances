# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :expenses,           dependent: :delete_all
  has_many :loans,              dependent: :delete_all
  has_many :places,             dependent: :delete_all
  has_many :expense_groups,     dependent: :delete_all
  has_many :expense_categories, dependent: :delete_all
  has_many :expense_creators,   dependent: :delete_all

  after_create :create_default_expense_categories
  after_create :create_default_expense_groups

  private

  def create_default_expense_categories
    ExpenseCategory.create!(
      [
        { user: self, name: I18n.t("#{base_i18n_path}.default_expense_categories.food") },
        { user: self, name: I18n.t("#{base_i18n_path}.default_expense_categories.education") },
        { user: self, name: I18n.t("#{base_i18n_path}.default_expense_categories.recreation") },
        { user: self, name: I18n.t("#{base_i18n_path}.default_expense_categories.health") },
        { user: self, name: I18n.t("#{base_i18n_path}.default_expense_categories.transport") }
      ]
    )
  end

  def create_default_expense_groups
    ExpenseGroup.create!(name: I18n.t("#{base_i18n_path}.default_expense_groups.personal"), user: self)
  end

  def base_i18n_path
    'activerecord.models.user'
  end
end
