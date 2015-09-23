["Admin", "Owner", "Guest"].each do |role|
  Role.find_or_create_by(name: role) 
end
