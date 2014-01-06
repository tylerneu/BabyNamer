package BabyNamer;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;

our $VERSION = '0.1';

get '/' => sub {

  template 'index', {
    name => get_random_name() ,
  };
};

ajax '/random_name' => sub {  
  return to_json(get_random_name());
};

true;

sub get_random_name {
  my $sth = database->prepare('SELECT * FROM name JOIN (SELECT CEIL(RAND() * (SELECT MAX(id) FROM name)) AS id) AS r2 USING (id);');
  $sth->execute();
  return $sth->fetchrow_hashref;
}