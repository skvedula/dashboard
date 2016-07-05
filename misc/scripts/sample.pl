#!/opt/fedex/web/bin/perl

use POSIX 'strftime';
use FileHandle;
use Socket;
use MIME::Lite;
use Net::SMTP;

use constant DEBUG => 1;    # Set to 0 for production

use lib '/opt/fedex/web/reports/EmailDomainReport';
# require 'domain_info.pl';

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
    %message = (
        'Grand Total' =>
            "\n    <td bgcolor=#99CCFF width=100% bordercolor=#000000><b>&nbsp\;Grand Total&nbsp\;</b></td>
    <td bgcolor=#FFCCFF width=100% bordercolor=#000000></td>
    <td bgcolor=#FFCCFF width=138% align=right bordercolor=#000000><b>&nbsp\;NNNNN&nbsp\;</b></td>
    <td bgcolor=#FFCCFF width=100% bordercolor=#000000></td>
    </tr>"
    );

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
        my $name;

        if ( $domain_info{$domain_name} ) {
            my $h_ref = $domain_info{$domain_name};
            $name  = $h_ref->{'name'};
            $MTA   = $h_ref->{'MTA'};
            $color = $h_ref->{'color'};
            $owner = $h_ref->{'owner'};
            $domain_counts{$name} += $domain_count;
        } else {
            my $h_ref = $domain_info{Other};
            $name  = $h_ref->{'name'};
            $MTA   = $h_ref->{'MTA'};
            $color = $h_ref->{'color'};
            $owner = $h_ref->{'owner'};
            $domain_counts{$name} += $domain_count;
        }
 my $d_count = commify($domain_count);

        $message{$name}
            .= "\n    <td $color width=100% bordercolor=#000000>&nbsp\;$MTA&nbsp\;</td>
    <td $color width=100% bordercolor=#000000>&nbsp\;$domain_name&nbsp\;</td>
    <td $color width=138% align=right bordercolor=#000000>&nbsp\;$d_count&nbsp\;</td>
    <td $color width=100% bordercolor=#000000>&nbsp\;$owner&nbsp\;</td>
    </tr>";

        my $total_name = $name . ' Total';
        unless ( $message{$total_name} ) {
            $message{$total_name}
                = "\n    <td $color width=100% bordercolor=#000000><b>&nbsp\;$MTA Total&nbsp\;</b></td>
    <td $color width=100% bordercolor=#000000></td>
    <td $color width=138% align=right bordercolor=#000000><b>&nbsp\;NNNNN&nbsp\;</b></td>
    <td $color width=100% bordercolor=#000000></td>
    </tr>";
        }
    }
}
sub Email_Report {
    my $D1 = commify( $domain_counts{'TAO'} );
    my $D2 = commify( $domain_counts{'Exchange'} );
    my $D3 = commify( $domain_counts{'iPlanet'} );
    my $D4 = commify( $domain_counts{'Notes'} );
    my $D5 = commify( $domain_counts{'Other'} );
    my $D6 = commify( $domain_counts{'Grand'} );

#     my $message = "";
#     my @types = ( 'TAO', 'Exchange', 'iPlanet', 'Notes', 'Other', 'Grand' );
#     foreach my $type (@types) {
#         $message .= $message{$type};
#         my $d_tot = commify( $domain_counts{$type} );
#         ( my $tot = $message{"$type Total"} ) =~ s/NNNNN/$d_tot/;
#         $message .= $tot;
#     }
# # Add email addresses as comma separated email addresses inside single quotes, i.e. 'nathan.waddell@fedex.com, phillip.mcclore.osv@fedex.com'
#     if (DEBUG) {
#         $to = 'sushmitha.kannoth@fedex.com, phillip.mcclore.osv@fedex.com';
#     } else {
#         $to
#             = 'sushmitha.kannoth@fedex.com';
#     }

#     $from    = "postgeneral\@fedex.com";
#     $subject = "Enterprise Email Domain Report $pdate $time";

#     $msg = MIME::Lite->build( To      => "$to",
#                               Subject => "$subject",
#                               From    => "$from",
#                               Type    => "multipart/related"
#                             );

#     $msg->attach(
#         Type => 'text/html',
#         Data => qq{

# <html>

# <head>
# </head>

# <body>
# <p>&nbsp;</p>
# <div align="center">
#   <center>
#   <table border="0" cellpadding="0" cellspacing="0" width="100%">
#     <tr>
#       <td width="50%" align="center"><img border="0" src="http://emaildev.web.fedex.com/images/logosvcs.gif" align="left" width="247" height="36"></td>
#     </center>
#     <td width="50%" valign="bottom" align="right">
#       <p align="right"><b><font face="Arial" size="3">Enterprise Communication and Collaboration Technology&nbsp; </font></b><center></center></td>
#     </tr>
#   </table>
# </div>
# <p align="right">&nbsp;</p>
# <hr color="#CCCCCC">
# <p align="center"><img border="0" src="http://emaildev.web.fedex.com/images/logosvcs.gif"><br>
# <i><b><font face="Arial" size="3">For&nbsp;&nbsp; $date&nbsp;&nbsp; $time</font></b></i></p>
# <hr color="#CCCCCC">
# <hr color="#6600CC" size="4">
# <div align="center">
#   <center>
#   <table border="0" cellpadding="0" cellspacing="0" width="100%">
#     <tr>
#       <td width="100%" bgcolor="#CCCCCC">
#         <p align="center"><b><font face="Arial" size="4" color="#6600CC">Active
#         Email Domains<br>
#         in Corporate LDAP<br>
#         </font>directory.fedex.com<font face="Arial" size="4" color="#6600CC"> </font></b></td>
#     </tr>
#   </table>
#   </center>
# </div>
# <p>&nbsp;</p>
# <div align="center">
#   <center>
#   <table border="0" cellpadding="0" cellspacing="0">
#     <tr>
#       <td>
#         <p align="center"><b><font face="Arial" size="4" color="#6600CC">Summary
#         Of Domains</font></b></p>
#         <div align="center">
#           <table border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
#             <tr>
#               <td bgcolor="#CCCCCC">&nbsp;</td>
#               <td bgcolor="#CCCCCC">
#                 <p align="center"><b><font color="#000000">MTA Type</font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;Total
#                 Entries&nbsp;&nbsp;</font></b></td>
#             </tr>
#             <tr>
#               <td bgcolor="#99CCFF"><b><font color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC"><b><font color="#000000">&nbsp;EMC/TAO</font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;$D1&nbsp; </font></b></td>
#             </tr>
#             <tr>
#               <td bgcolor="#FFCC99"><b><font color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC"><b><font color="#000000">&nbsp;Microsoft
#                 Exchange </font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;$D2&nbsp; </font></b></td>
#             </tr>
#             <tr>
#               <td bgcolor="#99FFCC"><b><font color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC"><b><font color="#000000">&nbsp;Sun-One
#                 iPlanet</font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;$D3&nbsp; </font></b></td>
#             </tr>
#             <tr>
#               <td bgcolor="#FF6699"><b><font color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC"><b><font color="#000000">&nbsp;Lotus Notes</font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;$D4&nbsp; </font></b></td>
#             </tr>
#             <tr>
#               <td bgcolor="#FFFF99">&nbsp;</td>
#               <td bgcolor="#CCCCCC"><b><font color="#000000">&nbsp;Department
#                 Managed (Other)&nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;$D5&nbsp;</font></b></td>
#             </tr>
# <tr>
#               <td bgcolor="#FFFF99">&nbsp;</td>
#               <td bgcolor="#CCCCCC"><b><font color="#000000">&nbsp;Department
#                 Managed (Other)&nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;$D5&nbsp;</font></b></td>
#             </tr>
#             <tr>
#               <td><b><font color="#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC" valign="middle" align="center"><b><font color="#000000">&nbsp;
#                 ($total_domains)&nbsp; Domains &nbsp;</font></b></td>
#               <td bgcolor="#CCCCCC" align="right"><b><font color="#000000">&nbsp;$D6&nbsp; </font></b></td>
#             </tr>
#           </table>
#         </div>
#       </td>
#     </tr>
#   </table>
#   </center>
# </div>
# <p>&nbsp;</p>
# <div align="center">
#   <center>
#   <table border="2" cellpadding="0" cellspacing="0" width="420" bordercolor="#000000">
#     <tr>
#       <td width="100%">
#         <p align="center"><b><font face="Arial" size="4" color="#6600CC">&nbsp;Domain&nbsp;
#         <br>
#         &nbsp;Type </font></b></td>
#       <td width="100%">
#         <p align="center"><b><font face="Arial" size="4" color="#6600CC">&nbsp;Domain&nbsp;
#         <br>
#         &nbsp;Name&nbsp;</font></b></td>
#       <td align="center" width="138">
#         <p align="center"><b><font face="Arial" size="4" color="#6600CC">&nbsp;Domain&nbsp;
#         <br>
#         &nbsp;Mapping&nbsp;<br>
#         &nbsp;Count&nbsp;</font></b></td>
#       <td width="100%">
#         <p align="center"><b><font face="Arial" size="4" color="#6600CC">&nbsp;Administered&nbsp;
#         <br>
#         &nbsp;By&nbsp;</font></b></td>
#     </tr>
# $message
#   </table>
#   </center>
# </div>
# </body>

# </html>

#         }
#                 );
#     $msg->send( 'smtp', 'mapper.gslb.fedex.com', Timeout => 60 );

#     # Save the report in the "reports" directory
#     open OUT, ">$outFile" or die "Cannot write open $outFile";
#     $msg->print_body( \*OUT );
#     close OUT;

#     # The following cleans up the output file a bit
#     system "/usr/bin/perl -ni -e'print if /</' $outFile";

# # ONE MORE THING: Create a soft link to this file
# # so users can get to it using https://pwb00124.prod.fedex.com/EmailDomainReport/
#     my $index_lnk = "$baseDir/reports/index.html";
#     unlink $index_lnk if -e $index_lnk;
#     symlink $outFile, $index_lnk;
}

sub commify {
    return $_[0] unless $_[0] =~ /^\d+$/;
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}