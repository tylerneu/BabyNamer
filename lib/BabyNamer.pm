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
  
  database->do("CALL get_rands(5, ?, ?)", undef, $sex, $popular_names);
  
  my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score, name.recent_total_names FROM name JOIN `score` on name.id = score.name_id WHERE name.id IN (SELECT rand_id FROM rands) GROUP BY id, score.year;');
  $sth->execute();
  my $data = $sth->fetchall_hashref(['id', 'year']);
  
  return to_json($data);
};

get '/name/:id' => sub {
  
  my $sth = database->prepare('SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as yearly_score, name.recent_total_names FROM name JOIN `score` on name.id = score.name_id WHERE name.id = ? GROUP BY id, score.year;');
  $sth->execute(params->{id});
  my $data = $sth->fetchall_hashref(['year']);

  $data = {
    name => $data->{(keys %$data)[0]}->{name},
    sex  => $data->{(keys %$data)[0]}->{sex},   
    years => $data,
  };
  
  template 'name.tt', $data, { layout => undef };
  
};

# SEARCH

get '/names' => sub {
  
  my $sth = database->prepare("SELECT name.id, name.name, name.sex FROM name WHERE name LIKE ? ORDER BY name DESC;");
  $sth->execute(params->{query});
  my $data = $sth->fetchall_hashref(['id']);
  
  template 'names.tt', { names => $data }, { layout => undef };
  
};

# POPULAR NAMES BY YEAR

get '/year/:year' => sub {
  
  my $year = params->{year};
  
  my $sth = database->prepare("SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as year_score
                              FROM score
                              JOIN name ON score.name_id = name.id
                              WHERE score.year = ?
                              group by score.name_id, score.year
                              ORDER BY year_score DESC
                              LIMIT 100;");
  $sth->execute($year);
  my $data = $sth->fetchall_hashref(['id']);
  
  my @sorted_data = map { $data->{$_} } sort { $data->{$b}->{year_score} <=> $data->{$a}->{year_score} } keys %$data;
  
  debug Dumper(\@sorted_data);
  
  template 'names.tt', { variable => $year, names => \@sorted_data }, { layout => undef };
  
};

# POPULAR NAMES BY STATE 

get '/state/:state' => sub {
  
  my $state = params->{state};
  
  my $sth = database->prepare("SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as state_score
                              FROM score
                              JOIN name ON score.name_id = name.id
                              WHERE score.state = ?
                              group by score.name_id, score.state
                              ORDER BY state_score DESC
                              LIMIT 100;");
  $sth->execute($state);
  my $data = $sth->fetchall_hashref(['id']);
  
  my @sorted_data = map { $data->{$_} } sort { $data->{$b}->{state_score} <=> $data->{$a}->{state_score} } keys %$data;
  
  template 'names.tt', { variable => $state, names => \@sorted_data }, { layout => undef };
  
};

# POPULAR NAMES BY YEAR & STATE

get '/year/:year/state/:state' => sub {
  
  my $year = params->{year};
  my $state = params->{state};
  
  my $sth = database->prepare("SELECT name.id, name.name, name.sex, score.year, SUM(score.score) as state_score
                              FROM score
                              JOIN name ON score.name_id = name.id
                              WHERE score.year = ? AND score.state = ?
                              group by score.name_id
                              ORDER BY state_score DESC
                              LIMIT 100;");
  $sth->execute($year, $state);
  my $data = $sth->fetchall_hashref(['id']);
  
  my @sorted_data = map { $data->{$_} } sort { $data->{$b}->{state_score} <=> $data->{$a}->{state_score} } keys %$data;
  
  template 'names.tt', { variable => "$year in $state", names => \@sorted_data }, { layout => undef };
  
};

true;