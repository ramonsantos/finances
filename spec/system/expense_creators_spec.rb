# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CSV import', type: :system do
  before do
    create(:expense_category, name: 'Alimentação')
    create(:expense_group, name: 'Pessoal')
  end

  it 'enqueues import and processes it in the job' do
    csv = "Descrição,Valor,Data,Categoria,Grupo de Despesa,Fixo?,Observações\nMercado,\"10,00\",01/01/25,Alimentação,Pessoal,não,"
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
      csv = "Descrição,Valor,Data,Categoria,Grupo de Despesa,Fixo?,Observações\n,\"10,00\",01/01/25,Alimentação,Pessoal,não,"
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

      expect(page.body.b.force_encoding(Encoding::UTF_8)).to include(
        'Descrição,Valor,Data,Categoria,Grupo de Despesa,Fixo?,Observações'
      )
    end
  end

  context 'when mixing valid and invalid rows' do
    it 'creates expenses for valid rows and errors for invalid rows' do
      csv = <<~CSV
        Descrição,Valor,Data,Categoria,Grupo de Despesa,Fixo?,Observações
        Mercado,"10,00",01/01/25,Alimentação,Pessoal,não,
        ,"10,00",01/01/25,Alimentação,Pessoal,não,
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
