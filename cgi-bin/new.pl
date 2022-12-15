#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $user = "alumno";
my $password = "pweb1";
my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $stm = "SELECT Title FROM Articles WHERE Title=?";

sub select_title{
  my $condicion = $_[0];
  my $variable1 =$_[1];
  my $sth = $dbh->prepare($condicion);
  $sth->execute($variable1);
  my $title;
  while(my @row = $sth->fetchrow_array){
    $title = $row[0];
  }
  $sth->finish;
  return $title;
}
sub consulta{
  my $condicion = $_[0];
  my $variable1 =$_[1];
  my $variable2 =$_[2];
  my $sth = $dbh->prepare($condicion);
  $sth->execute($variable1,$variable2);
  $sth->finish;
}
sub printHTML{
 my $css = $_[0];
 my $body = $_[1];
 print <<BLOCK;
<!DOCTYPE html>
<html lang="es">
  <head>
    <title></title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="$css">
  </head>
  <body>
    $body
    <hr>
    <p>Pagina grabada <b><a href="list.pl">Listado de paginas</a></b></p>
  </body>
</html>
BLOCK

}

