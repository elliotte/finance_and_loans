class WelcomeService

	def initialize monea_modal
		  $item = monea_modal
	end

	def load_ifrs_report values
	    $item.book_values(values)
      $cy_jnl = EtbValue.new(repdate: $item.current_end, amount: 125000.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 1', ifrstag: 'Revenue', number: 1) 
      $py_jnl = EtbValue.new(repdate: $item.comparative_end, amount: 25000.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 2', ifrstag: 'Revenue',  number: 1 ) 
      $cy_jnl_1 = EtbValue.new(repdate: $item.current_end, amount: 150010.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 2', ifrstag: 'Revenue',  number: 1) 
      $py_jnl_1 = EtbValue.new(repdate: $item.comparative_end, amount: 150050.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 3', ifrstag: 'Revenue',  number: 1 ) 
      $cy_jnl_2 = EtbValue.new(repdate: $item.current_end, amount: 15442.00, description: "Being HMRC corporation tax", mitag: 'Due co 2', ifrstag: 'Tax expense', number: 2) 
      $py_jnl_2 = EtbValue.new(repdate: $item.comparative_end, amount: 13422.00, description: "Being HMRC corporation tax", mitag: 'Due co 3', ifrstag: 'Tax expense', number: 2 ) 
      $cy_jnl_3 = EtbValue.new(repdate: $item.current_end, amount: 18421.00, description: "Being to correct FX reserve in TB", mitag: 'China trading mvmts', ifrstag: 'Foreign exchange reserve', number: 3 ) 
      $py_jnl_3 = EtbValue.new(repdate: $item.comparative_end, amount: 45512.00, description: "Being to correct FX reserve in TB", mitag: 'Dollar trading mvmts', ifrstag: 'Foreign exchange reserve', number: 3 ) 
      $cy_jnl_4 = EtbValue.new(repdate: $item.current_end, amount: 1212411.00, description: "Being to add in pension liability per calcs", mitag: 'Pensions due for Co 1 staff', ifrstag: 'Employee benefit liabilities', number: 4 ) 
      $py_jnl_4 = EtbValue.new(repdate: $item.comparative_end, amount: 1512411.00, description: "Being to add in pension liability per calcs", mitag: 'Pensions due for Co 2 staff', ifrstag: 'Employee benefit liabilities', number: 4 ) 
      $cy_jnl_5 = EtbValue.new(repdate: $item.current_end, amount: 72542.00, description: "Being to add in loans split greater than one year", mitag: 'LT loans Co 1 2 3', ifrstag: 'Loans and borrowings more than 1 year', number: 5 ) 
      $py_jnl_5 = EtbValue.new(repdate: $item.comparative_end, amount: 79942.00, description: "Being to add in loans split greater than one year", mitag: 'LT loans Co 1 2 3', ifrstag: 'Loans and borrowings more than 1 year', number: 5 ) 
      load_common
	end

	def load_gaap_report values
	    $item.book_values(values)
      $cy_jnl = EtbValue.new(repdate: $item.current_end, amount: 25000.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 1', ifrstag: 'Sales',  number: 1) 
      $py_jnl = EtbValue.new(repdate: $item.comparative_end, amount: 25000.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 2', ifrstag: 'Sales',  number: 1 ) 
      $cy_jnl_1 = EtbValue.new(repdate: $item.current_end, amount: 150000.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 2', ifrstag: 'Sales',  number: 1) 
      $py_jnl_1 = EtbValue.new(repdate: $item.comparative_end, amount: 150000.00, description: "Being a journal to fix sales not in TB", mitag: 'System co 3', ifrstag: 'Sales', number: 1 ) 
      $cy_jnl_2 = EtbValue.new(repdate: $item.current_end, amount: 2134.00, description: "Being HMRC corporation tax", mitag: 'System co 2', ifrstag: 'Taxation on profit', number: 2) 
      $py_jnl_2 = EtbValue.new(repdate: $item.comparative_end, amount: 12422.00, description: "Being HMRC corporation tax", mitag: 'System co 3', ifrstag: 'Taxation on profit', number: 2 ) 
      $cy_jnl_3 = EtbValue.new(repdate: $item.current_end, amount: 12421.00, description: "Being to correct FX reserve", mitag: 'China trading mvmts', ifrstag: 'Purchases', number: 3 ) 
      $py_jnl_3 = EtbValue.new(repdate: $item.comparative_end, amount: 45512.00, description: "Being to correct FX reserve", mitag: 'Dollar trading mvmts', ifrstag: 'Purchases', number: 3 ) 
      $cy_jnl_4 = EtbValue.new(repdate: $item.current_end, amount: 12411.00, description: "Being to add overheads direct", mitag: 'Co overheads 1 2 3', ifrstag: 'Purchases', number: 4 ) 
      $py_jnl_4 = EtbValue.new(repdate: $item.comparative_end, amount: 12444.00, description: "Being add overheads direct", mitag: 'Co overheads 1 2 3', ifrstag: 'Purchases', number: 4 ) 
      $cy_jnl_5 = EtbValue.new(repdate: $item.current_end, amount: 72542.00, description: "Being to add in loans split greater than one year", mitag: 'LT loans Co 1 2 3', ifrstag: 'Bank loans', number: 5 ) 
      $py_jnl_5 = EtbValue.new(repdate: $item.comparative_end, amount: 79942.00, description: "Being to add in loans split greater than one year", mitag: 'LT loans Co 1 2 3', ifrstag: 'Bank loans', number: 5 ) 
      load_common
	end

	def load_common
      $item.values << $py_jnl
      $item.values << $cy_jnl
      $item.values << $py_jnl_1
      $item.values << $cy_jnl_1
      $item.values << $py_jnl_2
      $item.values << $cy_jnl_2
      $item.values << $py_jnl_3
      $item.values << $cy_jnl_3
      $item.values << $py_jnl_4
      $item.values << $cy_jnl_4
      $item.values << $py_jnl_5
      $item.values << $cy_jnl_5
      comment_hello = Comment.new(body: "Hello newUser, you can communicate here about this report with users", commenter: "exampleColleagueEmail@email.com", subject: 'General',  repdate: $item.current_end )
      comment_share = Comment.new(body: "Click more > User.share to allow other colleagues to view this report", commenter: "exampleColleagueEmail@email.com", subject: 'General',  repdate: $item.current_end )
      $item.comments << comment_hello
      $item.comments << comment_share
      new_notes = [
        Note.new(commenter: "admin@monea.build", body: "Report guidance notes", subject: "General", repdate: $item.current_end, filelink: "https://www.google.co.uk" ), 
        Note.new(commenter: "admin@monea.build", body: "Extended trial balance reconciliation", subject: "General", repdate: $item.current_end, filelink: "https://www.google.co.uk" ), 
        Note.new(commenter: "admin@monea.build", body: "Analytical review", subject: "ProfitLoss", repdate: $item.current_end, filelink: "https://www.google.co.uk" ), 
        Note.new(commenter: "admin@monea.build", body: "Revenue MI analysis", subject: "ProfitLoss", repdate: $item.current_end, filelink: "https://www.google.co.uk" ), 
        Note.new(commenter: "admin@monea.build", body: "Cash reconciliation schedule", subject: "BalanceSheet", repdate: $item.current_end, filelink: "https://www.google.co.uk" ), 
      ]
      new_notes.each do | note | 
        $item.notes << note
      end
	end

  def load_ledger trns
      trns.each do |trans|
        mi_tag = trans['mi_tag'] || "No-Mapping"
        a = $item.transactions.build(acc_date: trans["accounting date"], amount: trans["amount"], description: trans["description"], mi_tag: trans["mi_tag"], monea_tag: trans["monea_tag"], vat: trans["vat"] )
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