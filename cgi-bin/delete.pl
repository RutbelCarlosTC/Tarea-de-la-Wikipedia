#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header("text/html","UTF-8");
my $title = $q->param("title");

my $user = "alumno";
my $password = "pweb1";
my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $stm = "DELETE FROM Articles WHERE Title=?";
my $res = consulta($stm,$title);
$dbh->disconnect;
my $body = "<p></p>";
if($res != 0){
  $body = "<p>Pagina borrada con exito</p>";
}
printHTML("../css/style.css",$body);

sub consulta{
  my $condicion = $_[0];
  my $variable1 =$_[1];
  my $sth = $dbh->prepare($condicion);
  my $res =  $sth->execute($variable1);
  $sth->finish;
  return $res;
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
    <p><b><a href="list.pl">Listado de paginas</a></b></p>
  </body>
</html>
BLOCK

}
