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
      $trigger = New-JobTrigger -Once -RepetitionInterval (New-TimeSpan -Minutes #{new_resource.span_minutes}) -RepetitionDuration (New-TimeSpan -Days #{new_resource.duration_days}) -At (Get-Date)
      $jobs = Get-ScheduledJob
      $exist = 0
      if ($jobs.Count -gt 0) {
        for ($i=0; $i -lt $jobs.Count; $i++) {
          if ($jobs[$i].Name -eq "#{new_resource.name}") {
            Get-ScheduledJob -Name #{new_resource.name} | Set-ScheduledJob #{job} -Trigger $trigger -MultipleInstancePolicy #{new_resource.multiple_policy}
            $exist = 1
          }
        }
      }
      if ($exist -eq 0) {
        Register-ScheduledJob -Name #{new_resource.name} #{job} -Trigger $trigger -MultipleInstancePolicy #{new_resource.multiple_policy}
      }
    EOH
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