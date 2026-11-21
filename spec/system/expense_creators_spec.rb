# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Spreadsheet import', type: :system do
  let(:header) do
    'Data,Descrição,Valor,Categoria,Forma de pagamento,Essencial?,Fixo?,Observação'
  end

  before do
    create(:expense_category, name: 'Alimentação')
    create(:payment_method, name: 'Dinheiro')
  end

  it 'enqueues import and processes it in the job' do
    csv = "#{header}\n01/01/2025,Mercado,\"10,00\",Alimentação,Dinheiro,sim,não,"
    file = Tempfile.new(['import', '.csv'])
    file.write(csv)
    file.rewind

    visit expense_creators_path
    attach_file :file, file.path
    click_button 'Iniciar importação'

    expect(page).to have_text('Importação iniciada')

    creator = ExpenseCreator.last
    perform_enqueued_jobs

    visit expense_creator_path(creator)
    expect(page).to have_text('Sucesso')
  end

  context 'when no file is selected' do
    it 'shows file required alert' do
      visit expense_creators_path
      click_button 'Iniciar importação'

      expect(page).to have_text('Selecione um arquivo CSV.')
    end
  end

  context 'when a row fails validation' do
    it 'records the error on the import result page' do
      csv = "#{header}\n01/01/2025,,\"10,00\",Alimentação,Dinheiro,sim,não,"
      file = Tempfile.new(['import', '.csv'])
      file.write(csv)
      file.rewind

      visit expense_creators_path
      attach_file :file, file.path
      click_button 'Iniciar importação'

      creator = ExpenseCreator.last
      perform_enqueued_jobs

      visit expense_creator_path(creator)

      expect(page).to have_text('Concluído')
      expect(page).to have_text('Erro: Descrição não pode ficar em branco')
    end
  end

  context 'when downloading the template' do
    it 'returns a CSV file with headers' do
      visit download_csv_template_expense_creators_path

      expect(page.body.b.force_encoding(Encoding::UTF_8)).to include(header)
    end
  end

  context 'when mixing valid and invalid rows' do
    it 'creates expenses for valid rows and errors for invalid rows' do
      csv = <<~CSV
        #{header}
        01/01/2025,Mercado,"10,00",Alimentação,Dinheiro,sim,não,
        01/01/2025,,"10,00",Alimentação,Dinheiro,sim,não,
      CSV
      file = Tempfile.new(['import', '.csv'])
      file.write(csv)
      file.rewind

      visit expense_creators_path
      attach_file :file, file.path
      click_button 'Iniciar importação'

      creator = ExpenseCreator.last
      perform_enqueued_jobs

      visit expense_creator_path(creator)

      expect(page).to have_text('Sucesso')
      expect(page).to have_text('Erro: Descrição não pode ficar em branco')
      expect(Expense.where(description: 'Mercado').count).to eq(1)
    end
  end
end
