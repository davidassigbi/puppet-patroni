require 'net/http'
require 'uri'
require 'json'

Puppet::Functions.create_function(:'should_restart_pending') do
  dispatch :should_restart_pending do
    param 'String', :patronictl
    param 'String', :config_path
    param 'String', :hostname
  end
  
  def fetch_url(url)
    response = Net::HTTP.get_response(URI(url))
    raise Puppet::Error, "Failed to fetch #{url}: #{response.code}" unless response.is_a?(Net::HTTPSuccess)
  
    JSON.parse(response.body)
  end

  def should_restart_pending(patronictl, config_path, hostname)
    # Run local command
    # Parse YAML output
    # output = Puppet::Util::Execution.execute([patronictl, '-c', $config_path, 'show-config'], failonfail: false)
    # data = JSON.parse(output)

    cluster_config = fetch_url('http://localhost:8008/cluster')
    host_config = cluster_config['members'].find { |conf| conf['name'] == hostname }
    leader_config = cluster_config['members'].find { |conf| conf['role'] == 'leader' }
    is_replica = ! host_config['role'] == 'leader'
    pending_restart = host_config['pending_restart'] == true
    
    puts "cluster_config", cluster_config
    puts "host_config", host_config
    puts "leader_config", leader_config
    puts "is_replica = #{is_replica}"
    puts "pending_restart = #{pending_restart}"


    return (pending_restart and false)
  end
end