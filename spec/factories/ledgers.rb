# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ledger do
    user_tag "UserParentLedger"
  end

  factory :cash_ledger, class: CashLedger, parent: :ledger do
  	user_tag "Test CashLedger"
    type 'CashLedger'
  end
  factory :sales_ledger, class: SalesLedger, parent: :ledger do
  	user_tag "Test SalesLedger"
    type 'SalesLedger'
  end
  factory :purchase_ledger, class: PurchaseLedger, parent: :ledger do
  	user_tag "Test PurchaseLedger"
    type 'PurchaseLedger'
  end
  factory :cash_flow_ledger, class: CashFlowLedger, parent: :ledger do
    user_tag "Test CashFlow"
    type 'CashFlowLedger'
  end
end
