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
  
  my $sex = params->{sex};
  
  my $rows = database->do("CALL get_rands(1, ?)", undef, $sex);
  
  my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score FROM name JOIN `score` on name.id = score.name_id WHERE name.id IN (SELECT rand_id FROM rands) GROUP BY score.year;');
  $sth->execute();
  my $data = $sth->fetchall_hashref(['year']);
  
  return to_json({
    name  => $data->{(keys %{$data})[0]}{name},
    sex   => $data->{(keys %{$data})[0]}{sex},
    years => $data,
  });
};

true;