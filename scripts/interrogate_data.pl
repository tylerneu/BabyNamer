#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use Data::Dumper;

my $dbh = DBI->connect('DBI:mysql:BabyNamer', 'root', 'password') or die "Couldn't connect to database: " . DBI->errstr;
$dbh->{RaiseError} = 1;

# my $sth = $dbh->prepare('show create procedure get_rands;');
# $sth->execute();
# print Dumper($sth->fetchall_arrayref());

my $sth = $dbh->prepare("CALL get_rands(1, ?, ?)");
$sth->execute('M', 0);

$sth = $dbh->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score, name.recent_total_names FROM name JOIN `score` on name.id = score.name_id WHERE name.id IN (SELECT rand_id FROM rands) GROUP BY score.year;');
$sth->execute();
my $data = $sth->fetchall_hashref(['year']);

print Dumper($data);
