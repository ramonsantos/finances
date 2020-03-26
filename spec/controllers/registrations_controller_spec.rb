# frozen_string_literal: true

require 'rails_helper'

describe RegistrationsController, type: :controller do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#create' do
    before { post(:create, params: params) }

    context 'when success' do
      let(:params) do
        {
          user: attributes_for(:user).merge!(places: { name: 'Garanhus' })
        }
      end

      it 'creates user correctly' do
        expect(flash[:notice]).to be_blank
        expect(subject.current_user).to be_present
      end
    end

    context 'when error' do
      let(:params) do
        {
          user: attributes_for(:user)
        }
      end

      it 'does not creates user' do
        expect(flash[:notice]).to be_blank
        expect(subject.current_user).to be_blank
        expect(response).to redirect_to(new_user_registration_path)
      end
    end
  end
end
