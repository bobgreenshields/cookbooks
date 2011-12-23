version = node[:vim][:version]
comp_opts = node[:vim][:compile_opts].join(' ')

Chef::Log.info("Compiling vim version #{version}")
Chef::Log.info("Compile options are #{comp_opts}")

scripts = %w(libperl-dev python-dev)
if node[:vim][:rubycompiled]
  Chef::Log.info("Ruby headers already present")
else
  Chef::Log.info("Adding Ruby headers to dependancies")
  scripts << "ruby-dev"
end

depends = %w(libncurses5-dev libgnome2-dev libgnomeui-dev  libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev)

(depends + scripts).each do |d|
  package d
end

# setup a directory for the source
src_dir = "/tmp/src/vim"

(["/tmp/src"] << src_dir).each do |d|
  directory d do
    action :create
  end
end

archive = "vim-#{version}.tar.bz2"

cookbook_file "#{src_dir}/#{archive}" do
  source archive
  mode "0666"
end

archive_dir = "#{src_dir}/vim#{version.gsub('.', '')}"

execute "extract vim archive" do
  command "tar xjf #{archive}"
  cwd src_dir
  creates archive_dir
  user "root"
end

vim_src = "#{archive_dir}/src"
log = "#{src_dir}/make.log"

# find way to not recompile if correct version and compiled by chef

cmds = []
cmds << "./configure #{comp_opts} 2>&1 | tee #{log}"
cmds << "make 2>&1 | tee -a #{log}"
cmds << "make install 2>&1 | tee -a #{log}"

cmds.each do |cmd|
  execute cmd do
    cwd vim_src
    user "root"
  end
end

# add the icon
cookbook_file "/usr/share/pixmaps/gvim.png" do
  source "gvim.png"
  owner "root"
  group "root"
  mode "0644"
end

# and the desktop file
cookbook_file "/usr/share/applications/gvim.desktop" do
  source "gvim.desktop"
  owner "root"
  group "root"
  mode "0644"
end
