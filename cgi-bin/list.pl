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

my $list = renderLista(@titles);
printHTML("../estilos.css",$list);


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

sub renderLista{ 
  my @titles = @_;
  my $lista="   <ul>\n";
  foreach my $titulo (@titles){
    my $div= <<"LISTA";
      <li>
        <a href="view.pl?title=$titulo">$titulo</a>
        <section class ="boton-edicion">
          <a href="delete.pl?title=$titulo">X</a>
          <a href="edit.pl?title=$titulo">E</a>
        </section> 
      </li>
LISTA
    $lista.=$div;
  }
  $lista.="    </ul>";
  return $lista;
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
  <h1>Nuestras Paginas de Wiki</h1>
$body
  <section class="navegacion">
    <nav class="navegacion">
      <a href="../new.html">Nueva Pagina</a>
      <a href="../qq.html">Volver al inicio</a>
    </nav>
  </section>
  </body>
</html>
BLOCK

}
