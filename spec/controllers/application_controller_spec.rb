require 'rails_helper'

describe ApplicationController do
	before do 
		controller.session[:token] = '265378652378682786237846'	
	end

	describe "#verify_token" do 
		it "verifies token" do
			ApplicationController.any_instance.stub(:verify_token).and_return true
			assert_equal true,controller.send(:verify_token)
		end
	end

	describe "#current_user" do 
		before do 
			@current_user = FactoryGirl.create(:user)
		end

		it "returns current user" do 
			ApplicationController.any_instance.stub(:current_user).and_return @current_user
		end
	end

	describe "#google_service" do 
		it "returns google service instance" do 
			expect(controller.send(:google_service)).to be_an_instance_of GoogleService
		end
	end
end