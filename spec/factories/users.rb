# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    sequence(:email) { |i| "user_#{i}@monea.build" }
    uid 1234
  end

end
