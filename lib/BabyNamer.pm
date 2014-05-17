package BabyNamer;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
  session 'random_name_count' => 0;
  template 'index', {};
};

ajax '/random_name' => sub {
  my $count = session 'random_name_count';
  session 'random_name_count' => ++$count;
  
  my $data = get_random_name_data();
  
  session 'current_name' => $data->{(keys %$data)[0]}{name};
  return to_json($data);
};

ajax '/random_name_count' => sub {  
  return to_json({count => session 'random_name_count'});
};

ajax '/save_name' => sub {
  my $current_name = session 'current_name';
  my $saved_names = session 'saved_names';
  push @$saved_names, $current_name;
  session 'saved_names' => $saved_names;
  return to_json({ current_name => $current_name });
};

ajax '/saved_names' => sub {
  my $saved_names = session 'saved_names';
  return to_json({ saved_names => $saved_names ? $saved_names : [] });
};

true;

sub get_random_name_data {

  my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score FROM name JOIN (SELECT CEIL(RAND() * (SELECT MAX(name.id) FROM name)) AS id) AS r2 USING (id) JOIN `score` on name.id = score.name_id GROUP BY score.year;');
  $sth->execute();
  my $name = $sth->fetchall_hashref('year');  
  return $name;  
}
