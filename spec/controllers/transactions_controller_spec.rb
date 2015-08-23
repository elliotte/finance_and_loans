require 'rails_helper'

RSpec.describe TransactionsController, :type => :controller do
	
  	before do
        controller.session[:token] = '265378652378682786237846'
        SalesLedger.any_instance.stub(:build_back_end).and_return(true)
        Transaction.any_instance.stub(:create_drive_file).and_return(true)
        @trn = FactoryGirl.create(:transaction)
        @sales = FactoryGirl.create(:sales_ledger)
    end
  	describe "GET show" do
      it 'returns http success' do
         xhr :get, :show, id: @trn.id, format: 'js'
        expect(response).to be_success
      end
      it 'should render show page' do
         xhr :get, :show, id: @trn.id, format: 'js'
        expect(response).to render_template('show')
      end
      it 'should assign transaction correctly' do
        xhr :get, :show, id: @trn.id, format: 'js'
        test_trn = @trn
        controller_trn = assigns(:transaction)
        expect(controller_trn.id).to eq(test_trn.id)
      end
    end
    # USED BY LEDGER MANAGER
    describe "PUT update transaction controlled" do
      it 'returns http success' do
      	trn_params = {"transaction_id"=>@trn.id, "vat"=>"", "mi_tag"=>""}
      	type = @trn.type.downcase.to_s
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "MyString" }
        expect(response).to be_success
      end
      it 'should render update template' do
      	trn_params = {"transaction_id"=>@trn.id, "vat"=>"", "mi_tag"=>""}
      	type = @trn.type.downcase.to_s
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "MyString" }
        expect(response).to render_template('update_mi_tag')
      end
      it 'should assign transaction correctly' do
      	trn_params = {"transaction_id"=>@trn.id, "vat"=>"", "mi_tag"=>""}
      	type = @trn.type.downcase.to_s
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "MyString" }
      	test_trn = @trn
      	controller_trn = assigns(:transaction)
      	expect(controller_trn.id).to eq(test_trn.id)
      end
      it 'should update vat correctly' do
      	trn_params = {"transaction_id"=> @trn.id, "vat"=>"11.11", "mi_tag"=>""}
      	type = @trn.type.downcase.to_s
      	expect(@trn.vat).to eq 0.00
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "MyString" }
        updatedTrn = Transaction.find(@trn.id)
        expect(updatedTrn.vat).to eq 11.11
      end
      it 'should update mi tag correctly if present' do
      	trn_params = {"transaction_id"=> @trn.id, "vat"=>"", "mi_tag"=>"YES UPDATED"}
      	type = @trn.type.downcase.to_s
      	expect(@trn.mi_tag).to eq "MyString"
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "MyString" }
        updatedTrn = Transaction.find(@trn.id)
        expect(updatedTrn.mi_tag).to eq "YES UPDATED"
      end
      it 'should NOT update mi tag if not present' do
      	trn_params = {"transaction_id"=> @trn.id, "vat"=>"", "mi_tag"=>""}
      	type = @trn.type.downcase.to_s
      	expect(@trn.mi_tag).to eq "MyString"
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "MyString" }
        updatedTrn = Transaction.find(@trn.id)
        expect(updatedTrn.mi_tag).to eq "MyString"
      end
      it 'should update monea tag correctly if present' do
      	trn_params = {"transaction_id"=> @trn.id, "vat"=>"", "mi_tag"=>""}
      	type = @trn.type.downcase.to_s
      	expect(@trn.monea_tag).to eq "MyString"
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "YES UPDATED" }
        updatedTrn = Transaction.find(@trn.id)
        expect(updatedTrn.monea_tag).to eq "YES UPDATED"
      end
      it 'should NOT update monea tag correctly if no change' do
      	trn_params = {"transaction_id"=> @trn.id, "vat"=>"", "mi_tag"=>""}
      	type = @trn.type.downcase.to_s
      	expect(@trn.monea_tag).to eq "MyString"
        xhr :put, :update_transaction_controlled, id: @trn.id, format: 'js', transaction: trn_params, type => {"monea_tag" => "MyString" }
        updatedTrn = Transaction.find(@trn.id)
        expect(updatedTrn.monea_tag).to eq "MyString"
      end
    end

    describe "invoice paid" do
        before do 
          @trn.update(paid: false, invoice_file_link: "d/111/edit")
          expect(@trn.paid).to eq false
        end
        it 'should mark transaction as paid' do
          xhr :put, :invoice_paid, id: @trn.id, format: 'js'
          expect(Transaction.find(@trn.id).paid).to eq true
        end
        it 'sets googleFileID' do
          GoogleService.any_instance.stub(:rename_inv_file_paid)
          xhr :put, :update_invoice_file_paid, id: @trn.id, format: 'js'
          expect($fileID).to eq "111"
        end
        it 'calls googleService' do
          GoogleService.any_instance.should_receive(:rename_inv_file_paid).and_return(@result = "GOOGLE CALLED")
          xhr :put, :update_invoice_file_paid, id: @trn.id, format: 'js'
          expect(@result).to eq "GOOGLE CALLED"
        end
    end


end

# "transaction"=>{"transaction_id"=>"3448", "vat"=>"", "mi_tag"=>""}, "debit"=>{"monea_tag"=>"Sales"}, "action"=>"update_transaction_controlled"