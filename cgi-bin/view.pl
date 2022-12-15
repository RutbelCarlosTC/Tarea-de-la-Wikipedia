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
