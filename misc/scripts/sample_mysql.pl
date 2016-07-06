
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
$query = "insert into address (name_first, name_last, address_01, address_02, address_city, address_state, address_postal_code) 
			values (?, ?, ?, ?, ?, ?, ?) ";

# prepare your statement for connecting to the database
$statement = $connection->prepare($query);

# execute your SQL statement
$statement->execute('John', 'Smith', '100 Main Street', 'Suite 500', 'Buffalo', 'NY', '14201');

#----------------------------------------------------------------------


#----------------------------------------------------------------------
# retrieve the values from the database
#----------------------------------------------------------------------

# set the value of your SQL query
$query2 = "select name_first, name_last, address_01, address_02, address_city, address_state, address_postal_code from address where name_last = 'Smith'";

# prepare your statement for connecting to the database
$statement = $connection->prepare($query2);

# execute your SQL statement
$statement->execute();

# we will loop through the returned results that are in the @data array
# even though, for this example, we will only be returning one row of data

   while (@data = $statement->fetchrow_array()) {
      $name_first = $data[0];
      $name_last = $data[1];
      $address_01 = $data[2];
      $address_02 = $data[3];
      $address_city = $data[4];
      $address_state = $data[5];
      $address_postal_code = $data[6];

print "RESULTS - $name_first, $name_last, $address_01, $address_02, $address_city, $address_state, $address_postal_code\n";

}

#----------------------------------------------------------------------


# exit the script
exit;

#--- start sub-routine ------------------------------------------------
sub ConnectToMySql {
#----------------------------------------------------------------------

my ($db) = @_;

# open the accessDB file to retrieve the database name, host name, user name and password
open(ACCESS_INFO, "<..\/accessAdd") || die "Can't access login credentials";

# assign the values in the accessDB file to the variables
my $database = <ACCESS_INFO>;
my $host = <ACCESS_INFO>;
my $userid = <ACCESS_INFO>;
my $passwd = <ACCESS_INFO>;

# assign the values to your connection variable
my $connectionInfo="dbi:mysql:$db;$host";

# close the accessDB file
close(ACCESS_INFO);

# the chomp() function will remove any newline character from the end of a string
chomp ($database, $host, $userid, $passwd);

# make connection to database
my $l_connection = DBI->connect($connectionInfo,$userid,$passwd);

# the value of this connection is returned by the sub-routine
return $l_connection;

}

#--- end sub-routine --------------------------------------------------