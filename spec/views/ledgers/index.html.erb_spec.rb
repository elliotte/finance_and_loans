require 'rails_helper'

describe "ledger/index" do
  before(:each) do
    assign(:ledger, stub_model(Ledger,
      :user_tag => "MyString",
      :type => "CashLedger"
    ).as_new_record)
    
    5.times{
        transaction = FactoryGirl.create(:credit_transaction, amount: 10, acc_date: Date.yesterday, ledger: @row_of_ledgers)
    }
  end

  it "renders new company form" do
    render :new, format: :js
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", companies_path, "post" do
      assert_select "input#company_name[name=?]", "company[name]"
      assert_select "input#company_email[name=?]", "company[email]"
      assert_select "input#company_company_number[name=?]", "company[company_number]"
    end
  end
end
