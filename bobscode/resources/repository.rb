actions :add
 
attribute :name, :kind_of => String, :name_attribute => true
attribute :key, :regex => /^[A-F0-9]{8}$/, :default => nil
attribute :keyserver, :kind_of => String, :default => nil
attribute :url, :kind_of => String, :default => nil
