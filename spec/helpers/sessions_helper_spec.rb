# frozen_string_literal: true

require 'rails_helper'

describe SessionsHelper, type: :helper do
  describe '.show_sign_in_error?' do
    let(:user_unauthenticated) { 'translation missing: pt-BR.devise.failure.user.unauthenticated' }
    let(:user_invalid) { 'translation missing: pt-BR.devise.failure.user.invalid' }

    it { expect(show_sign_in_error?(nil)).to be_falsey }

    it { expect(show_sign_in_error?(user_unauthenticated)).to be_falsey }

    it { expect(show_sign_in_error?(user_invalid)).to be_truthy }
  end
end
