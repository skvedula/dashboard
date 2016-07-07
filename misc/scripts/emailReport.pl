#!/opt/fedex/web/bin/perl

use POSIX 'strftime';
use FileHandle;
use Socket;
use MIME::Lite;
use Net::SMTP;

# DBI is the standard database interface for Perl
# DBD is the Perl module that we use to connect to the MySQL database
use DBI;
use DBD::mysql;

use warnings;

use constant DEBUG => 1;    # Set to 0 for production

use lib '/opt/fedex/web/reports/EmailDomainReport';
require 'domain_info.pl';

$database = "sys";
$time  = strftime( "%H:%M:%S \(%Z\)", localtime );
$date  = strftime( "%A %m/%d/%Y",     localtime );
$pdate = strftime( "%m/%d/%Y",        localtime );
$odate = strftime( "%Y%m%d",          localtime );
$docFileSuffix = "Domains.Out";
%HASH          = ();
%newDirParms = (
    scope => 2,
    root  => 'ou=people,o=fedex,c=us',
    port  => 389,
    host  => 'directory.fedex.com'

        # port     => 9389,
        # host     => 'idcldap.prod.fedex.com'
);

STARTPGM:
{

    $baseDir = '/opt/fedex/web/reports/EmailDomainReport';

    $outFile = "$baseDir/reports/domain_rpt_${odate}.html";
    $docFile = "$baseDir/${docFileSuffix}";

    open( DOMAINS, ">$docFile" )
        || die " Can Not open output Filename $docFile";
    &Process_mailfxhomes();
    close DOMAINS;

    open( INPUT, "<${docFile}" )
        || die " Can Not open Input Filename ${docFile}";
    &Process_Domains;
 close INPUT;

# invoke the ConnectToMySQL sub-routine to make the database connection
	$connection = ConnectToMySql($database);
    Email_Report() if $domain_counts{'Grand'};
}

sub Process_mailfxhomes {
    $dumpCommand
        = "/usr/bin/ldapsearch -x -LLL -b \"$newDirParms{root}\" -h \"$newDirParms{host}\" -p \"$newDirParms{port}\" \"(&(!(FxSoxStatus=\*))(!(inetUserStatus='inactive'))(mailfxhome=\*))\" mailfxhome ";
    if ( open( COMMAND, "$dumpCommand |" ) ) {
        while ( $line = <COMMAND> ) {

            if ( $line =~ /mailfxhome:/ ) {
                $mailfxhome = $line;
                $mailfxhome = lc($mailfxhome);
                ( undef, $mhome ) = split /\@/, $mailfxhome, 2;
                chomp $mhome;
                $mhome =~ s/^\s+//;
                $mhome =~ s/\s+$//;
                next unless $mhome;

                if ( exists( $HASH{$mhome} ) ) {
                    $a            = 0;
                    $a            = $HASH{$mhome};
                    $a            = $a + 1;
                    $HASH{$mhome} = $a;
                } else {
                    $HASH{$mhome} = 1;
                }
            }
        }

        foreach $k ( sort keys %HASH ) {
            print DOMAINS "$k,$HASH{$k}\n";
        }

        close COMMAND;
    }
}
sub Process_Domains {
    $total_domains = 0;
    %domain_counts = ();
    while ( $line = <INPUT> ) {
        ( $domain_name, $domain_count, undef ) = split /,/, $line, 3;
        chomp $domain_name;
        $domain_name =~ s/^\s+//;
        $domain_name =~ s/^\s$//;
        chomp $domain_count;
        $domain_count =~ s/^\s+//;
        $domain_count =~ s/^\s$//;

        next unless ( $domain_name && $domain_count );

        $domain_counts{'Grand'} += $domain_count;
        $total_domains++;
        $domain_counts{$name} += $domain_count;
    }
}

sub Email_Report {
    my $D1 = commify( $domain_counts{'TAO'} );
    my $D2 = commify( $domain_counts{'Exchange'} );
    my $D3 = commify( $domain_counts{'iPlanet'} );
    my $D4 = commify( $domain_counts{'Notes'} );
    my $D5 = commify( $domain_counts{'Other'} );
    my $D6 = commify( $domain_counts{'Grand'} );
	$query = "insert into email_domains (domain_type, domain_mapping_count) 
	values (?, ?) ";

	# prepare your statement for connecting to the database
	$statement = $connection->prepare($query);

	# execute your SQL statement
	$statement->execute('TAO', $D1);
	$statement->execute('Exchange', $D2);
	$statement->execute('iPlanet', $D3);
	$statement->execute('Notes', $D4);
	$statement->execute('Other', $D5);
	$statement->execute('Grand', $D6);	
}

sub commify {
    return $_[0] unless $_[0] =~ /^\d+$/;
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

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