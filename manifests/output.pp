# == Define: telegraf::output
#
# A Puppet wrapper for discrete Telegraf output files
#
# === Parameters
#
# [*options*]
#   Hash. Plugin options for use the the output template.
#
# [*sections*]
#   Hash. Some outputs take multiple sections.
#
define telegraf::output (
  String $plugin_type        = $name,
  Optional[Hash] $options    = undef,
  Optional[Hash] $suboptions = undef,
  Optional[Hash] $sections   = undef,
) {
  include telegraf

  Class['::telegraf::config']
  -> file { "${telegraf::config_folder}/output-${name}.conf":
    content => template('telegraf/output.conf.erb'),
  }
  ~> Class['::telegraf::service']
}
