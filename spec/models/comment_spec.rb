require 'rails_helper'

describe Comment do
  	it { should belong_to :report }
  	it { should respond_to :commenter}
  	it { should respond_to :body}

  describe 'instance methods' do

    describe 'set_repdate' do
      it 'sets repdate from report object' do
        report = FactoryGirl.create(:report)
        comment = Comment.new(report_id: report.id)
        comment.set_repdate
        expect(comment.repdate).to eq(report.current_end)
      end
    end

  end

  describe 'class methods' do
    before do
      @report = FactoryGirl.create(:report)
      5.times{FactoryGirl.create(:comment, report_id: @report.id)}
    end
    describe 'export_data' do
      it 'returns data for all records' do
        expect(Comment.export_data(:all, @report)).to eq(@report.comments)
      end

      it 'returns data for current records' do
        expect(Comment.export_data(:current, @report)).to eq(@report.comments.where(repdate: @report.current_end))
      end
    end
  end

end
