#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;
my $q = CGI->new;
print $q->header("text/html","UTF-8");

my $user = "alumno";
my $password = "pweb1";
my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";

my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $stm = "SELECT Title FROM Articles";
my @titles = consulta($stm);
$dbh->disconnect;


sub consulta{
  my $condicion = $_[0];
  my $sth = $dbh->prepare($condicion);
  $sth->execute();
  my @titles;
  while(my @row = $sth->fetchrow_array){
    push @titles,$row[0];
  }
  $sth->finish;
  return @titles;
}
