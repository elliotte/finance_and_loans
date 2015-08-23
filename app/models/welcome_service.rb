class WelcomeService

	def initialize monea_modal
		  $item = monea_modal
	end

	def load_ifrs_report values
	    $item.book_values(values)
      $cy_jnl = EtbValue.new(repdate: $item.current_end, amount: 1500.00, description: "Being a journal to fix sales", mitag: 'use either a jnl code or a TB tag', ifrstag: 'Revenue') 
      $py_jnl = EtbValue.new(repdate: $item.comparative_end, amount: 1500.00, description: "Being a journal to fix sales", mitag: 'use either a jnl code or a TB tag', ifrstag: 'Revenue' ) 
      load_common
	end

	def load_gaap_report values
	    $item.book_values(values)
      $cy_jnl = EtbValue.new(repdate: $item.current_end, amount: 1500.00, description: "Being a journal to fix sales", mitag: 'use either a jnl code or a TB tag', ifrstag: 'Sales') 
      $py_jnl = EtbValue.new(repdate: $item.comparative_end, amount: 1500.00, description: "Being a journal to fix sales", mitag: 'use either a jnl code or a TB tag', ifrstag: 'Sales' ) 
      load_common
	end

	def load_common
      $item.values << $py_jnl
      $item.values << $cy_jnl
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