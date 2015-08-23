require 'spec_helper'

# describe Team do

#   describe 'Associations' do
#     it{should have_and_belong_to_many(:users)}
#     it{should have_and_belong_to_many(:ledgers)}
#   end

#   describe 'Validations' do
#     it{should validate_presence_of(:name)}
#   end

#   describe 'instance methods' do
#     before do
#       @team = FactoryGirl.create(:team)
#       @user1 = FactoryGirl.create(:user)
#       @user2 = FactoryGirl.create(:user)
#       @ledger1 = FactoryGirl.create(:ledger)
#       @ledger2 = FactoryGirl.create(:ledger)
#       @team.users << @user1
#       @team.ledgers << @ledger1
#     end

#     describe 'member?' do
#       it 'returns true if user is member of a team' do
#         expect{@team.member?(@user1)}.to be_true
#       end

#       it 'returns false if user is member of a team' do
#         expect(@team.member?(@user2)).to be_false
#       end
#     end


#     describe 'join' do
#       it 'adds a user to team' do
#         @team.join(@user2)
#         expect(@team.member?(@user2)).to be_true
#       end
#     end

#     describe 'unjoin' do
#       it 'removes a user to team' do
#         @team.unjoin(@user2)
#         expect(@team.member?(@user2)).to be_false
#       end
#     end

#     describe 'share_ledger' do
#       it 'shares a particular ledger with a team' do
#         @team.share_ledger(@ledger2)
#         expect(@team.ledgers).to include(@ledger2)
#       end
#     end

#   end

# end
