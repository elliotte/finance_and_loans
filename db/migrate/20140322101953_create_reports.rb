class CreateReports < ActiveRecord::Migration
  def change
  	# unless table_exists? :reports
	    create_table :reports do |t|
	      t.string :title
	      t.text :summary

	      t.timestamps
	    end
	# end
  end
end
