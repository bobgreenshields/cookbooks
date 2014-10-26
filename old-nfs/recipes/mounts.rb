unless node["nfs"]["mounts"].empty?
  mounts = node["nfs"]["mounts"] 

  mounts.each do |mount_point, v|
    directory mount_point do
    	owner v["owner"]
    	group v["group"]
    	mode v["mode"]
      recursive true
    end # directory

    mount mount_point do
      device v["device"]
      fstype "nfs"
      if v.has_key? "action"
        action Array(v["action"]).inject([]) { |res, str| res << str.to_sym }
      end
      options v["options"] if v.has_key? "options"
    end # mount

		if v.has_key? "links"
			Array(v["links"]).each do |link_name|
				link link_name do
					to mount_point
				end
			end
		end

  end # mounts.each
end # unless
