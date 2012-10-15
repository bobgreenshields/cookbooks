#
# Cookbook Name:: hosts
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


package "getmail4" do
	action :install
end


template "/etc/dovecot/dovecot.conf" do
	source "rc.erb"
	mode "0644"
	owner "vmail"
	group "vmail"
	variables ({
		:type => node[:getmail][:type],
		:server => node[:getmail][:server],
		:username => node[:getmail][:username],
		:password => node[:getmail][:password],
		:mail_path => node[:getmail][:mail_path],
		:verbose_level => node[:getmail][:verbose_level],
		:read_all => node[:getmail][:read_all],
		:delete_after => node[:getmail][:delete_after],
		:message_log => node[:getmail][:message_log]
	})
end
