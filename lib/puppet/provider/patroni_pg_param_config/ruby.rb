require 'yaml'

Puppet::Type.type(:patroni_pg_param_config).provide(:ruby) do
  desc 'Read-only provider for Patroni PostgreSQL parameters'

  CONFIG_FILE = '/etc/patroni/config.yml'

  def self.config
    @config ||= YAML.load_file(CONFIG_FILE)
  end

  def self.instances
    params = config.dig('postgresql', 'parameters') || {}
    params.map do |k, v|
      new(name: k, value: v, ensure: :present)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def value
    self.class.config.dig('postgresql', 'parameters', resource[:name])
  end

  def value=(_value)
  end
end
