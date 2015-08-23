# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teams_user do
   user
   team
  end
  factory :pending_teams_user, parent: :teams_user do
    status 'pending'
  end

  factory :active_teams_user, parent: :teams_user do
    status 'active'
  end

end
