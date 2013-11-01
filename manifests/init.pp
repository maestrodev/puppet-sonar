# Copyright 2011 MaestroDev
# Copyright 2013 Karl M. Davis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class sonar
  (
    $port =             9000,
    $context_path =     '/',
    $ldap =             {},
    $jdbc = {
      url               => 'jdbc:derby://localhost:1527/sonar;create=true',
      driver_class_name => 'org.apache.derby.jdbc.ClientDriver',
      validation_query  => 'values(1)',
      username          => 'sonar',
      password          => 'sonar',
    },
  )
{
  # Set resource defaults.
  $user = 'sonar'
  $group = 'sonar'
  File {
    owner => $user,
    group => $group,
  }

  # Install the Sonar repository
  # Reference: http://sonar-pkg.sourceforge.net/
  case $::osfamily {
    'debian': {
      include apt
      apt::source { 'sonar':
        location   => 'http://downloads.sourceforge.net/project/sonar-pkg/deb',
        repos      => 'binary',
      }
    }
    default: {
      fail("The ${module_name} module does not yet support ${::osfamily} operating systems.")
    }
  }

  # Install the Sonar package
  package { 'sonar':
    ensure  => present,
    require => Apt::Source['sonar'],
  }

  # The sonar package will install this service.
  service { 'sonar':
    ensure     => running,
    hasrestart => true,
    require    => Package['sonar'],
  }

  # Sonar properties file.
  file { '/opt/sonar/conf/sonar.properties':
    content => template('sonar/sonar.properties'),
    require => Package['sonar'],
    notify  => Service['sonar'],
  }

  # For convenience, provide "built-in" support for the Sonar LDAP plugin.
  sonar::plugin { 'sonar-ldap-plugin' :
    ensure     => empty($ldap) ? {true => absent, false => present},
    artifactid => 'sonar-ldap-plugin',
    version    => '1.3',
    require    => File['/opt/sonar/conf/sonar.properties'],
    notify     => Service['sonar'],
  }
}
