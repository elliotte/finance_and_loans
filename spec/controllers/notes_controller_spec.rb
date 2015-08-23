require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  describe "testing" do

    before do
      @current_user = FactoryGirl.create(:user)
      @report = FactoryGirl.create(:report, user_id: @current_user.id)
      @note = FactoryGirl.create(:note, report_id: @report.id)
      controller.session[:token] = '265378652378682786237846'
      controller.stub(:current_user){ @current_user }
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
          expect(assigns(:note)).to be_a_new(Note)
        end
      end
      # END OF DESCRIBE GET NEW
      describe "POST 'create' " do
        context "Global create" do
          it 'should be a success' do
            params = {note: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id}
            xhr :post, :create, params, format: 'js'
            expect(response).to be_success
          end
          it 'should render index create' do
            params = {note: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id}
            xhr :post, :create, params, format: 'js'
            expect(response).to render_template(:create)
          end
          it 'can create a report Comment' do
            params = {note: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, report_id: @report.id}
            xhr :post, :create, params, format: 'js'
            _last = Note.last
            expect(_last.id).not_to be_nil
            expect(_last.body).to eq "YOOO"
            expect(_last).to be_an_instance_of Note
            expect(_last.repdate).to eq(@report.current_end)
          end
        end
      end

      describe "GET 'Edit'" do
        before do
          xhr :get, :edit, id: @note.id, report_id: @report.id, format: 'js'
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
          controller_note = assigns(:note)
          expect(controller_note).to eq @note
        end
      end

      describe "PUT 'update' " do
        context "Global update" do
          it 'should be a success' do
            params = {note: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, id: @note.id, report_id: @report.id}
            xhr :put, :create, params, format: 'js'
            expect(response).to be_success
          end
          it 'should render index create' do
            params = {note: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, id: @note.id, report_id: @report.id}
            xhr :put, :create, params, format: 'js'
            expect(response).to render_template(:create)
          end
          it 'can create a report Comment' do
            params = {note: {body: "YOOO", commenter: "mark.e.w.elliott@gmail.com", subject: 'General'}, id: @note.id, report_id: @report.id}
            xhr :put, :create, params, format: 'js'
            _last = Note.last
            expect(_last.body).to eq "YOOO"
            expect(_last).to be_an_instance_of Note
          end
        end
      end
      # END OF DESCRIBE POST
      describe "DELETE 'destroy'" do
        before do
          expect(@report.notes.count).to eq 1
          request.env["HTTP_REFERER"] = "where_i_came_from"
          delete :destroy, id: @note.id, report_id: @report.id, format: 'js'
        end
        it 'assings the correct report' do
          controller_report = assigns(:report)
          expect(controller_report).to eq @report
        end
        it 'assigns the correct comment' do
          controller_comm = assigns(:note)
          expect(controller_comm).to eq @note
        end
        it 'deletes comment' do
          expect(@report.notes.count).to eq 0
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
          expect(assigns(:notes)).to match_array(@report.notes)
        end
      end

    end
        # END OF MAIN ROUTES CONTEXT
  end

end
