gem_package "ruby-shadow" do
	action :install
end

users = node[:users]

users.each do |u|

	home_dir = "/home/#{u['id']}"

	user u['id'] do
		uid u['uid']
		gid "users"
		shell u['shell']
		comment u['comment']
		password u['password']
		if (u['home_dir'].upcase == "TRUE") then
			supports :manage_home => true
			home home_dir
		end
	end
end
