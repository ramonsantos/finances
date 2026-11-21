# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NavigationHelper, type: :helper do
  describe '#sidebar_link' do
    let(:label) { 'Despesas' }
    let(:path) { expenses_path }

    context 'when the path matches the current page' do
      let(:expected_result) { 'bg-slate-800 text-white' }

      before { allow(helper).to receive(:current_page?).with(path).and_return(true) }

      it 'renders the link with active classes' do
        html = helper.sidebar_link(label, path)

        expect(html).to include(expected_result)
        expect(html).to include(label)
        expect(html).to include(path)
      end
    end

    context 'when the path does not match the current page' do
      let(:expected_result) { 'text-slate-300 hover:bg-slate-800 hover:text-white' }

      before { allow(helper).to receive(:current_page?).with(path).and_return(false) }

      it 'renders the link with inactive classes' do
        html = helper.sidebar_link(label, path)

        expect(html).to include(expected_result)
        expect(html).to include(label)
        expect(html).to include(path)
      end
    end
  end
end
