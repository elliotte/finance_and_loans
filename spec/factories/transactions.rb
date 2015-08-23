# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :transaction do
    type "Credit"
    amount 9.99
    monea_tag "MyString"
    mi_tag "MyString"
    acc_date Time.now
  end

  factory :credit_transaction, class: Credit, parent: :transaction do
    type 'Credit'
  end

  factory :debit_transaction, class: Debit, parent: :transaction do
    type 'Debit'
  end
end
