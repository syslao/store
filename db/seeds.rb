["Admin", "Owner", "Guest"].each do |role|
  Role.find_or_create_by(name: role) 
end

sender = User.new(first_name: 'system', email: 'system@localhost.ru').save(validate: false)