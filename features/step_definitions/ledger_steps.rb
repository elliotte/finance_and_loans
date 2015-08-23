Given(/^a ledger has already been added$/) do
  User.last.ledgers.create(user_tag: "testLedger")
end

Given(/^I upload a file for with some transactions$/) do
  find('.upload_csv').click
  attach_file(:file, File.join(".", 'features', 'testFile.csv'))
  click_button "Import CSV"
end

Then(/^ledger transaction count should have increased$/) do
  User.last.ledgers.first.transactions.count == 19 ? true : fail(ArgumentError.new('Count increase is not correct'))
end

  
  
	 

