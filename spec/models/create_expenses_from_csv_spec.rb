# frozen_string_literal: true

require 'rails_helper'

describe CreateExpensesFromCsv do
  subject { described_class.new(user, file_path) }

  let!(:user) { create(:user) }
  let(:file_path) { 'tmp/expenses.csv' }
  let(:csv_header) { 'Descrição,Valor,Data,Categoria,Grupo de Despesa,Local,Fixo?,Observações' }
  let(:expected_result) { { rows_detail: rows_detail, total_success: total_success, total_errors: total_errors } }

  describe '#create_expenses' do
    shared_examples 'returns results from create_expenses' do
      it 'returns results from create_expenses' do
        expect do
          expect(subject.create_expenses).to eq(expected_result)
        end.to change(Expense, :count).by(total_success)
      end
    end

    before do
      File.write(file_path, "#{csv_header}\n#{csv_content}")
      create(:expense_group)
      create(:place)
    end

    context 'when one expense' do
      let(:rows_detail) { [{ row: csv_content, result: result, message: error_message }] }

      context 'when success' do
        let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:result) { :success }
        let(:error_message) { nil }
        let(:total_success) { 1 }
        let(:total_errors) { 0 }

        it_behaves_like 'returns results from create_expenses'
      end

      context 'when error' do
        let(:result) { :error }
        let(:error_message) { 'Descrição não pode fica em branco' }
        let(:total_success) { 0 }
        let(:total_errors) { 1 }

        context 'without descrition' do
          let(:csv_content) { ',"R$ 244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'without amount' do
          let(:csv_content) { 'Plano de Saúde,,01/05/2020,Saúde,Trabalho,Recife,sim,' }
          let(:error_message) { 'Valor não pode fica em branco' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'when wrong amount format' do
          let(:csv_content) { 'Plano de Saúde,"R$ s244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
          let(:error_message) { 'Formato de Valor inválido' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'without date' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",,Saúde,Trabalho,Recife,sim,' }
          let(:error_message) { 'Data não pode fica em branco' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'when wrong date format' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05,Saúde,Trabalho,Recife,sim,' }
          let(:error_message) { 'Formato de Data inválido' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'without ExpenseCategory' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,,Trabalho,Recife,sim,' }
          let(:error_message) { 'Categoria não pode fica em branco' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'when ExpenseCategory not found' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Esporte,Trabalho,Recife,sim,' }
          let(:error_message) { 'Categoria não encontrada' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'without ExpenseGroup' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,,Recife,sim,' }
          let(:error_message) { 'Grupo de Despesa não pode fica em branco' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'when ExpenseGroup not found' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Casa,Recife,sim,' }
          let(:error_message) { 'Grupo de Despesa não encontrado' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'without Place' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,,sim,' }
          let(:error_message) { 'Local não pode fica em branco' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'when Place not found' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,Garanhuns,sim,' }
          let(:error_message) { 'Local não encontrado' }

          it_behaves_like 'returns results from create_expenses'
        end

        context 'without fixed' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,Recife,,' }
          let(:error_message) { 'Fixo? não pode fica em branco' }

          it_behaves_like 'returns results from create_expenses'
        end
      end
    end

    context 'when many expenses' do
      let(:csv_content) { "#{row1}\n#{row2}" }

      let(:rows_detail) do
        [
          { row: row1, result: result1, message: error_message1 },
          { row: row2, result: result2, message: error_message2 }
        ]
      end

      context 'when all are successes' do
        let(:row1) { 'Plano de Saúde,"R$ 1.244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:row2) { 'Remédio,"R$ 244,27",02/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:result1) { :success }
        let(:result2) { :success }
        let(:error_message1) { nil }
        let(:error_message2) { nil }
        let(:total_success) { 2 }
        let(:total_errors) { 0 }

        it_behaves_like 'returns results from create_expenses'
      end

      context 'when partial success' do
        let(:row1) { 'Plano de Saúde,"R$ 1.244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:row2) { 'Remédio,,02/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:result1) { :success }
        let(:result2) { :error }
        let(:error_message1) { nil }
        let(:error_message2) { 'Valor não pode fica em branco' }
        let(:total_success) { 1 }
        let(:total_errors) { 1 }

        it_behaves_like 'returns results from create_expenses'
      end

      context 'when all are errors' do
        let(:row1) { ',"R$ 1.244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:row2) { 'Remédio,,02/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:result1) { :error }
        let(:result2) { :error }
        let(:error_message1) { 'Descrição não pode fica em branco' }
        let(:error_message2) { 'Valor não pode fica em branco' }
        let(:total_success) { 0 }
        let(:total_errors) { 2 }

        it_behaves_like 'returns results from create_expenses'
      end
    end
  end
end
