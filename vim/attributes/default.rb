default[:vim][:version] = "7.3"
default[:vim][:rubycompiled] = true

default[:vim][:compile_opts] = %w(--enable-gui=gnome2 --enable-perlinterp
--enable-pythoninterp --enable-rubyinterp --enable-cscope --enable-multibyte
--enable-fontset --with-features=huge --with-compiledby=chef)
