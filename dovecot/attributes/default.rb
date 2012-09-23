default["dovecot"]["base_dir"] = "/var/run/dovecot"
default["dovecot"]["protocols"] = { "imap" => 
	{"login_executable" => "/usr/lib/dovecot/imap-login",
		"mail_executable" => "/usr/lib/dovecot/imap"}
}
default["dovecot"]["disable_plaintext_auth"] = "no"
default["dovecot"]["log_timestamp"] = "%Y-%m-%d %H:%M:%S"
default["dovecot"]["ssl_disable"] = "yes"
default["dovecot"]["auth_default"]["mechanism"] = "plain"
default["dovecot"]["auth_default"]["passdb"]["type"] = "passwd-file"
default["dovecot"]["auth_default"]["passdb"]["args"] = "/etc/dovecot/passwd"
default["dovecot"]["auth_default"]["userdb"]["type"] = "passwd-file"
default["dovecot"]["auth_default"]["userdb"]["args"] = "/etc/dovecot/users"
default["dovecot"]["auth_default"]["user"] = "root"
