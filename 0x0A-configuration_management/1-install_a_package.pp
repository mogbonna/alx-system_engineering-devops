# Install a version of flask (2.1.0)
package { 'flask':
  ensure   => '2.1.0',
  provider => 'pip',
  require  => Package['python3-pip']
}

package { 'python3-pip':
  ensure   => present,
  provider => 'pip3'
}

