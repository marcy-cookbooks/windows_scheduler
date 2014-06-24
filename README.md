windows_scheduler Cookbook
==========================
Set Windows Task Scheduler use PowerShell.

Requirements
------------
* Chef 11 or higher
* Windows 2008 R2 or later
* PowerShell 3.0 or higher

Usage
-----

##### 1. Just include `windows_scheduler` in your node's `Berksfile`:
```ruby
cookbook 'windows_scheduler', git: 'https://github.com/marcy-cookbooks/windows_scheduler.git'
```

##### 2. Just include `windows_scheduler` in your cookbook's `metadata.rb`:
```ruby
depends 'windows_scheduler'
```

##### 3. Create recipe that use `windows_scheduler_job` resource like this:
```ruby
  windows_scheduler_job "example job" do
    path "C:¥path¥to¥job.ps1"
    timespam_minutes 5
    action :create
  end
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
* License: Apache 2.0
* Author: Masashi Terui

