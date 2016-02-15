module CashFlowHelper

  def fetch_columns
      return 12 if @settings[:format]["cf_length"] == "Full-Year"
      return 6 if @settings[:format]["cf_length"] == "Half-Year"
      3
  end

  def create_date
      Date.parse(@settings[:format]["start_month"])
  end

  def user_input_cell
  	return '<td><input class="user-input-amt" type="text" placeholder="0.00"></td>'.html_safe
  end

  def list_month_names
    Date::MONTHNAMES.slice(1,12)
  end


end
