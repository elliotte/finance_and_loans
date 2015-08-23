require 'rails_helper'

RSpec.describe Viewer, type: :model do
   describe 'Associations' do
	    it { is_expected.to belong_to(:ledger) }
   end
end
