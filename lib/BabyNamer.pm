package BabyNamer;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;

our $VERSION = '0.1';

get '/' => sub {
  session 'random_name_count' => 0;
  template 'index', {};
};

ajax '/random_name' => sub {
  my $count = session 'random_name_count';
  session 'random_name_count' => ++$count;
  return to_json(get_random_name_data());
};

ajax '/random_name_count' => sub {  
  return to_json({count => session 'random_name_count'});
};

true;

sub get_random_name_data {
  my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score FROM name JOIN (SELECT CEIL(RAND() * (SELECT MAX(name.id) FROM name)) AS id) AS r2 USING (id) JOIN `score` on name.id = score.name_id GROUP BY score.year;');
    # my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score FROM name JOIN (SELECT CEIL(RAND() * (SELECT MAX(name.id) FROM name)) AS id) AS r2 USING (id) JOIN `score` on name.id = score.name_id WHERE name.sex = "M" GROUP BY score.year;');
  $sth->execute();
  my $name = $sth->fetchall_hashref('year');  
  return $name;
}
