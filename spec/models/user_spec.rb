# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:expenses).dependent(:delete_all) }
    it { is_expected.to have_many(:places).dependent(:delete_all) }
    it { is_expected.to have_many(:expense_groups).dependent(:delete_all) }
    it { is_expected.to have_many(:expense_categories).dependent(:delete_all) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end
end
