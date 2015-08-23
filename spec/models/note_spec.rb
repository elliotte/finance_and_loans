require 'rails_helper'

describe Note do
    before do 
      Report.any_instance.stub(:build_back_end)
    end

   context "assocations and attr" do 
    it { should belong_to :report }
    it { should respond_to :commenter }
    it { should respond_to :body }
    it { should respond_to :type }
    it { should respond_to :subject }
    it { should respond_to :filelink }
  end

  let(:report) do
  	FactoryGirl.create(:report)
  end
	let(:recNote) do
    report = FactoryGirl.create(:report)
		FactoryGirl.create(:recNote, report_id: report.id)
	end
	let(:subNote) do
    report = FactoryGirl.create(:report)
		FactoryGirl.create(:subNote, report_id: report.id)
	end

  context "scopes" do
    it 'should be able to filter by scope' do
      report.notes << recNote
      expect(report.notes.reconciliation.count).to eq 1
    end
    it 'should be able to filter by scope' do
      report.notes << subNote
      expect(report.notes.substantiation.count).to eq 1
    end
    it 'should be able to filter with more than one type of notes' do
      report.notes << recNote
      report.notes << subNote
      expect(report.notes.count).to eq 2
      expect(report.notes.reconciliation.count).to eq 1
      expect(report.notes.substantiation.count).to eq 1
    end
  end

  context 'instance methods' do
    describe 'set_repdate' do
      it 'sets repdate from report object' do
        report = FactoryGirl.create(:report)
        note = Note.new(report_id: report.id)
        note.set_repdate
        expect(note.repdate).to eq(report.current_end)
      end
      it 'can copy file using google' do
         # report = FactoryGirl.create(:report)
         # report.update(drive_folder: "https://drive.google.com/drive/folders/0B_6-7ExYPpj6bFlkc3NxcEs2eVU")
         # report.save
         # note = Note.new(report_id: report.id)
         # note.update(filelink: "https://docs.google.com/spreadsheets/d/1nKo7B9mUSGdJxp3GyUAZzb19LWIryrMnIMKfUdfDL-s/edit#gid=1491076686")
         # note.save
         # service = double { GoogleService.new } 
         # GoogleService.any_instance.should_receive(:copy_file)
         # note.copy_file_if_google_link service
      end
    end
  end

  context 'class methods' do
    before do
      @report = FactoryGirl.create(:report)
      5.times{FactoryGirl.create(:note, report_id: @report.id)}
    end
    describe 'export_data' do
      it 'returns data for all records' do
        expect(Note.export_data(:all, @report)).to eq(@report.notes)
      end
      it 'returns data for current records' do
        expect(Note.export_data(:current, @report)).to eq(@report.notes.where(repdate: @report.current_end))
      end
    end

  end


end

