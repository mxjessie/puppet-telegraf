# == Define: telegraf::input
#
# A Puppet wrapper for discrete Telegraf input files
#
# === Parameters
#
# [*plugin_type*]
#   String. What type of input plugin to configure; defaults to the name
#
# [*options*]
#   Hash. Plugin options for use the the input template.
#
# [*single_section*]
#   Hash. Some inputs take a single unique section in [single brackets].
#
# [*sections*]
#   Hash. Some inputs take multiple sections in [[double brackets]].

define telegraf::input (
  String $plugin_type            = $name,
  Optional[Hash] $options        = undef,
  Optional[Hash] $single_section = undef,
  Optional[Hash] $sections       = undef,
) {
  include telegraf

  Class['::telegraf::config']
  -> file {"${telegraf::config_folder}/${name}.conf":
    content => template('telegraf/input.conf.erb')
  }
  ~> Class['::telegraf::service']
}
