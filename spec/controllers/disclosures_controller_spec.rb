require 'rails_helper'

describe DisclosuresController do

  describe "testing" do

    before do
      @current_user = FactoryGirl.create(:user)
      @report = FactoryGirl.create(:report)
      @disclosure = FactoryGirl.create(:disclosure)
      @global = FactoryGirl.create(:global_report)
      @dir_rep = FactoryGirl.create(:director_report)
      controller.session[:token] = '265378652378682786237846'
      controller.stub(:current_user){ @current_user }
      @current_user.reports << @report
      @report.disclosures << @disclosure
      @report.disclosures << @global
      @report.disclosures << @dir_rep
    end

    context "main routes" do
      describe "GET 'new'" do
        before do
          xhr :get, :new, report_id: @report.id, format: 'js'
        end
        it "returns http success" do
          expect(response).to be_success
        end
        it 'should render index new' do
          expect(response).to render_template(:new)
        end
        it 'should asseign the report and disclosure as new object' do
          expect(assigns(:disclosure)).to be_a_new(Disclosure)
        end
      end
      # END OF DESCRIBE GET NEW
      describe "POST 'create' " do
        context "Global create" do
          it 'should be a success' do
            params = {"disclosure"=>{"title"=>"TestingTitle", "body"=>"TestinBody", "type"=>"GlobalReport", "added_by"=>"example@gmail.com"}, "report_id"=> @report.id.to_s }
            xhr :post, :create, params
            expect(response).to be_success
          end
          it 'should render index new' do
            params = {"disclosure"=>{"title"=>"TestingTitle", "body"=>"TestinBody", "type"=>"GlobalReport", "added_by"=>"example@gmail.com"}, "report_id"=> @report.id.to_s }
            xhr :post, :create, params
            expect(response).to render_template(:create)
          end
          it 'can create a GlobalReport disclosure' do
            params = {"disclosure"=>{"title"=>"TestingTitle", "body"=>"TestinBody", "type"=>"GlobalReport", "added_by"=>"example@gmail.com"}, "report_id"=> @report.id.to_s }
            xhr :post, :create, params#, format: 'js'
            _last = Disclosure.last
            expect(_last.id).not_to be_nil
            expect(_last.title).to eq "TestingTitle"
            expect(_last).to be_an_instance_of GlobalReport
          end
        end
        context "DirectorReport create" do
          it 'should be a success' do
            params = {"disclosure"=>{"title"=>"TestingTitle", "body"=>"TestinBody", "type"=>"DirectorReport", "added_by"=>"example@gmail.com"}, "report_id"=> @report.id.to_s }
            xhr :post, :create, params#, format: 'js'
            expect(response).to be_success
          end
          it 'should create a DirectorReport disclosure' do
            params = {"disclosure"=>{"title"=>"TestingTitle", "body"=>"TestinBody", "type"=>"DirectorReport", "added_by"=>"example@gmail.com"}, "report_id"=> @report.id.to_s }
            xhr :post, :create, params#, format: 'js'
            _last = Disclosure.last
            expect(_last.id).not_to be_nil
            expect(_last.title).to eq "TestingTitle"
            expect(_last).to be_an_instance_of DirectorReport
          end
        end
      end
      # END OF DESCRIBE POST CREATE
      describe "GET 'Edit'" do
          before do
            xhr :get, :edit, id: @global.id, report_id: @report.id, format: 'js'
          end
          it 'should be a success' do
            expect(response).to be_success
          end
          it 'should render edit template' do
            expect(response).to render_template(:edit)
          end
          it 'assigns correct report' do
            controller_report = assigns(:report)
            expect(controller_report).to eq @report
          end
          it 'assigns correct disclosure' do
            controller_disc = assigns(:disclosure)
            expect(controller_disc).to eq @global
          end
      end
      # END OF EDIT DESCIRBE
      describe "PUT 'update'" do
          context "global report" do
              before do
                xhr :put, :update, id: @global.id, report_id: @report.id, disclosure: {body: "UPDATED"}, format: 'js'
                expect(@global.body).to eq "Company Example Ltd"
              end
              it "returns http success" do
                expect(response).to be_success
              end
              it 'should render js update template' do
                expect(response).to render_template(:update)
              end
              it 'assings the correct report' do
                controller_report = assigns(:report)
                expect(controller_report).to eq @report
              end
              it 'assigns the correct disclosure' do
                controller_disc = assigns(:disclosure)
                expect(controller_disc).to eq @global
              end
              it 'has updated attribute' do
                test = Disclosure.find(@global.id)
                expect(test.body).to eq "UPDATED"
              end
          end
           context "director report" do
              before do
                xhr :put, :update, id: @dir_rep.id, report_id: @report.id, disclosure: {body: "UPDATED"}, format: 'js'
                expect(@dir_rep.body).to eq "Distribution of products"
              end
              it "returns http success" do
                expect(response).to be_success
              end
              it 'should render js update template' do
                expect(response).to render_template(:update)
              end
              it 'assings the correct report' do
                controller_report = assigns(:report)
                expect(controller_report).to eq @report
              end
              it 'assigns the correct disclosure' do
                controller_disc = assigns(:disclosure)
                expect(controller_disc).to eq @dir_rep
              end
              it 'has updated attribute' do
                test = Disclosure.find(@dir_rep.id)
                expect(test.body).to eq "UPDATED"
              end
          end
      end
      # END OF PUT DESCIRBE
      describe "DELETE Destroy" do
          before do
            xhr :delete, :destroy, id: @global.id, report_id: @report.id, format: 'js'
          end
          it "returns http success" do
            expect(response).to be_success
          end
          it 'should render js destroy template' do
            expect(response).to render_template(:destroy)
          end
          it 'assings the correct report' do
            controller_report = assigns(:report)
            expect(controller_report).to eq @report
          end
          it 'assigns the correct disclosure' do
            controller_disc = assigns(:disclosure)
            expect(controller_disc).to eq @global
          end
      end

      describe 'GET manager' do
        before do
          get :manager, report_id: @report.id
        end
        it 'resonse is success' do
          expect(response).to be_success
        end
        it 'renders manager template' do
          expect(response).to render_template('manager')
        end
        it 'fetched all disclosures of current report' do
          expect(assigns(:disclosures)).to match_array(@report.disclosures)
        end
      end
    end
    # END OF CONTEXT MAIN ROUTES

    # describe "GET 'edit'" do
    #   it "returns http success" do
    #     get :edit, {report_id: @report.id, id: @disclosure.id, format: 'JS'}
    #     expect(response).to be_success
    #   end

    #   it 'should render edit' do
    #     get :edit, {report_id: @report.id, id: @disclosure.id, format: 'JS'}
    #     expect(response).to render_template(:edit)
    #   end

    #   it 'should assign the disclosure' do
    #     get :edit, {report_id: @report.id, id: @disclosure.id, format: 'JS'}
    #     expect(assigns(:disclosure)).to eq(@disclosure)
    #   end
    # end

    # describe "PUT 'update' " do
    #   #failing??
    #   # it "returns to reports's show page after success" do
    #   #   put :update,  {report_id: @report.id, id: @disclosure.id, disclosure: {body: "disclosurenew"}}
    #   #   expect(response).to redirect_to(report_path(@report))
    #   #   expect(@disclosure).to eq 'Directo'

    #   # end
    #   # it "returns to purchase's edit page after failure" do
    #   #   put :update,  {report_id: @report.id, id: @disclosure.id, disclosure: {body: "disclosurenew"}}
    #   #   expect(response).to redirect_to(report_path(@report))
    #   # end
    # end

    # describe "DELETE 'destroy'" do
    #   it "returns http success" do
    #     expect { delete :destroy, {report_id: @report.id, id: @disclosure.id } }.to change(Disclosure, :count).by(-1)
    #   end
    # end


  end
end
