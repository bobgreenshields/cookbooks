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
#VERSION = "1.6.14"


node[:makemkv][:depends].each do |p|
  apt_package p do
    action :install
  end
end

SRC_DIR = "/tmp/makemkv"

# change this to the /tmp directory
directory SRC_DIR do
  action :create
  mode "0777"
end

mkvfiles = %w(oss bin).inject([]) do |res, ft|
  res << "makemkv-#{ft}-#{node[:makemkv][:version]}"
end

#http://www.makemkv.com/download/makemkv-bin-1.7.6.tar.gz

mkvfiles.each { |f| puts f }

mkvfiles.each do |f|
  archive = "#{f}.tar.gz"
  remote_file "#{SRC_DIR}/#{archive}" do
    source "http://www.makemkv.com/download/#{archive}"
    action :create_if_missing
  end
  execute "tar xzf #{archive}" do
    cwd SRC_DIR
    creates "#{SRC_DIR}/#{f}"
  end
  execute "chmod 777 #{f}" do
    cwd "#{SRC_DIR}"
    user "root"
  end
  execute "make -f makefile.linux" do
    cwd "#{SRC_DIR}/#{f}"
  end
  execute "make -f makefile.linux install" do
    cwd "#{SRC_DIR}/#{f}"
    user "root"
  end
end



#mkvfiles.each do |f|
#  archive = "#{f}.tar.gz"
#  cookbook_file "#{SRC_DIR}/#{archive}" do
#    source archive
#    action :create_if_missing
#  end
#
#  execute "tar xzf #{archive}" do
#    cwd SRC_DIR
#    creates "#{SRC_DIR}/#{f}"
#  end
#end
