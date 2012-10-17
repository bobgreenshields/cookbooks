default["postfix"]["networks_base"] = ["127.0.0.0/8", "[::ffff:127.0.0.0]/104", "[::1]/128"]
#mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.16.0.0/12
default["postfix"]["mail_folders"] = %w{cur new tmp .Drafts .Sent .Trash .Templates}
