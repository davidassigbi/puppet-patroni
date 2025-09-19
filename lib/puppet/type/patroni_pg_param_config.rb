Puppet::Type.newtype(:patroni_pg_param_config) do
  desc <<-DESC
@summary Manages Patroni postgresql configuration options
@example Set PostgreSQL max connections
  patroni_pg_param_config { 'log_rotation_size':
    value => '23Mb',
  }
DESC

  newparam(:name, namevar: true) do
    desc 'The postgresql configuration option name'
  end

  newproperty(:value) do
    desc 'The value to assign the postgresql parameter'
  end
end
