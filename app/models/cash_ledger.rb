class CashLedger < Ledger

  accepts_nested_attributes_for :transactions
  
  def payments
  	self.credit_transactions
  end

  def lodgements
  	self.debit_transactions
  end

  def summarise filtered_transactions
    totals = filtered_transactions.select("mi_tag, sum(amount)").group(:mi_tag)
    parse_to_hash(totals)
  end
  #to change to summparise all payments, for ledger_manager helper?
  def summarise_payments
    totals = payments.select("mi_tag, sum(amount)").group(:mi_tag)
    parse_to_hash(totals)
  end

  def summarise_lodgements
    totals = lodgements.select("mi_tag, sum(amount)").group(:mi_tag)
    parse_to_hash(totals)
  end

  def export_to_csv(start_date, end_date)
    CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
      csv << ["Booking Date", "Amount", "VAT", "Description", "Your tag", "Monea Tag" ]
      transactions.for_date(start_date, end_date).each do |trns|
        csv << trns.attributes.values_at("acc_date", "amount", "vat", "description", "mi_tag", "monea_tag", "", "-" )
      end
    end
  end

  def export_tb_to_csv tb_data
      CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
      csv << ["Reporting Line", "-", "Debit", "Credit"]
          tb_data.each do |tb_line|
            if tb_line["lineAmount"] > 0.00
              csv << [tb_line["reportingLine"], "-", tb_line["lineAmount"], "0"]
            else
              csv << [tb_line["reportingLine"], "-", "0", tb_line["lineAmount"]]
            end
          end
      end
  end

  def export_gl_to_csv gl_data
    CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
      csv << ["GL Parent", "-", "Date", "Trn ID", "Debit", "Credit", "yourTag", "Description"]
          gl_data.each do |gl_line|
            if gl_line["amt"].to_f > 0.00
              csv << [gl_line["glName"], "-", gl_line["date"]  , gl_line["trnID"] , gl_line["amt"], "0", gl_line["tag"], gl_line["description"]]
            else 
              csv << [gl_line["glName"], "-", gl_line["date"]  , gl_line["trnID"] , "0", gl_line["amt"], gl_line["tag"], gl_line["description"]]
            end
          end
      end
  end

  # def write_vat_to_csv data
  #   CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
  #       csv << ["HEADERS"]
  #       data.each do | row |
  #           csv << row
  #       end
  #   end
  # end

  def parse_csv_and_book file, options
    if options[:bank] == "true"
      transaction_hash = ParseBankCSV.new(file.path).return_data
      book_bank_csv(transaction_hash)
    else
      tr_hash = ParseDefaultCSV.new(file.path).return_data
      book_default_csv(tr_hash)
    end
  end

  def book_default_csv (t_hash)
    t_hash.each do |trans|
      mi_tag = trans['mi_tag'] || "No-Mapping"
      a = transactions.build(acc_date: trans["accounting date"], amount: trans["amount"], description: trans["description"], mi_tag: mi_tag )
        if a.amount < 0.00
          a[:type] = 'Credit'
          a[:amount] = a.amount * -1
        else
           a[:type] = 'Debit'
        end
      a.save
     end
  end

  def book_bank_csv (tran_hash)
    tran_hash.each do |trans|
      a = transactions.build(acc_date: trans[:acc_date], amount: trans[:amount], description: trans[:description], mi_tag: 'un_tagged')
        if a.amount < 0.00
          a[:type] = 'Credit'
          a[:amount] = a.amount * -1
        else
           a[:type] = 'Debit'
        end
      a.save
     end
  end

  def book_single_trn trn
        #to fix, use create given financial control?
        # debit and credit passed in no filter catch to determine
        _trn = self.transactions.build(type: trn['type'], acc_date: trn['acc_date'], mi_tag: trn['mi_tag'], amount: trn['amount'], monea_tag: trn['monea_tag'], vat: trn['vat'], description: trn['description'])
        _trn.save ? true : false
  end

  def parse_to_hash transactions
    tag_totals = {}
    transactions.each do | t |
      tag_totals["#{t.mi_tag}"] = t.sum.to_f
    end
    return tag_totals
  end

end
