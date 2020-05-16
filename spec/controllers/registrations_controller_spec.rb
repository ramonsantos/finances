# frozen_string_literal: true

require 'rails_helper'

describe RegistrationsController, type: :controller do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  let(:params) { { user: attributes_for(:user).merge!(places: { name: 'Garanhus' }) } }

  describe '#new' do
    it 'returns a success response' do
      get(:new)

      expect(flash).to be_blank
      expect(subject.current_user).to be_blank
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'when success' do
      it 'creates user correctly' do
        expect do
          post(:create, params: params)
          expect(flash).to be_blank
          expect(subject.current_user).to be_present
          expect(Place.where(user: subject.current_user).count).to eq(1)
        end.to change(User, :count).by(1)
      end
    end

    context 'when error' do
      shared_examples 'user does not created' do
        it 'user does not created' do
          expect do
            post(:create, params: invalid_params)
            expect(flash).to be_blank
            expect(subject.current_user).to be_blank
            expect(response).to be_successful
          end.not_to change(User, :count)
        end
      end

      context 'without place' do
        let(:invalid_params) { params.delete(:place) }

        it_behaves_like 'user does not created'
      end

      context 'without email' do
        let(:invalid_params) { params.delete(:email) }

        it_behaves_like 'user does not created'
      end

      context 'when invalid email' do
        let(:invalid_params) { params.merge({ user: { email: 'invalid email' } }) }

        it_behaves_like 'user does not created'
      end

      context 'without password' do
        let(:invalid_params) { params.delete(:password) }

        it_behaves_like 'user does not created'
      end

      context 'when short password' do
        let(:invalid_params) do
          params.tap do |hash|
            hash[:user][:password] = '123'
            hash[:user][:password_confirmation] = '123'
          end
        end

        it_behaves_like 'user does not created'
      end

      context 'without password confirmation' do
        let(:invalid_params) { params.delete(:password_confirmation) }

        it_behaves_like 'user does not created'
      end

      context 'when password different from password confirmation' do
        let(:invalid_params) do
          params.tap do |hash|
            hash[:user][:password] = '123457'
            hash[:user][:password_confirmation] = '123456'
          end
        end

        it_behaves_like 'user does not created'
      end
    end
  end
end
