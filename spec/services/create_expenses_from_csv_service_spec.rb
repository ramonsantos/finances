# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreateExpensesFromCsvService do
  let!(:category) { create(:expense_category, name: "Alimentação") }
  let!(:group) { create(:expense_group, name: "Pessoal") }
  let(:expense_creator) { create(:expense_creator, status: :processing) }
  let(:header) { "Descrição,Valor,Data,Categoria,Grupo de Despesa,Fixo?,Observações" }

  describe ".call" do
    context "when success" do
      before do
        expense_creator.csv_file.attach(
          io: StringIO.new(csv_content),
          filename: "import.csv",
          content_type: "text/csv"
        )
      end

      context "when the row is valid" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",01/01/25,Alimentação,Pessoal,não," }
        let(:expected_result) { "Sucesso" }

        it "creates an expense and records success" do
          expect { described_class.call(expense_creator: expense_creator) }.to change(Expense, :count).by(1)

          expense = Expense.last
          expect(expense.description).to eq("Mercado")
          expect(expense.amount).to eq(10)
          expect(expense.fixed).to be(false)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(true)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when fixed is sim and remark is present" do
        let(:csv_content) { "#{header}\nAluguel,\"500,00\",15/06/25,Alimentação,Pessoal,sim,recorrente" }

        it "persists fixed and remark" do
          described_class.call(expense_creator: expense_creator)

          expense = Expense.last
          expect(expense.fixed).to be(true)
          expect(expense.remark).to eq("recorrente")
          expect(expense_creator.expense_creator_results.last.success).to be(true)
        end
      end

      context "when the file has multiple valid rows" do
        let(:csv_content) do
          "#{header}\nMercado,\"10,00\",01/01/25,Alimentação,Pessoal,não,\n" \
            "Farmácia,\"20,00\",02/01/25,Alimentação,Pessoal,não,"
        end
        let(:expected_result) { 2 }

        it "creates all expenses and records each success" do
          expect { described_class.call(expense_creator: expense_creator) }.to change(Expense, :count).by(expected_result)
          expect(expense_creator.expense_creator_results.count).to eq(expected_result)
          expect(expense_creator.expense_creator_results).to all(have_attributes(success: true))
        end
      end

      context "when one row fails and another succeeds" do
        let(:csv_content) do
          "#{header}\n,\"10,00\",01/01/25,Alimentação,Pessoal,não,\n" \
            "Mercado,\"10,00\",01/01/25,Alimentação,Pessoal,não,"
        end
        let(:expected_result) { [false, true] }

        it "imports only the valid row" do
          expect { described_class.call(expense_creator: expense_creator) }.to change(Expense, :count).by(1)
          expect(expense_creator.expense_creator_results.map(&:success)).to eq(expected_result)
        end
      end
    end

    context "when error" do
      before do
        expense_creator.csv_file.attach(
          io: StringIO.new(csv_content),
          filename: "import.csv",
          content_type: "text/csv"
        )
      end

      context "when description is blank" do
        let(:csv_content) { "#{header}\n,\"10,00\",01/01/25,Alimentação,Pessoal,não," }
        let(:expected_result) { "Erro: Descrição não pode ficar em branco" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when amount is blank" do
        let(:csv_content) { "#{header}\nMercado,,01/01/25,Alimentação,Pessoal,não," }
        let(:expected_result) { "Erro: Valor não pode ficar em branco" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when amount is below the minimum" do
        let(:csv_content) { "#{header}\nMercado,\"0,00\",01/01/25,Alimentação,Pessoal,não," }
        let(:expected_result) { "Erro: Formato de Valor inválido" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when date is blank" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",,Alimentação,Pessoal,não," }
        let(:expected_result) { "Erro: Data não pode ficar em branco" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when date format is invalid" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",xx/01/25,Alimentação,Pessoal,não," }
        let(:expected_result) { "Erro: Formato de Data inválido" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when expense category is blank" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",01/01/25,,Pessoal,não," }
        let(:expected_result) { "Erro: Categoria não pode ficar em branco" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when expense category does not exist" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",01/01/25,Inexistente,Pessoal,não," }
        let(:expected_result) { "Erro: Categoria não existe" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when expense group is blank" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",01/01/25,Alimentação,,não," }
        let(:expected_result) { "Erro: Grupo de Despesa não pode ficar em branco" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when expense group does not exist" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",01/01/25,Alimentação,Inexistente,não," }
        let(:expected_result) { "Erro: Grupo de Despesa não existe" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end

      context "when fixed is blank" do
        let(:csv_content) { "#{header}\nMercado,\"10,00\",01/01/25,Alimentação,Pessoal,," }
        let(:expected_result) { "Erro: Fixo? não pode ficar em branco" }

        it "does not create an expense and records the error" do
          expect { described_class.call(expense_creator: expense_creator) }.not_to change(Expense, :count)

          result = expense_creator.expense_creator_results.last
          expect(result.success).to be(false)
          expect(result.details).to eq(expected_result)
        end
      end
    end
  end
end