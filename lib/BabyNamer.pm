package BabyNamer;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
  template 'index', {};
};

ajax '/random_name' => sub {
  
  my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score FROM name JOIN (SELECT CEIL(RAND() * (SELECT MAX(name.id) FROM name)) AS id) AS r2 USING (id) JOIN `score` on name.id = score.name_id GROUP BY score.year;');
  $sth->execute();
  
  my $data = { years => $sth->fetchall_hashref('year') };  
  
  $data->{current_name} = $data->{years}{(keys %{$data->{years}})[0]}{name};
  return to_json($data);
};

true;