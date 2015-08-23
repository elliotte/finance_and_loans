# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :value do
    report
    mitag "testmiTag"
    amount 100.01
    repdate Time.now
    	factory :next_month do
    		repdate Time.now+1.month
    	end
    	factory :value_cash do
    		mitag "Cash"
    	end

    	factory :next_month_value_revenue do
    		mitag "Revenue"
    		repdate Time.now+1.month
    	end
  end

  factory :report do
    title "New report testing"
    report_type 'Statutory'
    format 'IFRS'
    current_end Date.new(2014,12,31)
    comparative_end Date.new(2013,12,31)
      factory :report_with_values_this_month do

	      transient do
	        values_count 5
	      end

	      after(:create) do |report, evaluator|
	        create_list(:value, evaluator.values_count, report: report)
	      end
      end
      factory :report_with_values_next_month do

	      transient do
	        values_count 10
	      end

	      after(:create) do |report, evaluator|
	        create_list(:next_month, evaluator.values_count, report: report)
	      end
      end
      factory :report_with_values_cash_badline do

	      transient do
	        values_count 10
	      end

	      after(:create) do |report, evaluator|
	        create_list(:value_cash, evaluator.values_count, report: report)
	      end
      end
      factory :report_with_values_cash_badline_next_month do

	      transient do
	        values_count 10
	      end

	      after(:create) do |report, evaluator|
	        create_list(:next_month_value_revenue, evaluator.values_count, report: report)
	      end
      end
      factory :report_with_multiple_badline_values_and_range do

	      transient do
	        values_count 2
	      end

	      after(:create) do |report, evaluator|
			create_list(:next_month_value_revenue, evaluator.values_count, report: report)
			create_list(:next_month, evaluator.values_count, report: report)
			create_list(:value, evaluator.values_count, report: report)
			create_list(:value_cash, evaluator.values_count, report: report)
	      end
      end
    end
  end
