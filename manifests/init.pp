# == Class: documentum
#
# Performs initial configuration tasks for all Vagrant boxes.
# http://www.puppetcookbook.com/posts/add-a-unix-group.html
# https://docs.puppetlabs.com/guides/techniques.html#how-can-i-ensure-a-group-exists-before-creating-a-user
# http://theruddyduck.typepad.com/theruddyduck/2013/11/using-puppet-to-configure-users-groups-and-passwords-for-cloudera-manager.html
# http://stackoverflow.com/questions/19024134/calling-puppet-defined-resource-with-multiple-parameters-multiple-times

class documentum {
  file { '/home/dmadmin/.bashrc':
      owner => 'dmadmin',
      group => 'dmadmin',
      mode  => '0644',
      source => 'puppet:///modules/documentum/bashrc.sh';
  }

  include documentum::contentserver::server
  include documentum::contentserver::patch
  include documentum::contentserver::roottask
  include documentum::contentserver::docbroker
  include documentum::contentserver::repository
  include documentum::contentserver::captureconfigs

  File ['/u01/app/documentum/shared']               ->
  Class [ 'documentum::contentserver::server' ]     ->
  Class [ 'documentum::contentserver::patch' ]      ->
  Class [ 'documentum::contentserver::roottask' ]   ->
  Class [ 'documentum::contentserver::docbroker' ]  ->
  Class['oracle::xe::server'] ->
  Class [ 'documentum::contentserver::repository' ] ->
  Class [ 'documentum::contentserver::captureconfigs' ]
}
