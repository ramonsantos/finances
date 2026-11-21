# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateExpensesFromCsvService do
  let(:header) do
    'Data,Descrição,Valor,Categoria,Forma de pagamento,Essencial?,Fixo?,Observação'
  end
  let(:expense_creator) { create(:expense_creator, status: :processing) }

  before do
    create(:expense_category, name: 'Alimentação')
    create(:payment_method, name: 'Dinheiro')
  end

  describe '.call' do
    context 'when success' do
      before do
        expense_creator.csv_file.attach(
          io: StringIO.new(csv_content),
          filename: 'import.csv',
          content_type: 'text/csv'
        )
      end

      context 'when the row is valid' do
        let(:csv_content) { "#{header}\n01/01/2025,Mercado,\"10,00\",Alimentação,Dinheiro,sim,não," }
        let(:expected_result) { 'Sucesso' }

        it 'creates an expense and records success' do
          expect { described_class.call(expense_creator: expense_creator) }.to change(Expense, :count).by(1)

          expense = Expense.last
          expect(expense.description).to eq('Mercado')
          expect(expense.amount).to eq(10)
          expect(expense.essential).to be(true)
          expect(expense.fixed).to be(false)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(true)
          expect(result.details).to eq(expected_result)
        end
      end

      context 'when extra columns beyond H are present' do
        let(:csv_content) do
          "#{header},Total,Fontes\n01/01/2025,Mercado,\"10,00\",Alimentação,Dinheiro,sim,não,,R$ 99,Pix"
        end

        it 'ignores non-importable columns' do
          expect { described_class.call(expense_creator: expense_creator) }.to change(Expense, :count).by(1)
        end
      end

      context 'when amount has no currency symbol' do
        let(:csv_content) { "#{header}\n01/01/2025,Mercado,150.82,Alimentação,Dinheiro,sim,não," }

        it 'parses the amount' do
          described_class.call(expense_creator: expense_creator)

          expect(Expense.last.amount).to eq(150.82)
        end
      end

      context 'when the row only has description without date' do
        let(:csv_content) { "#{header}\n,Academia,,,Cartão Nubank,não,não," }

        it 'skips the row' do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)
          expect(expense_creator.expense_creator_results).to be_empty
        end
      end
    end

    context 'when error' do
      before do
        expense_creator.csv_file.attach(
          io: StringIO.new(csv_content),
          filename: 'import.csv',
          content_type: 'text/csv'
        )
      end

      context 'when payment method does not exist' do
        let(:csv_content) { "#{header}\n01/01/2025,Mercado,\"10,00\",Alimentação,Inexistente,sim,não," }
        let(:expected_result) { 'Erro: Forma de pagamento não existe' }

        it 'records the error' do
          described_class.call(expense_creator: expense_creator)

          expect(expense_creator.expense_creator_results.last.details).to eq(expected_result)
        end
      end

      context 'when essential is blank' do
        let(:csv_content) { "#{header}\n01/01/2025,Mercado,\"10,00\",Alimentação,Dinheiro,,não," }
        let(:expected_result) { 'Erro: Essencial? não pode ficar em branco' }

        it 'records the error' do
          described_class.call(expense_creator: expense_creator)

          expect(expense_creator.expense_creator_results.last.details).to eq(expected_result)
        end
      end
    end
  end
end
