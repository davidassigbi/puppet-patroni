# @summary Manage a postgresql.conf entry.
#
# @param ensure Removes an entry if set to 'absent'.
# @param key Defines the key/name for the setting. Defaults to $name
# @param value Defines the value for the setting.
# @param path Path for postgresql.conf
# @param comment Defines the comment for the setting. The # is added by default.
# @param instance_name The name of the instance.
#
define patroni::pg_dcs_config_entry (
  String[1]                                               $key     = $title,
  Optional[Variant[String[1], Numeric, Array[String[1]]]] $value   = undef,
) {
  # Those are the variables that are marked as "(change requires restart)"
  # on postgresql.conf.  Items are ordered as on postgresql.conf.
  #
  # XXX: This resource supports setting other variables without knowing
  # their names.  Do not add them here.
  $requires_restart_until = {
    'data_directory'                      => undef,
    'hba_file'                            => undef,
    'ident_file'                          => undef,
    'external_pid_file'                   => undef,
    'listen_addresses'                    => undef,
    'port'                                => undef,
    'max_connections'                     => undef,
    'superuser_reserved_connections'      => undef,
    'unix_socket_directory'               => '9.3',   # Turned into "unix_socket_directories"
    'unix_socket_directories'             => undef,
    'unix_socket_group'                   => undef,
    'unix_socket_permissions'             => undef,
    'bonjour'                             => undef,
    'bonjour_name'                        => undef,
    'ssl'                                 => '10',
    'ssl_ciphers'                         => '10',
    'ssl_prefer_server_ciphers'           => '10',    # New on 9.4
    'ssl_ecdh_curve'                      => '10',    # New on 9.4
    'ssl_cert_file'                       => '10',    # New on 9.2
    'ssl_key_file'                        => '10',    # New on 9.2
    'ssl_ca_file'                         => '10',    # New on 9.2
    'ssl_crl_file'                        => '10',    # New on 9.2
    'shared_buffers'                      => undef,
    'huge_pages'                          => undef,   # New on 9.4
    'max_prepared_transactions'           => undef,
    'max_files_per_process'               => undef,
    'shared_preload_libraries'            => undef,
    'max_worker_processes'                => undef,   # New on 9.4
    'old_snapshot_threshold'              => undef,   # New on 9.6
    'wal_level'                           => undef,
    'wal_log_hints'                       => undef,   # New on 9.4
    'wal_buffers'                         => undef,
    'archive_mode'                        => undef,
    'max_wal_senders'                     => undef,
    'max_replication_slots'               => undef,   # New on 9.4
    'track_commit_timestamp'              => undef,   # New on 9.5
    'hot_standby'                         => undef,
    'logging_collector'                   => undef,
    'cluster_name'                        => undef,   # New on 9.5
    'silent_mode'                         => '9.2',   # Removed
    'track_activity_query_size'           => undef,
    'autovacuum_max_workers'              => undef,
    'autovacuum_freeze_max_age'           => undef,
    'autovacuum_multixact_freeze_max_age' => undef,   # New on 9.5
    'max_locks_per_transaction'           => undef,
    'max_pred_locks_per_transaction'      => undef,
  }

  # dcs_only_pg_params = [max_connections, max_locks_per_transaction, max_worker_processes, max_prepared_transactions, wal_level, track_commit_timestamp, max_wal_senders, max_replication_slots, wal_keep_segments, wal_keep_size]

  # patroni_only_params = [listen_addresses, port, cluster_name, hot_standby]

  # dcs_shared_memory_params = [max_connections, max_prepared_transactions, max_locks_per_transaction, max_wal_senders, max_worker_processes]

  if $key in $requires_restart_until and $patroni::config_change_allow_restart {
    Patroni_dcs_config {
      notify => Exec['patroni_restart'],
      before => Exec['patroni_restart'],
    }
  }

  patroni_dcs_config { "postgresql.parameters.${key}":
    value   => $value,
    require => Service['patroni'],
  }
}
