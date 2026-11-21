# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlashHelper, type: :helper do
  describe '#flash_toasts' do
    context 'when notice is present' do
      before { flash[:notice] = 'Categoria adicionada.' }

      it 'returns a toast payload' do
        toasts = helper.flash_toasts

        expect(toasts.length).to eq(1)
        expect(toasts.first[:message]).to eq('Categoria adicionada.')
        expect(toasts.first[:timeout]).to eq(5000)
      end
    end

    context 'when flash is empty' do
      it 'returns no toasts' do
        expect(helper.flash_toasts).to eq([])
      end
    end
  end
end
