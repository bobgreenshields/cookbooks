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

def set_password(user, pw)
	Chef::Log::info("set_pw: user #{user} pw #{pw}")
end

action :create do
	Chef::Log::info("create: smbuser.exists is #{@smbuser.exists}")
	Chef::Log::info("create: smbuser.disabled is #{@smbuser.disabled}")
	Chef::Log::info("create: smbuser.nopassword is #{@smbuser.nopassword}")
#	Chef::Log::info("create: smbuser.overwrite is #{@smbuser.overwrite}")
  Chef::Log.info("create: new_resource.overwrite is #{new_resource.overwrite}")
  unless @smbuser.exists and not new_resource.overwrite
  	set_password(new_resource.name, new_resource.password)
#    pw = new_resource.password
#    execute "Create #{new_resource.name}" do
#      command "(echo -ne '#{pw}\n#{pw}\n' | smbpasswd -s -a #{new_resource.name}"
#    end
    new_resource.updated_by_last_action(true)
  end
end

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

  Chef::Log.info("lcr: new_resource.overwrite is #{new_resource.overwrite}")

  Chef::Log.debug("Checking for smbuser #{new_resource.name}")
#  u = shell_out("pdbedit -Lv -u #{new_resource.name}")
  u = shell_out("pdbedit -Lw -u #{new_resource.name}")
#  Chef::Log.info("pdbedit yields #{u.inspect}")
#  info = [0, 1, 2, 3, "hello"]
  info = u.stdout.split(':')
  Chef::Log.info("info[0] is #{info[0]}")
  Chef::Log.info("info[1] is #{info[1]}")
  Chef::Log.info("info[2] is #{info[2]}")
  Chef::Log.info("info[3] is #{info[3]}")
  Chef::Log.info("info[4] is #{info[4]}")
#  exists = u.stdout.include?(new_resource.name)
  exists = info[0] == new_resource.name
#  disabled = u.stdout.include?("Account Flags.*[D")
  disabled = info[4].include?("Account Flags.*[D")
  r_nopassword = /^NO PASSWORD/
  nopassword = info[2] =~ r_nopassword || info[3] =~ r_nopassword
  @smbuser.exists(exists)
  @smbuser.disabled(disabled)
  @smbuser.nopassword(nopassword ? true : false)
#  @smbuser.overwrite(new_resource.overwrite)
end
