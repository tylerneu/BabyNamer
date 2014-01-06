package BabyNamer;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;

our $VERSION = '0.1';

get '/' => sub {
  
  session 'random_name_count' => 0;
  
  template 'index', {
    name => get_random_name(),
  };
  
};

ajax '/random_name' => sub {
  my $count = session 'random_name_count';
  session 'random_name_count' => ++$count;
  return to_json(get_random_name());
};

ajax '/random_name_count' => sub {  
  return to_json({count => session 'random_name_count'});
};

true;

sub get_random_name {
  my $sth = database->prepare('SELECT * FROM name JOIN (SELECT CEIL(RAND() * (SELECT MAX(id) FROM name)) AS id) AS r2 USING (id);');
  $sth->execute();
  return $sth->fetchrow_hashref;
}