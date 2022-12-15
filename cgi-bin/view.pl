#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $title = $q->param("title");
print $q->header("text/html","UTF-8");

my $user = "alumno";
my $password = "pweb1";
my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";

my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $stm = "SELECT Text FROM Articles WHERE Title=?";
my $text = consulta($stm,$title);
$dbh->disconnect;


my @types = (
  {
    regex => '^\s{0,3}# (.*$)',
    tag => 'h1'
  },
  {
    regex => '^\s{0,3}## (.*$)',
    tag => 'h2'
  },
  {
    regex => '^\s{0,3}### (.*$)',
    tag => 'h3'
  },
  {
    regex => '^\s{0,3}##### (.*$)',
    tag => 'h4'
  },
  {
    regex => '^\s{0,3}##### (.*$)',
    tag => 'h5'
  },
  {
    regex => '^\s{0,3}###### (.*$)',
    tag => 'h6'
  },
  {
    regex => '\*\*\*(.+)\*\*\*',
    tag => 'b'
  },
  {
    regex => '\*\*(.+)\*\*',
    tag => 'strong'
  },
  {
    regex => '\*(.+)\*',
    tag => 'em'
  },
  {
    regex => '_(.+)_',
    tag => 'em'
  },

  {
    regex => '~~(.+)~~',
    tag => 'del'
  },
  {
    regex=> '\[(.+)\]\((.+)\)',
    tag=> 'a'
  },
  {
    regex => '```([\s\S.]+)```',
    tag => 'code'
  },
  {
    regex => '(((?:^[^<])|(?:<(?:b|strong|del|em)>)).+((?:[^>]$)|(?:<\/(?:b|strong|del|em)>)))',
    tag => 'p'
  }
 );
 
 my $body = translate(@types,$text);
printHTML($title,$body);

sub translate{
  my $str=pop(@_);
  my @types = @_;

  foreach my $type (@types){
    my $tag = $type->{tag};
    my $regex = $type->{regex};

    if($tag eq 'a'){
        $str =~ s/$regex/<p><$tag href="$2">$1<\/$tag><\/p>/gm;
    }
    else{
        $str =~ s/$regex/<$tag>$1<\/$tag>/gm;
    }
  }
  return $str;
}
sub printHTML{
  my $title=$_[0];
  my $body=$_[1];
  print <<HTML;
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8">
    <title>$title</title>
  </head>
  <body>
    $body
  </body>
</html>
HTML
}
sub consulta{
  my $condicion = $_[0];
  my $variable1 =$_[1];
  my $sth = $dbh->prepare($condicion);
  $sth->execute($variable1);
  my $text;
  while(my @row = $sth->fetchrow_array){
    $text = $row[0];
  }
  $sth->finish;
  return $text;
}
