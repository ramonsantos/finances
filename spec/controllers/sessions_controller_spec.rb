# frozen_string_literal: true

require 'rails_helper'

describe SessionsController, type: :controller do
  let!(:user) { create(:user) }

  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#create' do
    it 'authenticates user correctly' do
      post(:create, params: { user: { email: user.email, password: user.password, remember_me: '0' } })

      expect(flash[:notice]).to be_blank
      expect(subject.current_user).to eq(user)
    end
  end

  describe '#destroy' do
    it 'log out user correctly' do
      subject.sign_in(user)

      post(:destroy)

      expect(flash[:notice]).to be_blank
      expect(subject.current_user).to be_blank
    end
  end
end
