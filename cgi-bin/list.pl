#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;
my $q = CGI->new;
print $q->header("text/html","UTF-8");
