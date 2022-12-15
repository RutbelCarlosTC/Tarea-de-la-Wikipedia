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
