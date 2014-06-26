action :create do
  if new_resource.script.nil? && !new_resource.script_path.nil? then
    job = "-FilePath #{new_resource.script_path}"
  elsif !new_resource.script.nil? && new_resource.script_path.nil? then
    job = "-ScriptBlock #{new_resource.script}"
  else
    raise Chef::Exceptions::ValidationFailed, "Use only one of either script or script_path."
  end
  powershell_script "Create job [#{new_resource.name}]" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      powershell.exe  -NoLogo -NonInteractive -NoProfile -ExecutionPolicy RemoteSigned -InputFormat None -File "C:\\opt\\chef\\windows_scheduler_job_#{new_resource.name}.ps1"
    EOH
    action :nothing
  end
  template "C:\\opt\\chef\\windows_scheduler_job_#{new_resource.name}.ps1" do
    source "job.ps1.erb"
    mode "0644"
    variables({
     :span_minutes => new_resource.span_minutes,
     :duration_days => new_resource.duration_days,
     :multiple_policy => node[:powershell_cloudwatch][:region],
     :name => new_resource.name,
     :job => job
    })
    action :create
    cookbook 'windows_scheduler'
    notifies :run, "powershell_script[Create job [#{new_resource.name}]]"
  end
end
action :delete do
  powershell_script "Delete job [#{new_resource.name}]" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      $jobs = Get-ScheduledJob
      if ($jobs.Count -gt 0) {
        for ($i=0; $i -lt $jobs.Count; $i++) {
          if ($jobs[$i].Name -eq "#{new_resource.name}") {
            Unregister-ScheduledJob -Name #{new_resource.name}
          }
        }
      }
    EOH
  end
end