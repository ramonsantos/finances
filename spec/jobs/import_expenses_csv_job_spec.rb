# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportExpensesCsvJob, type: :job do
  describe '#perform' do
    let(:category) { create(:expense_category, name: 'Alimentação') }
    let(:payment_method) { create(:payment_method, name: 'Dinheiro') }

    let(:header) do
      'Data,Descrição,Valor,Categoria,Forma de pagamento,Essencial?,Fixo?,Observação'
    end

    context 'when success' do
      it 'finishes the import' do
        category
        payment_method

        creator = create(:expense_creator, status: :queued)
        creator.csv_file.attach(
          io: StringIO.new("#{header}\n01/01/2025,Mercado,\"10,00\",Alimentação,Dinheiro,sim,não,"),
          filename: 'import.csv',
          content_type: 'text/csv'
        )

        perform_enqueued_jobs do
          described_class.perform_later(creator)
        end

        expect(creator.reload).to be_finished
        expect(creator.expense_creator_results_count).to eq(1)
      end
    end

    context 'when error' do
      context 'when process_csv! raises' do
        let(:creator) { create(:expense_creator, status: :queued) }

        before do
          allow(creator).to receive(:process_csv!).and_raise(StandardError, 'import failed')
        end

        it 'marks the creator as failed and re-raises' do
          expect do
            described_class.perform_now(creator)
          end.to raise_error(StandardError, 'import failed')

          expect(creator.reload).to be_failed
        end
      end
    end
  end
end
