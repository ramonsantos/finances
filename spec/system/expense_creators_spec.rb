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
end
