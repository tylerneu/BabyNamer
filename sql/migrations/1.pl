#!/usr/bin/perl

use strict;
use warnings;

use DBI;

my $dbh = DBI->connect('DBI:mysql:BabyNamer', 'root', '9ClJ8Wt1') or die "Couldn't connect to database: " . DBI->errstr;
$dbh->{RaiseError} = 1;

while (defined(my $file = glob 'data/SSA\ Baby\ Names\ by\ State/*')) {
  open my $fh, "<", $file;
  while (defined( my $line = <$fh> )) {
    chomp $line;
    insert_name($dbh, $line);
  }
  close $fh;
}

sub insert_name {
  my ($dbh, $line) = @_;
  
  my ($state,$sex,$year,$name,$count) = split ',', $line;
  
  my $select_sth       = $dbh->prepare('SELECT `id` FROM `name` WHERE `name` = ? AND `sex` = ?;');
  my $name_insert_sth  = $dbh->prepare('INSERT INTO `name` (name, sex) VALUES (?,?);');
  my $score_insert_sth = $dbh->prepare_cached('INSERT INTO `score` (name_id, year, state, score) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE year = year;') or die;

  print "$state : $sex : $year : $name\n";

  $select_sth->execute($name, $sex);
  my $name_id  = $select_sth->fetchrow_array;
  
  if (!defined $name_id) {
    $name_insert_sth->execute($name, $sex);
    $select_sth->execute($name, $sex);
    $name_id  = $select_sth->fetchrow_array;    
  }

  $score_insert_sth->execute($name_id, $year, $state, $count);
  
}
