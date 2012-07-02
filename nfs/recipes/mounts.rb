unless node["nfs"]["mounts"].empty?
  mounts = node["nfs"]["mounts"] 
  mounts.each do |mount_point, v| do
    directory mount_point do
    	owner v["owner"]
    	group v["group"]
    	mode v["mode"]
      recursive true
    end
    mount mount_point do
      device v["device"]
      fstype "nfs"
      options v["options"]
    end
  end
end
