class Ledger < ActiveRecord::Base

  require 'csv'

  validates_presence_of :user_tag

  belongs_to :user
  has_many :transactions, foreign_key: :ledger_id, dependent: :destroy
  has_many :viewers, foreign_key: :ledger_id, dependent: :destroy

  before_create :check_or_set_ob

  scope :last_four, -> {order('updated_at desc').first(4)}

  def credit_transactions
    transactions.credit
  end

  def debit_transactions
    transactions.debit
  end

  def transactions_current_month
    current_month = Date.current
    transactions.for_date(current_month.at_beginning_of_month, current_month.at_end_of_month)
  end

  def transactions_last_3_months
    date_end = Date.current
    transactions.for_date(date_end-3.month, date_end)
  end

  def transactions_prior_month
    prior_month = Date.current - 1.month
    transactions.for_date(prior_month.at_beginning_of_month, prior_month.at_end_of_month)
  end

  def check_or_set_ob
    return unless opening_balance == nil
      self.opening_balance = 0.00
  end

  def write_vat_to_csv data
    
    CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
        csv
    end
    vat_summary = data[:vat_return]
    stats_summary = data[:csv_data]

    CSV.open("#{Rails.root}/files/new-file.csv", 'w') do |csv|
        vat_summary.each do |row|
          csv << row
        end
        csv << []
        csv << ["Payments"]
        csv << []
        stats_summary[:payments].each do |row|
          csv << row
        end
        csv << []
        csv << ["Receipts"]
        csv << []
        stats_summary[:receipts].each do |row|
          csv << row
        end
        csv << []
        csv << ["Headlines"]
        csv << []
        stats_summary[:total].each do |row|
          csv << row
        end
    end
    # END of csv write
  end

  def upload_vat_csv title, token
    GoogleService.new($client, $authorization).upload_ledger_csv(title, token)
  end

end
