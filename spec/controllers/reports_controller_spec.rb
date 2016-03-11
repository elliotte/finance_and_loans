require 'rails_helper'
APP =YAML.load_file('config/application.yml')

describe ReportsController do

  describe "main routes" do

    before do
      set_user_auth
    end
    context "index and CRUD" do
      describe "GET 'index'" do
        before do
          get :index
        end
        it "returns http success" do
          expect(response).to be_success
        end

        it 'should render index page' do
          expect(response).to render_template('index')
        end

        it "assigns all reports as @reports" do
          expect(assigns(:reports)).to eq @current_user.reports
        end
      end
      describe "GET 'new'" do
        before do
          xhr :get, :new, format: 'js'
        end
        it "returns http success" do
          expect(response).to be_success
        end
        it 'should render index new' do
          expect(response).to render_template(:new)
        end
        it 'should asseign the ledger and transaction as new object' do
          expect(assigns(:report)).to be_a_new(Report)
        end
      end
      describe "POST 'create'" do
        #to add invalid failing once control at end decided?
        it 'should increase Ledger count by 1' do
          params = {report: FactoryGirl.attributes_for(:report)}
          expect { post :create, params }.to change(Report, :count).by(1)
        end
        it 'should redirect to new report path' do
          post :create, {report: FactoryGirl.attributes_for(:report)}
          expect(response).to redirect_to(report_path(Report.all.last))
        end
      end
      describe "GET 'Edit'" do
          before do
            xhr :get, :edit, id: @report.id, format: 'js'
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
     end
     # END OF EDIT DESCIRBE
     describe "PUT 'update'" do
          before do
            xhr :put, :update, id: @report.id, report: {"title"=>"TESTIFRS114", "current_end(3i)"=>"1", "current_end(1i)"=>"2014", "current_end(2i)"=>"12", "comparative_end(3i)"=>"1", "comparative_end(1i)"=>"2013", "comparative_end(2i)"=>"12", "format"=>"IFRS", "report_type"=>"Statutory"}, format: 'js'
            expect(@report.title).to eq "New report testing"
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
          it 'has updated attribute' do
            test = Report.find(@report.id)
            expect(test.title).to eq "TESTIFRS114"
          end
      end
      # END OF PUT DESCIRBE
      describe "DELETE Destroy" do
          before do
            expect(@current_user.reports.count).to eq 3
            xhr :delete, :destroy, id: @report.id
          end
          it 'assings the correct report' do
            controller_report = assigns(:report)
            expect(controller_report).to eq @report
          end
          it 'should redirecto to report path' do
            expect(response).to redirect_to(reports_path)
          end
          it 'deletes user report' do
            expect(@current_user.reports.count).to eq 2
          end
      end
      describe "GET 'show'" do
        before do
          value = FactoryGirl.create(:value, amount: 10, repdate: Date.yesterday, report: @report)
          get :show, id: @report.id
        end
        it "returns http success" do
          expect(response).to be_success
        end
        it 'should render index new' do
          expect(response).to render_template(:show)
        end
        it 'should assigns the instance variables' do
          expect(assigns(:report)).to eq(@report)
        end
      end
      #END OF LAST DESCRIBE
    end
    #END OF CONTEXT CRUD
    context "FEATURE routes" do

      describe "GET 'report_manger' report page" do
        it "returns http success" do
          get :report_manager, id: @report.id
          expect(response).to be_success
        end
        it 'should render index new' do
          get :report_manager, id: @report.id
          expect(response).to render_template(:report_manager)
        end
        it 'should assigns the instance variables' do
          get :report_manager, id: @report.id
          expect(assigns(:report)).to eq(@report)
        end
      end
      describe "GET 'show' dashboard page " do
        before do
           @value = FactoryGirl.create(:tb_value)
           @report.values << @value
        end
        it "returns http success" do
          get :show_dashboard, id: @report.id
          expect(response).to be_success
        end
        it 'should render show dashboard template' do
          get :show_dashboard, id: @report.id
          expect(response).to render_template(:show_dashboard)
        end
        # it 'should render ukgaap if gaap report' do
        #   @report.format = 'UKGAAP'
        #   get :show_dashboard, id: @report.id
        #   expect(response).to render_template(partial: 'reports/ukgaap/p_n_l')
        # end
        it 'should assigns the instance variables' do
          get :show_dashboard, id: @report.id
          expect(assigns(:report)).to eq(@report)
        end
      end
      describe "PUT 'share' user report with reader" do
          before do
            xhr :put, :share, id: @report.id, userID: 1234, format: 'js'
          end
          it "returns http success" do
            expect(response).to be_success
          end
          it "assigns report" do
            expect(assigns(:report)).to eq(@report)
          end
          it 'changes readers when user is found' do
            expect{xhr :put, :share, id: @report.id, userID: 1234, format: 'js'}.to change(@report.readers, :count).by(1)
          end
          it 'does not change readers when found' do
            expect{xhr :put, :share, id: @report.id, userID: 14, format: 'js'}.to change(@report.readers, :count).by(0)
          end
      end
      #Last feature spec
    end
    #END of feature context
    context "NESTED model routes" do
      describe 'add_value' do
          before do
            @current_user = FactoryGirl.create(:user)
            @report = FactoryGirl.create(:report, user_id: @current_user.id)
            @params = {id: @report.id, value: FactoryGirl.attributes_for(:value)}
          end
          it 'response is success' do
            xhr :post, :add_value, @params
            expect(response).to be_success
          end
          it 'renders add_value template' do
            xhr :post, :add_value, @params
            expect(response).to render_template('add_value')
          end
          it 'adds a new Value record into DB' do
            expect{xhr :post, :add_value, @params}.to change(TbValue, :count).by(1)
          end
      end
      # END OF ADD VALUE
      describe 'new_journal' do
        before do
          @current_user = FactoryGirl.create(:user)
          @report = FactoryGirl.create(:report, user_id: @current_user.id)
        end
        it 'response is success' do
          xhr :get, :new_journal, id: @report.id
          expect(response).to be_success
        end

        it 'renders new_journal template' do
          xhr :get, :new_journal, id: @report.id
          expect(response).to render_template('new_journal')
        end
      end
      describe 'save_journal' do
        before do
          @current_user = FactoryGirl.create(:user)
          @report = FactoryGirl.create(:report, user_id: @current_user.id)
          @params = {id: @report.id}
          @etb_values = {'description' => 'test description', 'etb_values' => {'1' => FactoryGirl.attributes_for(:value), '2' => FactoryGirl.attributes_for(:value), '3' => FactoryGirl.attributes_for(:value)}}
        end
        it 'returns an error if no values are passed' do
          xhr :post, :save_journal, @params
          expect(assigns(:error)).to eq('Please add atleast one value')
        end
        it 'response is success' do
          xhr :post, :save_journal, @params.merge('report' => @etb_values)
          expect(response).to be_success
        end
        it 'renders template save_journal' do
          xhr :post, :save_journal, @params.merge('report' => @etb_values)
          expect(response).to render_template('save_journal')
        end
        it 'saves Value to db' do
          expect{
            xhr :post, :save_journal, @params.merge('report' => @etb_values)
          }.to change(@report.etb_values, :count).by(3)
        end
      end

      describe "PUT update_value" do
        context "TB value update" do
            before do
              @value = FactoryGirl.create(:tb_value, mitag: "MyString")
              @report.values << @value
              expect(@report.values.last.mitag).to eq "MyString"
              xhr :put, :update_value, id: @report.id, report: {"value_id"=>@value.id}, tb_value: {mitag: "UPDATED"},  format: 'js'
            end
            it 'responds success' do
              expect(response).to be_success
            end
            it 'should render js update value template' do
                expect(response).to render_template(:update_value)
            end
            it 'should change the value attribute' do
              expect(@report.values.last.mitag).to eq "UPDATED"
            end
        end
        context "ETB value_update" do
            before do
              @value = FactoryGirl.create(:etb_value)
              @report.values << @value
              expect(@report.values.last.mitag).to eq "miTag from user"
              xhr :put, :update_value, id: @report.id, report: {"value_id"=>@value.id}, etb_value: {mitag: "UPDATED"},  format: 'js'
            end
            it 'responds success' do
              expect(response).to be_success
            end
            it 'should render js update value template' do
                expect(response).to render_template(:update_value)
            end
            it 'should change the value attribute' do
              expect(@report.values.last.mitag).to eq "UPDATED"
            end
        end
      end
      #last NESTED MODEL routes
    end
    #END of ADDING context
    context "EXPORT routes" do
      describe "GET 'import_csv' form " do
        before do
          xhr :get, :import_csv, {id: @report.id, format: 'JS'}
        end
        it "returns http success" do
          expect(response).to be_success
        end
        it 'should render import csv form' do
          expect(response).to render_template(:import_csv)
        end
        it "assigns a report as @reports" do
          expect(assigns(:report)).to eq(@report)
        end
      end
      describe "POST 'user_csv_import' with HTTP" do
        let(:csv_file) { Rack::Test::UploadedFile.new("#{Rails.root}/files/reportCSV.csv") }
        it 'changes values count after posting by 29' do
          expect{post :user_csv_import, id: @report.id, file: csv_file}.to change(Value, :count).by(156)
        end
        it 'is expected to flash no file if no file' do
          post :user_csv_import, id: @report.id, file: csv_file
          expect(response).to redirect_to(report_path(@report))
        end
      end
      #last EXPORT routes
    end
    # END OF CONTEXT SPECS
    # describe "POST 'export_dash' to Google" do
    #   before do
    #     Auth.user_auth
    #     ApplicationController.any_instance.stub(:google_service)
    #     GoogleService.any_instance.stub(:upload_new_file_csv)
    #     params = {id: @report.id, "_json" => {} }
    #     xhr :post, :export_dash, params
    #   end
    #   it 'correctly assigns report' do
    #     test_report = @report
    #     controller_report = assigns(:report)
    #     expect(controller_report).to eq(test_report)
    #     expect(response).to be_success
    #   end
    # end
    # #ADDING VALUES
    #  describe "GET 'new value form' JS" do
    #   before { Rails.stub_chain('application.config.consider_all_requests_local').and_return(false) }

    #   it "returns success" do
    #     debugger
    #     post :add_value,id: @report.id,value:@value.attributes ,format: 'JS'
    #     expect(response).to be_success
    #   end

    #   it 'should render new value' do
    #     post :add_value,id: @report.id,tb_value: true, format: 'JS'
    #     expect(response).to render_template(:new_value)
    #   end

    #   #render_views
    #   it 'should render a form with add values' do
    #     post :add_value,id: @report.id,tb_value: true, format: 'JS'
    #     expect(response.body).to match /Add Values/
    #   end
    # end

    # describe 'POST add_report_values TB' do
    #     it 'should add 3 transactions' do
    #         params = {report_id: @report.id, report: {"tb_values_attributes"=>{"1418291776788"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"12412", "_destroy"=>"false"}, "1418291777692"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"124124", "_destroy"=>"false"}, "1418291778510"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"124124", "_destroy"=>"false"}}} ,}
    #         expect {post :add_report_value, params}.to change(@report.values, :count).by(3)
    #     end

    #     it 'should not add 2 transactions invalid attributes' do
    #         params = {report_id: @report.id, report: {"tb_values_attributes"=>{"1418291776788"=>{"repdate(3i)"=>"", "repdate(2i)"=>"", "repdate(1i)"=>"", "amount"=>"", "_destroy"=>"false"}, "1418291777692"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"", "amount"=>"", "_destroy"=>"false"}, "1418291778510"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"", "_destroy"=>"false"}}},}
    #         expect {post :add_report_value, params}.to change(@report.values, :count).by(0)
    #     end
    # end

    # describe 'POST add_report_values ETB' do
    #     it 'should add 3 transactions' do
    #         params = {report_id: @report.id, report: {"etb_values_attributes"=>{"1418293880018"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"123", "_destroy"=>"false"}, "1418293881631"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"41241", "_destroy"=>"false"}}} ,}
    #         expect {post :add_report_value, params}.to change(@report.values, :count).by(2)
    #     end
    #     it 'should not add 2 transactions invalid attributes' do
    #         params = {report_id: @report.id, report: {"etb_values_attributes"=>{"1418293880018"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"", "_destroy"=>"false"}, "1418293881631"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"", "_destroy"=>"false"}}},}
    #         expect {post :add_report_value, params}.to change(@report.values, :count).by(0)
    #     end
    #     it 'is expected to set flash notice as successful' do
    #         params = {report_id: @report.id, report: {"etb_values_attributes"=>{"1418293880018"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"123", "_destroy"=>"false"}, "1418293881631"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"41241", "_destroy"=>"false"}}},}
    #         post :add_report_value, params
    #         is_expected.to set_the_flash[:notice].to('Values added')
    #     end
    #     it 'is expected to set flash as not successful' do
    #         params = {report_id: @report.id, report: {"etb_values_attributes"=>{"1418293880018"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"", "_destroy"=>"false"}, "1418293881631"=>{"repdate(3i)"=>"1", "repdate(2i)"=>"12", "repdate(1i)"=>"2014", "amount"=>"", "_destroy"=>"false"}}},}
    #         post :add_report_value, params
    #         is_expected.to set_the_flash[:notice].to('No values added')
    #     end
    # end

    # describe "POST 'import'" do
    #   it 'import the values' do
    #     expect{post :import, report_id: @report.id, file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/ReportValues.csv")}.to change(Value, :count).by(19)
    #   end

    #   it 'redirects to home page' do
    #     post :import, report_id: @report.id, file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/ReportValues.csv")
    #     is_expected.to redirect_to(reports_path)
    #   end
    # end

    # describe 'show_dashboard' do
    #   it 'shows a pivot of all the report values for two periods' do
    #     15.times{
    #       value = FactoryGirl.create(:value, amount: 10, repdate: Date.today, report: @report)
    #     }
    #     get :show_dashboard, id: @report.id, year_1: 2014, year_2: 2013
    #     expect(assigns(:period1_tis)).to eq([["testmiTag", 150.0]])
    #     expect(assigns(:chart1)).to eq([["Rep Date", "testmiTag"], ["2014-09-13", 150.0]])
    #     expect(assigns(:pie_chart_data)).to eq([["MI Tag", "Amount"], ["testmiTag", 150.0]])
    #   end
    # end

    describe 'get_breakdown_values' do
      before do
        xhr :get, :get_breakdown_values, id: @report.id, period: 'current', ifrstag: 'Revenue' , format: 'js'
        expect(@report.title).to eq "New report testing"
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it 'should render js update template' do
        expect(response).to render_template(:get_breakdown_values)
      end
      it 'assings the correct report' do
        controller_report = assigns(:report)
        expect(controller_report).to eq @report
      end
      it 'fetches values for given tag and period' do
        test = Report.find(@report.id)
        expect(assigns(:data)).to eq @report.get_values_for(@report.current_end).where(ifrstag: 'Revenue')
      end
    end
  end
end

def set_user_auth
  ApplicationController.any_instance.stub(:verify_token)
  Report.any_instance.stub(:build_back_end)
  #User.any_instance.stub(:load_welcome_packs)
  @current_user = FactoryGirl.create(:user)
  @report = FactoryGirl.create(:report)
  #@report.readers << @current_user
  controller.session[:token] = '265378652378682786237846'
  controller.session[:uid] = @current_user.uid
  controller.session[:email]= @current_user.email

  controller.stub(:current_user){ @current_user }
  @current_user.reports << @report
  @value = FactoryGirl.create(:tb_value)
  @report.values << @value
end

