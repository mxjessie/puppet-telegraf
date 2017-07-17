# == Class: telegraf
#
# A Puppet module for installing InfluxData's Telegraf
#
# === Parameters
#
# [*package_name*]
#   String. Package name.
#
# [*ensure*]
#   String. State of the telegraf package. You can also specify a
#   particular version to install.
#
# [*config_file*]
#   String. Path to the configuration file.
#
# [*logfile*]
#   String. Path to the log file.
#
# [*config_file_owner*]
#   String. User to own the telegraf config file.
#
# [*config_file_group*]
#   String. Group to own the telegraf config file.
#
# [*config_folder*]
#   String. Path of additional telegraf config files.
#
# [*hostname*]
#   String. Override default hostname used to identify this agent.
#
# [*omit_hostname*]
#   Boolean. Do not set the "host" tag in the telegraf agent.
#
# [*interval*]
#   String. Default data collection interval for all inputs.
#
# [*round_interval*]
#   Boolean. Rounds collection interval to 'interval'
#
# [*metric_batch_size*]
#   Integer. Telegraf will limit each output batch to this size.
#
# [*metric_buffer_limit*]
#   Integer. Cache metric_buffer_limit metrics for each output, and flush this
#   buffer on a successful write.
#
# [*flush_buffer_when_full*]
#   Boolean. Flush buffer whenever full, regardless of flush_interval
#
# [*collection_jitter*]
#   String.  Sleep for a random time within jitter before collecting.
#
# [*flush_interval*]
#   String. Default flushing interval for all outputs.
#
# [*flush_jitter*]
#   String.  Jitter the flush interval by an amount.
#
# [*debug*]
#   Boolean. Run telegraf in debug mode.
#
# [*quiet*]
#   Boolean.  Run telegraf in quiet mode.
#
# [*outputs*]
#   Hash. Specify output plugins and their options.
#
# [*inputs*]
#   Hash.  Specify input plugins and their options.
#
# [*global_tags*]
#   Hash.  Global tags as a key-value pair.
#
# [*manage_service*]
#   Boolean.  Whether to manage the telegraf service or not.
#
# [*manage_repo*]
#   Boolean.  Whether or not to manage InfluxData's repo.
#
# [*install_options*]
#   String or Array. Additional options to pass when installing package
#
# [*purge_config_fragments*]
#   Boolean. Whether unmanaged configuration fragments should be removed.
#
# [*repo_type*]
#   String.  Which repo (stable, unstable, nightly) to use
#
# [*windows_package_url*]
#   String.  URL for windows telegraf chocolatey repo
#
class telegraf (
  String $package_name                    = $telegraf::params::package_name,
  String $ensure                          = $telegraf::params::ensure,
  String $config_file                     = $telegraf::params::config_file,
  String $config_file_owner               = $telegraf::params::config_file_owner,
  String $config_file_group               = $telegraf::params::config_file_group,
  String $config_folder                   = $telegraf::params::config_folder,
  String $hostname                        = $telegraf::params::hostname,
  Boolean $omit_hostname                  = $telegraf::params::omit_hostname,
  String $interval                        = $telegraf::params::interval,
  Boolean $round_interval                 = $telegraf::params::round_interval,
  String $metric_batch_size               = $telegraf::params::metric_batch_size,
  String $metric_buffer_limit             = $telegraf::params::metric_buffer_limit,
  Boolean $flush_buffer_when_full         = $telegraf::params::flush_buffer_when_full,
  String $collection_jitter               = $telegraf::params::collection_jitter,
  String $flush_interval                  = $telegraf::params::flush_interval,
  String $flush_jitter                    = $telegraf::params::flush_jitter,
  String $logfile                         = $telegraf::params::logfile,
  Boolean $debug                          = $telegraf::params::debug,
  Boolean $quiet                          = $telegraf::params::quiet,
  Hash $inputs                            = $telegraf::params::inputs,
  Hash $outputs                           = $telegraf::params::outputs,
  Hash $global_tags                       = $telegraf::params::global_tags,
  Boolean $manage_service                 = $telegraf::params::manage_service,
  Boolean $manage_repo                    = $telegraf::params::manage_repo,
  Boolean $purge_config_fragments         = $telegraf::params::purge_config_fragments,
  String $repo_type                       = $telegraf::params::repo_type,
  String $windows_package_url             = $telegraf::params::windows_package_url,
  Boolean $service_enable                 = $telegraf::params::service_enable,
  String $service_ensure                  = $telegraf::params::service_ensure,
  Variant[String, Array] $install_options = $telegraf::params::install_options,
) inherits ::telegraf::params
{

  $service_hasstatus = $telegraf::params::service_hasstatus
  $service_restart   = $telegraf::params::service_restart

  # currently the only way how to obtain merged hashes
  # from multiple files (`:merge_behavior: deeper` needs to be
  # set in your `hiera.yaml`)
  $_outputs = hiera_hash('telegraf::outputs', $outputs)
  $_inputs = hiera_hash('telegraf::inputs', $inputs)

  contain ::telegraf::install
  contain ::telegraf::config
  contain ::telegraf::service

  Class['::telegraf::install']
  -> Class['::telegraf::config']
  -> Class['::telegraf::service']
}
