#Rake Task to create spree admin user with email,language and password !
namespace :kirana_admin do
  desc "Create kiran Admin username ,password,Language"
  task :create => :environment do
    require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'users.rb')
    puts "Done! #{Time.now}"
  end
end
