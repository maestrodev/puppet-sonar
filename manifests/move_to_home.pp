# copy folders susceptible to change from installation folder to /var/local/sonar and symlink
define sonar::move_to_home($sonar_home) {
  file { "${sonar_home}/${name}":
      ensure => directory,
  } ->

  file { "${sonar::installdir}/${name}":
      ensure => link,
      target => "${sonar_home}/${name}",
  }
}
