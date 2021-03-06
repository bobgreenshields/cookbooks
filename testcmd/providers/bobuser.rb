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
  Chef::Log.info("user2::create #{new_resource.name} exists #{@smbuser.exists}")
  if @smbuser.exists
    execute "Delete samba user #{new_resource.name}" do
      command "smbpasswd -x #{new_resource.name}"
    end
  end
	pw = new_resource.password
	if pw.length == 0
		execute "Create samba user np #{new_resource.name}" do
			createnpcmd = "smbpasswd -a -n #{new_resource.name} && "
			createnpcmd << "smbpasswd -e -n #{new_resource.name} && "
			createnpcmd << "smbpasswd -n #{new_resource.name}"
			command  createnpcmd
		end
	else
		execute "Create samba user #{new_resource.name}" do
#			command "echo -ne '#{pw}\n#{pw}\n' | smbpasswd -s -a #{new_resource.name}"
			command "printf \"#{pw}\n#{pw}\n\" | smbpasswd -s -a #{new_resource.name}"
		end
	end
	new_resource.updated_by_last_action(true)
#  unless @smbuser.exists
#    pw = new_resource.password
#    execute "Create #{new_resource.name}" do
#      command "(echo -ne '#{pw}\n#{pw}\n' | smbpasswd -s -a #{new_resource.name}"
#    end
#    new_resource.updated_by_last_action(true)
#  end
end

action :enable do
  if @smbuser.disabled
    execute "Enable samba user #{new_resource.name}" do
      command "smbpasswd -e #{new_resource.name}"
    end
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if @smbuser.exists
    execute "Delete samba user #{new_resource.name}" do
      command "smbpasswd -x #{new_resource.name}"
    end
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @smbuser = Chef::Resource::SambaUser.new(new_resource.name)

  Chef::Log.info("Checking for smbuser #{new_resource.name}")
  u = shell_out("pdbedit -Lv -u #{new_resource.name}")
  pdb = u.stdout
  mexists = /username:\s*#{new_resource.name}$/
  mflags = /Flags:\s*\[(.*)\]/
  @smbuser.exists(mexists.match(pdb) ? true : false)
  flags = mflags.match(pdb)
  @smbuser.disabled((flags and flags[1].include?("D")) ? true : false)
#  exists = u.stdout.include?(new_resource.name)
#  disabled = u.stdout.include?("Account Flags.*[D")
#  @smbuser.exists(exists)
#  @smbuser.disabled(disabled)
end
