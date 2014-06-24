actions :create, :delete
default_action :create

attribute :script, :kind_of => String, :default => nil
attribute :script_path, :kind_of => String, :default => nil
attribute :timespan_minutes, :kind_of => Integer, :required => true
attribute :duration_days, :kind_of => Integer, :default => 8192