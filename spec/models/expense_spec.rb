# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:fixed) }

    it { is_expected.not_to validate_presence_of(:remark) }
  end
end
