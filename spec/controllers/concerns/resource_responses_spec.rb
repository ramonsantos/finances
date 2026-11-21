# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceResponses do
  let(:host_class) do
    Class.new(ApplicationController) { include ResourceResponses }
  end

  let(:host) do
    host_class.class_eval do
      attr_reader :last_redirect, :last_render
    end

    host_class.define_method(:redirect_to) do |path, **options|
      @last_redirect = { path: path, **options }
    end

    host_class.define_method(:render) do |view, status:|
      @last_render = { view: view, status: status }
    end

    host_class.define_method(:t) do |key, **_options|
      {
        '.created' => 'Registro adicionado.',
        '.updated' => 'Registro atualizado.',
        '.destroyed' => 'Registro removido.',
        '.destroy_failed' => 'Não foi possível excluir o registro.'
      }.fetch(key)
    end

    host_class.new
  end

  describe '#create_resource' do
    let(:success_path) { '/categorias' }

    context 'when success' do
      let(:record) { build(:expense_category, name: 'Lazer') }
      let(:expected_result) do
        { path: success_path, notice: 'Registro adicionado.' }
      end

      it 'redirects with a notice' do
        host.send(:create_resource, record, success_path)

        expect(host.last_redirect).to eq(expected_result)
        expect(record).to be_persisted
      end
    end

    context 'when error' do
      let(:record) { build(:expense_category, name: '') }
      let(:expected_result) do
        { view: :new, status: :unprocessable_content }
      end

      it 'renders the error view' do
        host.send(:create_resource, record, success_path)

        expect(host.last_render).to eq(expected_result)
      end
    end
  end

  describe '#update_resource' do
    let!(:record) { create(:expense_category, name: 'Transporte') }
    let(:success_path) { "/categorias/#{record.id}" }

    context 'when success' do
      let(:attributes) { { name: 'Transporte urbano' } }
      let(:expected_result) do
        { path: success_path, notice: 'Registro atualizado.' }
      end

      it 'redirects with a notice' do
        host.send(:update_resource, record, attributes, success_path)

        expect(host.last_redirect).to eq(expected_result)
        expect(record.reload.name).to eq('Transporte urbano')
      end
    end

    context 'when error' do
      let(:attributes) { { name: '' } }
      let(:expected_result) do
        { view: :show, status: :unprocessable_content }
      end

      it 'renders the error view' do
        host.send(:update_resource, record, attributes, success_path)

        expect(host.last_render).to eq(expected_result)
      end
    end
  end

  describe '#destroy_resource' do
    let(:redirect_path) { '/categorias' }

    context 'when success' do
      let!(:record) { create(:expense_category, name: 'Educação') }
      let(:expected_result) do
        { path: redirect_path, notice: 'Registro removido.' }
      end

      it 'redirects with a notice' do
        host.send(:destroy_resource, record, redirect_path)

        expect(host.last_redirect).to eq(expected_result)
        expect(ExpenseCategory.exists?(record.id)).to be(false)
      end
    end

    context 'when error' do
      let!(:record) { create(:expense_category, name: 'Moradia') }
      let(:expected_result) do
        { path: redirect_path, alert: 'Não foi possível excluir o registro.' }
      end

      before do
        group = create(:expense_group)
        create(:expense, expense_category: record, expense_group: group)
      end

      it 'redirects with an alert' do
        host.send(:destroy_resource, record, redirect_path)

        expect(host.last_redirect).to eq(expected_result)
        expect(ExpenseCategory.exists?(record.id)).to be(true)
      end
    end
  end
end
