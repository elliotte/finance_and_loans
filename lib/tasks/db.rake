namespace :db do
 
  task :drop => [:environment, :drop, :create, :migrate] do
  end
 
end