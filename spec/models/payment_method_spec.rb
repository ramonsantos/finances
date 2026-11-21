# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  describe 'associations' do
    context 'when have_many' do
      it { is_expected.to have_many(:expenses).dependent(:restrict_with_error) }
    end
  end

  describe 'validations' do
    context 'when validate presence_of' do
      it { is_expected.to validate_presence_of(:name) }
    end

    context 'when validate uniqueness_of' do
      subject { create(:payment_method, name: 'Dinheiro') }

      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end
  end
end
