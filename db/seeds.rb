# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

badline_list = Badline.list_all

badline_list.each do |badline|
	Badline.create(:title => badline[0], :ifrstag => badline[1])
end

monea_company = Company.create(name: "MoneaReport", 
	email: "info@monea.build", 
	company_number: "0001")

app_admin = User.create(uid: 123456, 
	password: 'secret123', 
	password_confirmation: 'secret123',
	user_admin: true,
	team_admin: true,
	admin: true,
	email: "admin@appadmin.com")

monea_team  = Team.create(title: "MoneaReportTeam", 
	admin_id: app_admin.id, 
	company_id: monea_company.id )

