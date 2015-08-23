require 'rails_helper'

describe CommentsController do

    describe "testing" do

        before do
          @current_user = FactoryGirl.create(:user)
          @report = FactoryGirl.create(:report)
          @comment = FactoryGirl.create(:comment, report_id: @report.id)
          controller.session[:token] = '265378652378682786237846'
          controller.stub(:current_user){ @current_user }
          @current_user.reports << @report
          @report.comments << @comment
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
              expect(assigns(:comment)).to be_a_new(Comment)
            end
          end
          # END OF DESCRIBE GET NEW
          describe "POST 'create' " do
            context "Global create" do
              it 'should be a success' do
                params = {comment: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id}
                xhr :post, :create, params, format: 'js'
                expect(response).to be_success
              end
              it 'should render index create' do
                params = {comment: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id}
                xhr :post, :create, params, format: 'js'
                expect(response).to render_template(:create)
              end
              it 'can create a report Comment' do
                params = {comment: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id}
                xhr :post, :create, params, format: 'js'
                _last = Comment.last
                expect(_last.id).not_to be_nil
                expect(_last.body).to eq "YOOO"
                expect(_last).to be_an_instance_of Comment
                expect(_last.repdate).to eq(@report.current_end)
              end
            end
          end

          describe "GET 'Edit'" do
            before do
              xhr :get, :edit, id: @comment.id, report_id: @report.id, format: 'js'
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
            it 'assigns correct comment' do
              controller_comment = assigns(:comment)
              expect(controller_comment).to eq @comment
            end
          end

          describe "PUT 'update' " do
            context "Global update" do
              it 'should be a success' do
                params = {comment: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id, id: @comment.id}
                xhr :put, :update, params, format: 'js'
                expect(response).to be_success
              end
              it 'should render index create' do
                params = {comment: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id, id: @comment.id}
                xhr :put, :update, params, format: 'js'
                expect(response).to render_template(:update)
              end
              it 'can create a report Comment' do
                params = {comment: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id, id: @comment.id}
                xhr :put, :update, params, format: 'js'
                _last = Comment.last
                expect(_last.body).to eq "YOOO"
                expect(_last).to be_an_instance_of Comment
              end
            end
          end
          # END OF DESCRIBE POST
          describe "DELETE 'destroy'" do
              before do
                expect(@report.comments.count).to eq 1
                xhr :delete, :destroy, id: @comment.id, report_id: @report.id, format: 'js'
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
              it 'assigns the correct comment' do
                controller_comm = assigns(:comment)
                expect(controller_comm).to eq @comment
              end
              it 'deletes comment' do
                expect(@report.comments.count).to eq 0
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
              expect(assigns(:comments)).to match_array(@report.comments)
            end
          end

        end
        # END OF MAIN ROUTES CONTEXT
    end
end
