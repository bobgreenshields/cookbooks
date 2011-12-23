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
VERSION = "1.6.14"

depends = %w(build-essential libc6-dev libssl-dev libgl1-mesa-dev libqt4-dev)

depends.each do |p|
  apt_package p do
    action :install
  end
end

SRC_DIR = "/tmp/makemkv"

# change this to the /tmp directory
directory SRC_DIR do
  action :create
end

mkvfiles = %w(oss bin).inject([]) do |res, ft|
  res << "makemkv_v#{VERSION}_#{ft}"
end

mkvfiles.each do |f|
  archive = "#{f}.tar.gz"
  cookbook_file "#{SRC_DIR}/#{archive}" do
    source archive
    action :create_if_missing
  end

  execute "tar xzf #{archive}" do
    cwd SRC_DIR
    creates "#{SRC_DIR}/#{f}"
  end
end