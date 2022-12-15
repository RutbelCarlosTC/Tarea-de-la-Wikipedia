#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;









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

