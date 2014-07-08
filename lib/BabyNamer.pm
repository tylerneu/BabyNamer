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
  
  my $sex = params->{sex} ? params->{sex} : undef;
  my $popular_names = params->{popular_names} eq 'true' ? 1 : 0;
  
  my $rows = database->do("CALL get_rands(1, ?, ?)", undef, $sex, $popular_names);
  
  my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score, name.recent_total_names FROM name JOIN `score` on name.id = score.name_id WHERE name.id IN (SELECT rand_id FROM rands) GROUP BY score.year;');
  $sth->execute();
  my $data = $sth->fetchall_hashref(['year']);
  
  return to_json({
    name  => $data->{(keys %{$data})[0]}{name},
    sex   => $data->{(keys %{$data})[0]}{sex},
    years => $data,
  });
};

true;