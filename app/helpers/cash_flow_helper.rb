module CashFlowHelper

  def fetch_columns
      return 12 if @settings[:format]["cf_length"] == "Full-Year"
      return 6 if @settings[:format]["cf_length"] == "Half-Year"
      3
  end

  def create_date
      Date.parse(@settings[:format]["start_month"])
  end

end
