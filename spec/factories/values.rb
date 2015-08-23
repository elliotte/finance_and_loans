
FactoryGirl.define do

  factory :tb_value, class: TbValue, parent: :value do
    type 'TbValue'
    amount 9.99
    mitag "MyString"
    repdate Time.now
  end

  factory :etb_value, class: EtbValue, parent: :value do
    type 'EtbValue'
    amount 9.99
    mitag "miTag from user"
    repdate Time.now
  end
end
# Read about factories at https://github.com/thoughtbot/factory_girl

#in reports factory.rb file