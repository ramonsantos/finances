# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseCreator, type: :model do
  describe 'associations' do
    context 'when belong_to' do
      it { is_expected.to belong_to(:user) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:user) }
  end
end
