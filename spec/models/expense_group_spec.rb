# frozen_string_literal: true

require 'rails_helper'

describe ExpenseGroup, type: :model do
  describe 'associations' do
    context 'when belong_to' do
      it { is_expected.to belong_to(:user) }
    end

    context 'when have_many' do
      it { is_expected.to have_many(:expenses).dependent(:delete_all) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
