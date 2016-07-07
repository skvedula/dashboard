
#!/usr/bin/perl

# DBI is the standard database interface for Perl
# DBD is the Perl module that we use to connect to the MySQL database
use DBI;
use DBD::mysql;

use warnings;

$database = "sys";

#----------------------------------------------------------------------
# insert the values into the database
#----------------------------------------------------------------------


# invoke the ConnectToMySQL sub-routine to make the database connection
$connection = ConnectToMySql($database);

# set the value of your SQL query
#$query = "insert into email_domains (domain_type, domain_name, domain_mapping_count, administered_by) 
			#values (?, ?, ?, ?) ";
$query = "insert into email_domains (domain_type, domain_mapping_count) 
values (?, ?) ";

# prepare your statement for connecting to the database
$statement = $connection->prepare($query);

# execute your SQL statement
$statement->execute('Microsoft Exchange', 23);

#----------------------------------------------------------------------


#----------------------------------------------------------------------
# retrieve the values from the database
#----------------------------------------------------------------------

# set the value of your SQL query
$query2 = "select * from email_domains";

# prepare your statement for connecting to the database
$statement = $connection->prepare($query2);

# execute your SQL statement
$statement->execute();
# we will loop through the returned results that are in the @data array
# even though, for this example, we will only be returning one row of data

   while (@data = $statement->fetchrow_array()) {
      $d_type = $data[0];
     # $d_name = $data[1];
      $d_map_count = $data[1];
      #$admin_by = $data[3];
      
#print "RESULTS - $d_type, $d_name, $d_map_count, $admin_by\n";
print "RESULTS - $d_type, $d_map_count\n";

}

#----------------------------------------------------------------------


# exit the script
exit;

#--- start sub-routine ------------------------------------------------
sub ConnectToMySql {
#----------------------------------------------------------------------

my ($db) = @_;

# assign the values in the accessDB file to the variables
my $database = 'sys';
my $host = 'localhost';
my $userid = 'pinuser';
my $passwd = 'pin@123';

# assign the values to your connection variable
my $connectionInfo="dbi:mysql:sys;localhost";

# the chomp() function will remove any newline character from the end of a string
chomp ($database, $host, $userid, $passwd);

# make connection to database
my $l_connection = DBI->connect($connectionInfo,$userid,$passwd);

# the value of this connection is returned by the sub-routine
return $l_connection;

}

#--- end sub-routine --------------------------------------------------