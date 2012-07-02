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
      options v["options"]
    end # mount
  end # mounts.each
end # unless
