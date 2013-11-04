Puppet-SonarQube
============

A puppet recipe to install SonarQube (former Sonar)


# Usage

    class { 'maven::maven' : } ->
    class { 'sonarqube' :
      version => '3.7.2',
    }

or

    $jdbc = {
      url               => 'jdbc:h2:tcp://localhost:9092/sonar',
      username          => 'sonar',
      password          => 'sonar',
    }

    class { 'maven::maven' : } ->
    class { 'sonarqube' :
      arch         => 'linux-x86-64',
      version      => '3.7.2',
      user         => 'sonar',
      group        => 'sonar',
      service      => 'sonar',
      installroot  => '/usr/local',
      home         => '/var/local/sonar',
      download_url => 'http://dist.sonar.codehaus.org',
      jdbc         => $jdbc,
      log_folder   => '/var/local/sonar/logs',
    }

## Install a SonarQube plugin

    sonar::plugin { 'sonar-twitter-plugin' :
      groupid    => 'org.codehaus.sonar-plugins',
      artifactid => 'sonar-twitter-plugin',
      version    => '0.1',
      notify     => Service['sonar'],
    }

# Module requirements

* maestrodev/wget
* maestrodev/maven
* puppetlabs/stdlib

# License

    Copyright 2011-2013 MaestroDev, Inc

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
