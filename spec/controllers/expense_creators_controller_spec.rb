# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseCreatorsController, type: :controller do
  routes { Rails.application.routes }

  let!(:expense_creator) { create(:expense_creator) }

  describe 'GET #index' do
    it 'returns success' do
      get(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns success' do
      get(:show, params: { id: expense_creator.id })
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #download_csv_template' do
    it 'sends the template file' do
      get(:download_csv_template)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('text/csv')
    end
  end

  describe 'POST #create' do
    let(:uploaded_file) do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/import.csv'),
        'text/csv'
      )
    end

    context 'without a file' do
      it 'redirects with an alert' do
        post(:create)

        expect(response).to redirect_to(expense_creators_path)
        expect(flash[:alert]).to eq(I18n.t('expense_creators.create.file_required'))
      end
    end

    context 'with a file' do
      it 'creates a record and enqueues the job' do
        expect do
          post(:create, params: { file: uploaded_file })
        end.to change(ExpenseCreator, :count).by(1)
                                             .and(have_enqueued_job(ImportExpensesCsvJob))
      end

      it 'redirects to show with a notice' do
        post(:create, params: { file: uploaded_file })

        creator = ExpenseCreator.last
        expect(response).to redirect_to(expense_creator_path(creator))
        expect(flash[:notice]).to eq(I18n.t('expense_creators.create.enqueued'))
      end
    end
  end
end
