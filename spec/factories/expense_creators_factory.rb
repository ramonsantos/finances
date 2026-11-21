# frozen_string_literal: true

FactoryBot.define do
  factory :expense_creator do
    date { Time.zone.now }
    status { :queued }

    trait :with_csv do
      after(:build) do |creator|
        creator.csv_file.attach(
          io: StringIO.new("Data,Descrição,Valor,Categoria,Forma de pagamento,Essencial?,Fixo?,Observação\n"),
          filename: 'test.csv',
          content_type: 'text/csv'
        )
      end
    end
  end
end
