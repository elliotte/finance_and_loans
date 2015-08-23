# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :disclosure do
    body "General disclosure"
    type "Disclosure"
  end
  factory :global_report do
  	title "Company Name"
  	body "Company Example Ltd"
  	type "GlobalReport"
  end
  factory :director_report do
  	title "Principal Activity"
  	body "Distribution of products"
  	type "DirectorReport"
  end
end

