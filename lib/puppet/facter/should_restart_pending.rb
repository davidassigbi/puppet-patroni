Facter.add('should_restart_pending') do
  # setcode do
  #   patronictl = '/opt/app/patroni/bin/patronictl'
  #   config     = '/etc/patroni/config.yml'

  #   begin
  #     output = Facter::Core::Execution.execute([patronictl, '-c', config, 'show-config'], on_fail: nil)
  #     data   = YAML.safe_load(output)

  #     # Example condition
  #     data.dig('postgresql', 'parameters', 'max_connections') > 100
  #   rescue
  #     false
  #   end
  # end

  setcode do
    true
  end
end
