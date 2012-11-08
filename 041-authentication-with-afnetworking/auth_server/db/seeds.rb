# Create 10 accounts, admin, admin2, admin3, etc all with the password 'secret'
if User.count == 0
  User.transaction do
  	10.times do |i|
  		username = "admin"
  		username += (i+1).to_s unless i == 0
  		email = "#{username}@example.com"
  		password = "secret"
  		user = User.create(:username => username, :email => email, :password => password)
  	end
  end
end