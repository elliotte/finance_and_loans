module LedgersHelper

  def map_monea_tags
    $trns_for_view.map { |trans| trans["monea_tag"] }.uniq
  end

  def set_cash_book_headers
    $cashbook_headers = map_monea_tags
    $cash_book_columns = $cashbook_headers.count
    $css_column_width = $cash_book_columns/60.to_f
  end

  def show_first_20
    @data[:timeline_transactions].first(20)
  end

  def matching_header?(transaction, column_index)
    return true if $cashbook_headers[column_index] == transaction.monea_tag
    false
  end

  def sum_list
    yield.select! { |x| !x.nil? }.inject(:+).to_i
  end

  # July-15 - used by _new_trans..form
  def ledger_options
    options = ''
    current_user.ledgers.each do |ledger|
      options += content_tag(:option, ledger.user_tag, value: ledger.id)
    end
    options.html_safe
  end

       #  def ledger_team_list
       #    teams = Team.all - @ledger.teams
       #    teams.collect{|t| [t.id, t.name]}
       #  end

       #  def ledger_user_list
       #    users = User.all - @ledger.users
       #    users.collect{|u| [u.email, u.id]}
       #  end

end
