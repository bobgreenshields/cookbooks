#
# Cookbook Name:: samba
# Provider:: user
#
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :create do
	pw = new_resource.password
  Chef::Log.info("new_resource.overwrite is #{new_resource.overwrite}")
#	overwite = new_resource.overwrite
  unless @smbuser.exists
    if pw == ""
			execute "Create #{new_resource.name} and set no password" do
				command "smbpasswd -s -n -a #{new_resource.name}"
			end
		else
			execute "Create #{new_resource.name} and set password" do
				command "echo -ne '#{pw}\n#{pw}\n' | smbpasswd -s -a #{new_resource.name}"
			end
		end
		new_resource.updated_by_last_action(true)
  else # @smbuser.exists
  Chef::Log.info("pwdunset is #{@smbuser.pwdunset}")
  Chef::Log.info("overwrite is #{new_resource.overwrite}")
  	if @smbuser.pwdunset or new_resource.overwrite
  		if pw == ""
  			unless @smbuser.nopwd
					execute "Change password for #{new_resource.name} to no password" do
						command "smbpasswd -s -n #{new_resource.name}"
					end
					new_resource.updated_by_last_action(true)
  			end
  		else # if pw = ""
				execute "Change password for #{new_resource.name}" do
#					command "echo -ne '#{pw}\n#{pw}\n' | smbpasswd -s #{new_resource.name}"
					command "echo -e '#{pw}\n#{pw}\n' | sudo smbpasswd -s -a #{new_resource.name}"
				end
				new_resource.updated_by_last_action(true)
  		end # if pw = ""
  	end # if @smbuser.pwdunset or overwrite
  end # unless @smbuser.exists
end # action :create

action :enable do
  if @smbuser.disabled
    execute "Enable #{new_resource.name}" do
      command "smbpasswd -e #{new_resource.name}"
    end
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if @smbuser.exists
    execute "Delete #{new_resource.name}" do
      command "smbpasswd -x #{new_resource.name}"
    end
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
#  @smbuser = Chef::Resource::SambaUser.new(new_resource.name)
  @smbuser = Chef::Resource::BobscodeSmbuser.new(new_resource.name)

  Chef::Log.debug("Checking for smbuser #{new_resource.name}")
#  u = shell_out("pdbedit -Lv -u #{new_resource.name}")
#  exists = u.stdout.include?(new_resource.name)
#  disabled = u.stdout.include?("Account Flags.*[D")
  u = shell_out("pdbedit -L -w -u #{new_resource.name}")
  info = u.stdout.split ':'
	exists = info[0] == new_resource.name
	r_pwdunset = /^X{32}$/
	r_nopwd = /^NO PASSWORD(\d|[A-F]|X){21}$/
	if exists then
		disabled = info[4].include?("D")
		pwdunset = (info[2] =~ r_pwdunset) and (info[3] =~ r_pwdunset)
		nopwd = (info[2] =~ r_nopwd) or (info[3] =~ r_nopwd)
	end
  @smbuser.exists(exists)
  @smbuser.disabled(disabled)
  @smbuser.pwdunset(pwdunset)
  @smbuser.nopwd(nopwd)
end
