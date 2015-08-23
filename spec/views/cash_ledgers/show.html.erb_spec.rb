require 'rails_helper'

RSpec.describe "cash_ledgers/show", :type => :view do
  
  let(:ledger) { FactoryGirl.create(:cash_ledger) }
  let(:tr_hash) { ParseDefaultCSV.new("#{Rails.root}/files/welcome_led.csv").return_data }
   
  before do 
    book_trans_with_monea_tag
  end

  let(:data) { LedgersTransactionService.new(ledger, {}).set_show_page }

  it "renders headlines table within show page" do
    @ledger = ledger
    @data = data
    render partial: 'headlines_grid'
    rendered.should have_content("£1928.36 Sum of Lodgements")
    rendered.should have_content("34 Number of Ledger transactions")
    rendered.should have_content("£2934.53 Sum of Payments")
  end

  it 'can add a payment with vat' do
    @ledger = ledger
    @data = data
    render partial: 'button_board', locals: { ledger_type: @ledger.type.try(:underscore) }
  end

  def book_trans_with_monea_tag
    tr_hash.each do |trans|
        mi_tag = trans['mi_tag'] || "No-Mapping"
        a = ledger.transactions.build(acc_date: trans["accounting date"], amount: trans["amount"], monea_tag: trans["monea_tag"], mi_tag: mi_tag )
          if a.amount < 0.00
            a[:type] = 'Credit'
            a[:amount] = a.amount * -1
          else
             a[:type] = 'Debit'
          end
        a.save
      end
  end

end


RSpec.describe "cash_ledgers/show", :type => :feature do
  
  let(:ledger) { FactoryGirl.create(:cash_ledger) }
  let(:tr_hash) { ParseDefaultCSV.new("#{Rails.root}/files/welcome_led.csv").return_data }
   
  before do 
    book_trans_with_monea_tag
  end

  let(:data) { LedgersTransactionService.new(ledger, {}).set_show_page }


  it 'can add a payment with vat' do
    # @ledger = ledger
    # @data = data
    # click_link "Book"
    render partial: 'button_board', locals: { ledger_type: @ledger.type.try(:underscore) }
  end

  def book_trans_with_monea_tag
    tr_hash.each do |trans|
        mi_tag = trans['mi_tag'] || "No-Mapping"
        a = ledger.transactions.build(acc_date: trans["accounting date"], amount: trans["amount"], monea_tag: trans["monea_tag"], mi_tag: mi_tag )
          if a.amount < 0.00
            a[:type] = 'Credit'
            a[:amount] = a.amount * -1
          else
             a[:type] = 'Debit'
          end
        a.save
      end
  end

end


