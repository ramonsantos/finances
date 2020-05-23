# frozen_string_literal: true

require 'rails_helper'

describe CreateExpensesFromCsv do
  subject { described_class.new(expense_creator, file_path) }

  let(:file_path) { 'tmp/expenses.csv' }
  let(:expense_creator) { create(:expense_creator) }
  let(:csv_header) { 'Descrição,Valor,Data,Categoria,Grupo de Despesa,Local,Fixo?,Observações' }
  let(:expected_result) { { rows_detail: rows_detail, total_success: total_success, total_errors: total_errors } }

  describe '#create_expenses' do
    before do
      File.write(file_path, "#{csv_header}\n#{csv_content}")
      create(:expense_group)
      create(:place)
    end

    context 'when one expense' do
      let(:expense_creator_results) do
        ExpenseCreatorResult.where(
          expense_creator_id: expense_creator.id,
          raw_content: csv_content,
          details: details,
          success: success
        )
      end

      shared_examples 'creates expense_creator_results' do
        it 'creates expense_creator_results' do
          expect do
            subject.create_expenses
            expect(expense_creator_results.count).to eq(1)
          end.to change(Expense, :count).by(expense_count_change_by)
        end
      end

      context 'when success' do
        let(:expense_count_change_by) { 1 }
        let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:details) { 'Sucesso' }
        let(:success) { true }

        it_behaves_like 'creates expense_creator_results'
      end

      context 'when error' do
        let(:expense_count_change_by) { 0 }

        context 'without descrition' do
          let(:csv_content) { ',"R$ 244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
          let(:details) { 'Erro: Descrição não pode fica em branco' }
          let(:success) { false }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'without amount' do
          let(:csv_content) { 'Plano de Saúde,,01/05/2020,Saúde,Trabalho,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Valor não pode fica em branco' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'when wrong amount format' do
          let(:csv_content) { 'Plano de Saúde,"R$ s244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Formato de Valor inválido' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'without date' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",,Saúde,Trabalho,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Data não pode fica em branco' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'when wrong date format' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05,Saúde,Trabalho,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Formato de Data inválido' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'without ExpenseCategory' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,,Trabalho,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Categoria não pode fica em branco' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'when ExpenseCategory not found' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Esporte,Trabalho,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Categoria não encontrada' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'without ExpenseGroup' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Grupo de Despesa não pode fica em branco' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'when ExpenseGroup not found' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Casa,Recife,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Grupo de Despesa não encontrado' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'without Place' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Local não pode fica em branco' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'when Place not found' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,Garanhuns,sim,' }
          let(:success) { false }
          let(:details) { 'Erro: Local não encontrado' }

          it_behaves_like 'creates expense_creator_results'
        end

        context 'without fixed' do
          let(:csv_content) { 'Plano de Saúde,"R$ 244,27",01/05/2020,Saúde,Trabalho,Recife,,' }
          let(:success) { false }
          let(:details) { 'Erro: Fixo? não pode fica em branco' }

          it_behaves_like 'creates expense_creator_results'
        end
      end
    end

    context 'when many expenses' do
      let(:csv_content) { "#{row1}\n#{row2}" }

      let(:expense_creator_results1) do
        ExpenseCreatorResult.where(
          expense_creator_id: expense_creator.id,
          raw_content: row1,
          details: details1,
          success: success1
        )
      end

      let(:expense_creator_results2) do
        ExpenseCreatorResult.where(
          expense_creator_id: expense_creator.id,
          raw_content: row2,
          details: details2,
          success: success2
        )
      end

      shared_examples 'creates expense_creator_results' do
        it 'creates expense_creator_results' do
          expect do
            subject.create_expenses
            expect(expense_creator_results1.count).to eq(1)
            expect(expense_creator_results2.count).to eq(1)
          end.to change(Expense, :count).by(expense_count_change_by)
        end
      end

      context 'when all are successes' do
        let(:expense_count_change_by) { 2 }
        let(:row1) { 'Plano de Saúde,"R$ 1.244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:row2) { 'Remédio,"R$ 244,27",02/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:details1) { 'Sucesso' }
        let(:details2) { 'Sucesso' }
        let(:success1) { true }
        let(:success2) { true }

        it_behaves_like 'creates expense_creator_results'
      end

      context 'when partial success' do
        let(:expense_count_change_by) { 1 }
        let(:row1) { 'Plano de Saúde,"R$ 1.244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:row2) { 'Remédio,,02/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:details1) { 'Sucesso' }
        let(:details2) { 'Erro: Valor não pode fica em branco' }
        let(:success1) { true }
        let(:success2) { false }

        it_behaves_like 'creates expense_creator_results'
      end

      context 'when all are errors' do
        let(:expense_count_change_by) { 0 }
        let(:row1) { ',"R$ 1.244,27",01/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:row2) { 'Remédio,,02/05/2020,Saúde,Trabalho,Recife,sim,' }
        let(:details1) { 'Erro: Descrição não pode fica em branco' }
        let(:details2) { 'Erro: Valor não pode fica em branco' }
        let(:success1) { false }
        let(:success2) { false }

        it_behaves_like 'creates expense_creator_results'
      end
    end
  end
end
