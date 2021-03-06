#requires -version 2

 
param (
                [Parameter( Mandatory=$false)]
                [string]$server,
               
                [Parameter( Mandatory=$false)]
                [bool]$reportmode=$false,
               
                [Parameter( Mandatory=$false)]
                [string]$reportfile="exchangeserverhealth.html",
               
                [Parameter( Mandatory=$false)]
                [bool]$sendemail=$false
                )
 
#...................................
# Initialize
#...................................
 
Write-Host "Initializing..."
 

#Set recipient scope
if (!(Get-ADServerSettings).ViewEntireForest)
{
                Set-ADServerSettings -ViewEntireForest $true -WarningAction SilentlyContinue
}
 
 
#...................................
# Variables
#...................................
 
$now = Get-Date                                                                                                                                                                             #Used for timestamps
$date = $now.ToShortDateString()                                                                                          #Short date format for email message subject
[array]$exchangeservers = @()                                                                                                 #Array for the Exchange server or servers to check
[int]$transportqueuehigh = 1000                                                                                                              #Change this to set transport queue high threshold
[int]$transportqueuewarn = 500                                                                                                                                               #Change this to set transport queue warning threshold
$mapitimeout = 10                                                                                                                                                          #Timeout for each MAPI connectivity test, in seconds
$pass = "Green"
$warn = "Yellow"
$fail = "Red"
$ip = $null
[array]$summaryreport = @()
[array]$report = @()
$ScriptHomePath = "C:\Users\pwrshelladmin\Documents\Prod Scripts\Test-ExchangeServerHealth"
$yyyyMMddDate = $Now.AddHours(-6) | Get-Date -Format yyyyMMdd
$ArchiveFileName = ($yyyyMMddDate + $reportfile)
$ArchiveFullPath = ($ScriptHomePath + "\Archive\" + $ArchiveFileName)
 
 
 
#...................................
# Error/Warning Strings
#...................................
 
$string0 = "Server is not an Exchange server. "
$string1 = "Server is not reachable by ping. "
$string3 = "------ Checking"
$string4 = "Could not test service health. "
$string5 = "Required services not running. "
$string6 = "Could not check queue. "
$string7 = "Public Folder database not mounted. "
$string8 = "Skipping Edge Transport server. "
$string9 = "Mailbox databases not mounted. "
$string10 = "MAPI tests failed. "
$string11 = "Mail flow test failed. "
$string12 = "No Exchange Server 2003 checks performed. "
$string13 = "Server not found in DNS. "
 
 
 
#...................................
# Making Connection To Database
#...................................

Write-Output "Connecting to db "
#Dashboard database connectivity
$MySQLAdminUserName = 'pinuser'
$MySQLAdminPassword = 'pin@123'
$MySQLDatabase = 'pdb60166'
$MySQLHost = '172.31.49.151'
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase


Try {
        Write-Output "Inside try connection"
        [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
        $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
        $Connection.ConnectionString = $ConnectionString
        Write-Output "Before Open()"
        $Connection.Open()
          
        Write-Output "After Open()"
        $Cmd = New-Object MySql.Data.MySqlClient.MySqlCommand
        $Cmd.connection = $Connection
        
         
        #Check if a single server was specified
        if ($server)
        {
                        #Run for single specified server
                        try
                        {
                                        $exchangeservers = Get-ExchangeServer $server -ErrorAction Stop
                        }
                        catch
                        {
                                        #Couldn't find Exchange server of that name
                                        Write-Warning $_.Exception.Message
                                       
                                        #Exit because single server was specified and couldn't be found in the organization
                                        EXIT
                        }
        }
        else
        {
                        #This is the list of server names to never alert for
                        $ignorelist = @(Get-Content .\ignorelist.txt)
         
                        $tmpservers = @(Get-ExchangeServer)
                       
                        #Remove the servers that are ignored from the list of servers to check
                        foreach ($tmpserver in $tmpservers)
                        {
                                        if (!($ignorelist -icontains $tmpserver.name))
                                        {
                                                        $exchangeservers = $exchangeservers += $tmpserver
                                        }
                        }
        }
         
        #Begin the health checks
        foreach ($server in $exchangeservers)
        {
         
                        Write-Host -ForegroundColor White "$string3 $server"
         
                        #Find out some details about the server
                        try
                        {
                                        $roles = Get-ExchangeServer $server -ErrorAction Stop
                        }
                        catch
                        {
                                        Write-Warning $_.Exception.Message
                                        $roles = $null
                        }
         
                        if ($roles -eq $null )
                        {
                                        #Server is not an Exchange server
                                        Write-Host -ForegroundColor $warn $string0
                        }
                        elseif ( $roles.IsEdgeServer )
                        {
                                        Write-Host -ForegroundColor White $string8
                        }
                        else
                        {
                                        #Server is an Exchange server, continue the health check
         
                                        #Custom object properties
                                        $serverObj = New-Object PSObject
                                        $serverObj | Add-Member NoteProperty -Name "Server" -Value $server
                                        $serverObj | Add-Member NoteProperty -Name "Site" -Value $server.site.name
                                        $serverObj | Add-Member NoteProperty -Name "DNS" -Value $null
                                        $serverObj | Add-Member NoteProperty -Name "Ping" -Value $null
                                        $serverObj | Add-Member NoteProperty -Name "Uptime (hrs)" -Value $null
                                        $serverObj | Add-Member NoteProperty -Name "Version" -Value $null
                                        $serverObj | Add-Member NoteProperty -Name "Roles" -Value $null
                                        $serverObj | Add-Member NoteProperty -Name "CA Services" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "HT Services" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "MB Services" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "UM Services" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "Transport Queue" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "PF DBs Mounted" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "MB DBs Mounted" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "Mail Flow Test" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "MAPI Test" -Value "n/a"
                                        $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ""
                                        $serverObj | Add-Member NoteProperty -Name "Warning Details" -Value ""
         
         
                                        #Check server name resolves in DNS
                                        Write-Host "DNS Check: " -NoNewline;
                                        try
                                        {
                                                        $ip = [System.Net.Dns]::GetHostByName($server).AddressList | Select-Object IPAddressToString -ExpandProperty IPAddressToString
                                        }
                                        catch
                                        {
                                                        Write-Host -ForegroundColor $warn $_.Exception.Message
                                                        $ip = $null
                                        }
                                        finally    {}
         
                                        if ( $ip -ne $null )
                                        {
         
                                                        Write-Host -ForegroundColor $pass "Pass"
                                                        $serverObj | Add-Member NoteProperty -Name "DNS" -Value "Pass" -Force
         
                                                        #Is server online
                                                        Write-Host "Server up: " -NoNewline;
                                                        $ping = new-object System.Net.NetworkInformation.Ping
                                                        $result = $ping.send($ip)
                                                        if ($result.status.ToString() –eq "Success")
                                                        {
                                                                        Write-Host -ForegroundColor $pass "Pass"
                                                                        $serverObj | Add-Member NoteProperty -Name "Ping" -Value "Pass" -Force
                                                                       
                                                                        #Uptime check
                                                                        $uptime = $null
                                                                        $laststart = $null
                                                                       
                                                                        try
                                                                        {
                                                                                        $laststart = [System.Management.ManagementDateTimeconverter]::ToDateTime((Get-WmiObject -Class Win32_OperatingSystem -computername $server -ErrorAction Stop).LastBootUpTime)
                                                                        }
                                                                        catch
                                                                        {
                                                                                        Write-Host -ForegroundColor $warn $_.Exception.Message
                                                                        }
                                                                        finally    {}
                                                                       
                                                                        if ($laststart -eq $null)
                                                                        {
                                                                                        [string]$uptime = "Unable to retrieve uptime"
                                                                        }
                                                                        else
                                                                        {
                                                                                        [int]$uptime = (New-TimeSpan $laststart $now).TotalHours
                                                                                        [int]$uptime = "{0:N0}" -f $uptime
                                                                        }
                                                                       
                                                                        Write-Host "Uptime (hrs): " -NoNewline;
                                                                        Switch ($uptime -gt 23) {
                                                                                        $true { Write-Host -ForegroundColor $pass $uptime }
                                                                                        $false { Write-Host -ForegroundColor $warn $uptime }
                                                                                        default { Write-Host -ForegroundColor $warn $uptime }
                                                                                        }
                                                                        $serverObj | Add-Member NoteProperty -Name "Uptime (hrs)" -Value $uptime -Force    
                                                       
                                                                        #Determine the friendly version number
                                                                        $ExVer = $roles.AdminDisplayVersion
                                                                        Write-Host "Server version: " -NoNewline;
                                                                       
                                                                        if ($ExVer -like "Version 6.*")
                                                                        {
                                                                                        $version = "Exchange 2003"
                                                                        }
                                                                       
                                                                        if ($ExVer -like "Version 8.*")
                                                                        {
                                                                                        $version = "Exchange 2007"
                                                                        }
                                                                       
                                                                        if ($ExVer -like "Version 14.*")
                                                                        {
                                                                                        $version = "Exchange 2010"
                                                                        }
                                                                       
                                                                        Write-Host $version                                                      
                                                                        $serverObj | Add-Member NoteProperty -Name "Version" -Value $version -Force
                                                       
                                                                        if ($version -eq "Exchange 2003")
                                                                        {
                                                                                        Write-Host $string12
                                                                                        #$report = $report + $serverObj
                                                                        }
                                                                        if ($version -eq "Exchange 2007" -or $version -eq "Exchange 2010")
                                                                        {
                                                                                        #START - Exchange 2007/2010 Health Checks
                                                                                       
                                                                                        Write-Host "Roles:" $roles.ServerRole
                                                                                        $serverObj | Add-Member NoteProperty -Name "Roles" -Value $roles.ServerRole -Force
                                                                                       
                                                                                        $IsEdge = $roles.IsEdgeServer                  
                                                                                        $IsHub = $roles.IsHubTransportServer
                                                                                        $IsCAS = $roles.IsClientAccessServer
                                                                                        $IsMB = $roles.IsMailboxServer
         
                                                                                        #START - General Server Health Check
                                                                                        #Skipping Edge Transports for the general health check, as firewalls usually get
                                                                                        #in the way. If you want to include then, remove this If.
                                                                                        if ($IsEdge -ne $true)
                                                                                        {
                                                                                                                        #Service health is an array due to how multi-role servers return Test-ServiceHealth status
                                                                                                                        try {
                                                                                                                                        $servicehealth = @(Test-ServiceHealth $server -ErrorAction Stop)
                                                                                                                        }
                                                                                                                        catch {
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Warning Details" -Value ($($serverObj."Warning Details") + $string4) -Force
                                                                                                                                        Write-Host -ForegroundColor $warn $string4
                                                                                                                        }
                                                                                                                       
                                                                                                                        if ($servicehealth)
                                                                                                                        {
                                                                                                                                        foreach($s in $servicehealth)
                                                                                                                                        {
                                                                                                                                                        switch ($s.Role)
                                                                                                                                                        {
                                                                                                                                                                        "Client Access Server Role" { $roleservices = "CA Services" }
                                                                                                                                                                        "Hub Transport Server Role" { $roleservices = "HT Services" }
                                                                                                                                                                        "Mailbox Server Role" { $roleservices = "MB Services" }
                                                                                                                                                                        "Unified Messaging Server Role" { $roleservices = "UM Services" }
                                                                                                                                                        }
                                                                                                                                                       
                                                                                                                                                        Write-Host $s.Role "Services: " -NoNewline;
                                                                                                                                                       
                                                                                                                                                        switch ($s.RequiredServicesRunning)
                                                                                                                                                        {
                                                                                                                                                                        $true { $svchealth = "Pass"; Write-Host -ForegroundColor $pass "Pass" }
                                                                                                                                                                        $false {$svchealth = "Fail"; Write-Host -ForegroundColor $fail "Fail"; $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ($($serverObj."Error Details") + $string5) -Force }
                                                                                                                                                        }
                                                                                                                                                        $serverObj | Add-Member NoteProperty -Name $roleservices -Value $svchealth -Force
                                                                                                                                        }
                                                                                                                        }
                                                                                        }
                                                                                        #END - General Server Health Check
         
                                                                                        #START - Hub Transport Server Check
                                                                                        if ($IsHub)
                                                                                        {
                                                                                                        $q = $null
                                                                                                        Write-Host "Total Queue: " -NoNewline;
                                                                                                        try {
                                                                                                                        $q = Get-Queue -server $server -ErrorAction Stop
                                                                                                        }
                                                                                                        catch {
                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Warning Details" -Value ($($serverObj."Warning Details") + $string6) -Force
                                                                                                                        Write-Host -ForegroundColor $warn $string6
                                                                                                                        Write-Warning $_.Exception.Message
                                                                                                        }
                                                                                                       
                                                                                                        if ($q)
                                                                                                        {
                                                                                                                        $qcount = $q | Measure-Object MessageCount -Sum
                                                                                                                        [int]$qlength = $qcount.sum
                                                                                                                        if ($qlength -le $transportqueuewarn)
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $pass $qlength
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Transport Queue" -Value "Pass" -Force
                                                                                                                        }
                                                                                                                        elseif ($qlength -gt $transportqueuewarn -and $qlength -lt $transportqueuehigh)
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $warn $qlength
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Transport Queue" -Value "Warn" -Force
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $fail $qlength
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Transport Queue" -Value "Fail" -Force
                                                                                                                        }
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Transport Queue" -Value "Unknown" -Force
                                                                                                        }
                                                                                        }
                                                                                        #END - Hub Transport Server Check
         
                                                                                        #START - Mailbox Server Check
                                                                                        if ($IsMB)
                                                                                        {
                                                                                                        #Get the PF and MB databases
                                                                                                        [array]$pfdbs = @(Get-PublicFolderDatabase -server $server -status -WarningAction SilentlyContinue)
                                                                                                        [array]$mbdbs = @(Get-MailboxDatabase -server $server -status | Where {$_.Recovery -ne $true})
                                                                                                        [array]$activedbs = @(Get-MailboxDatabase -status | Where {$_.MountedOnServer -eq ($server.fqdn)})
                                                                                                       
                                                                                                        #START - Database Mount Check
                                                                                                       
                                                                                                        #Check public folder databases
                                                                                                        if ($pfdbs.count -gt 0)
                                                                                                        {
                                                                                                                        Write-Host "Public Folder databases mounted: " -NoNewline;
                                                                                                                        [string]$pfdbstatus = "Pass"
                                                                                                                        [array]$alertdbs = @()
                                                                                                                        foreach ($db in $pfdbs)
                                                                                                                        {
                                                                                                                                        if (($db.mounted) -ne $true)
                                                                                                                                        {
                                                                                                                                                        $pfdbstatus = "Fail"
                                                                                                                                                        $alertdbs += $db.name
                                                                                                                                        }
                                                                                                                        }
         
                                                                                                                        $serverObj | Add-Member NoteProperty -Name "PF DBs Mounted" -Value $pfdbstatus -Force
                                                                                                                       
                                                                                                                        if ($alertdbs.count -eq 0)
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $pass $pfdbstatus
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $fail $pfdbstatus
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ($($serverObj."Error Details") + $string7) -Force
                                                                                                                                        Write-Host "Offline databases:"
                                                                                                                                        foreach ($al in $alertdbs)
                                                                                                                                        {
                                                                                                                                                        Write-Host -ForegroundColor $fail `t$al
                                                                                                                                        }
                                                                                                                        }
                                                                                                        }
                                                                                                       
                                                                                                        #Check mailbox databases
                                                                                                        if ($mbdbs.count -gt 0)
                                                                                                        {
                                                                                                                        [string]$mbdbstatus = "Pass"
                                                                                                                        [array]$alertdbs = @()
         
                                                                                                                        Write-Host "Mailbox databases mounted: " -NoNewline;
                                                                                                                        foreach ($db in $mbdbs)
                                                                                                                        {
                                                                                                                                        if (($db.mounted) -ne $true)
                                                                                                                                        {
                                                                                                                                                        $mbdbstatus = "Fail"
                                                                                                                                                        $alertdbs += $db.name
                                                                                                                                        }
                                                                                                                        }
         
                                                                                                                        $serverObj | Add-Member NoteProperty -Name "MB DBs Mounted" -Value $mbdbstatus -Force                                                                                                  
                                                                                                                       
                                                                                                                        if ($alertdbs.count -eq 0)
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $pass $mbdbstatus
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ($($serverObj."Error Details") + $string9) -Force
                                                                                                                                        Write-Host -ForegroundColor $fail $mbdbstatus
                                                                                                                                        Write-Host "Offline databases: "
                                                                                                                                        foreach ($al in $alertdbs)
                                                                                                                                        {
                                                                                                                                                        Write-Host -ForegroundColor $fail `t$al
                                                                                                                                        }
                                                                                                                        }
                                                                                                        }
                                                                                                       
                                                                                                        #END - Database Mount Check
                                                                                                       
                                                                                                        #START - MAPI Connectivity Test
                                                                                                        if ($activedbs.count -gt 0 -or $pfdbs.count -gt 0)
                                                                                                        {
                                                                                                                        [string]$mbdbstatus = "Pass"
                                                                                                                        [array]$alertdbs = @()
                                                                                                                        Write-Host "MAPI connectivity: " -NoNewline;
                                                                                                                        foreach ($db in $mbdbs)
                                                                                                                        {
                                                                                                                                        $mapistatus = Test-MapiConnectivity -Database $db -PerConnectionTimeout $mapitimeout
                                                                                                                                        if (($mapistatus.Result.Value) -ne "Success")
                                                                                                                                        {
                                                                                                                                                        $mbdbstatus = "Fail"
                                                                                                                                                        $alertdbs += $db.name
                                                                                                                                        }
                                                                                                                        }
         
                                                                                                                        $serverObj | Add-Member NoteProperty -Name "MAPI Test" -Value $mbdbstatus -Force
                                                                                                                       
                                                                                                                        if ($alertdbs.count -eq 0)
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $pass $mbdbstatus
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ($($serverObj."Error Details") + $string10) -Force
                                                                                                                                        Write-Host -ForegroundColor $fail $mbdbstatus
                                                                                                                                        Write-Host "MAPI failed to: "
                                                                                                                                        foreach ($al in $alertdbs)
                                                                                                                                        {
                                                                                                                                                        Write-Host -ForegroundColor $fail `t$al
                                                                                                                                        }
                                                                                                                        }
                                                                                                        }
                                                                                                        #END - MAPI Connectivity Test
                                                                                                       
                                                                                                        #START - Mail Flow Test
                                                                                                        if ($activedbs.count -gt 0 -or $version -eq "Exchange 2007")
                                                                                                        {
                                                                                                       
                                                                                                                        $flow = $null
                                                                                                                        $testmailflowresult = $null
                                                                                                                       
                                                                                                                        Write-Host "Mail flow test: " -NoNewline;
                                                                                                                        try
                                                                                                                        {
                                                                                                                                        $flow = Test-Mailflow $server -ErrorAction Stop
                                                                                                                        }
                                                                                                                        catch
                                                                                                                        {
                                                                                                                                        $testmailflowresult = $_.Exception.Message
                                                                                                                        }
                                                                                                                       
                                                                                                                        if ($flow)
                                                                                                                        {
                                                                                                                                        $testmailflowresult = $flow.testmailflowresult
                                                                                                                        }
         
                                                                                                                        if ($testmailflowresult -eq "Success")
                                                                                                                        {
                                                                                                                                        Write-Host -ForegroundColor $pass $testmailflowresult
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Mail Flow Test" -Value "Pass" -Force
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ($($serverObj."Error Details") + $string11) -Force
                                                                                                                                        Write-Host -ForegroundColor $fail $testmailflowresult
                                                                                                                                        $serverObj | Add-Member NoteProperty -Name "Mail Flow Test" -Value "Fail" -Force
                                                                                                                        }
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                                        Write-Host "Mail flow test: No active mailbox databases"
                                                                                                        }
                                                                                                        #END - Mail Flow Test
                                                                                        }
                                                                                        #END - Mailbox Server Check
         
                                                                        }
                                                                        #END - Exchange 2007/2010 Health Checks
                                                                        $report = $report + $serverObj
                                                        }
                                                        else
                                                        {
                                                                        #Server is not up
                                                                        Write-Host -ForegroundColor $warn $string1
                                                                        $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ($($serverObj."Error Details") + $string1) -Force
                                                                        $serverObj | Add-Member NoteProperty -Name "Ping" -Value "Fail" -Force
                                                                        $report = $report + $serverObj
                                                        }
                                        }
                                        else
                                        {
                                                        Write-Host -ForegroundColor $Fail "Fail"
                                                        Write-Host -ForegroundColor $warn $string13
                                                        $serverObj | Add-Member NoteProperty -Name "Error Details" -Value ($($serverObj."Error Details") + $string13) -Force
                                                        $serverObj | Add-Member NoteProperty -Name "DNS" -Value "Fail" -Force
                                                        $report = $report + $serverObj
                                        }
                        }             
        }
         
         
        #Generate the report
        if ($reportmode -or $sendemail)
        {
                        
         
                       if ($report)
                        {
                        
                        foreach($reportline in $report) {
                 $server = $reportline.server 
            Write-Output "server:$server"
            $site = $reportline.site     
            Write-Output "site:$site"
            $role = $reportline.roles  
          $role =  $role -replace "," , ",\"
             Write-Output "role:$role"
            
            $version = $reportline.version  
             Write-Output "version:$version"
             
             $dns = $reportline.dns 
             Write-Output "dns:$dns"
             
             $ping = $reportline.ping 
             Write-Output "ping:$ping"
             
             $uptime = $reportline."uptime (hrs)" 
             Write-Output "uptime:$uptime"
             
             $CAservices = $reportline."CA Services"  
             Write-Output "CAservices:$CAservices"
             
             $HTservices = $reportline."HT Services"  
             Write-Output "HTservices:$HTservices"
             
            $MBservices = $reportline."MB Services"  
             Write-Output "MB Services:$MBservices"
             
             $UMservices = $reportline."UM Services"  
             Write-Output "UM Services:$UMservices"
             
             $TransportQueue = $reportline."Transport Queue"  
             Write-Output "Transport Queue:$TransportQueue"
             
             $PfDb = $reportline."PF DBs Mounted"  
             Write-Output "PF DBs Mounted:$PfDb"
             
             $MbDb = $reportline."MB DBs Mounted"  
             Write-Output "MB DBs Mounted:$MbDb"
             
             $MapiTest = $reportline."MAPI Test"  
             Write-Output "MAPI Test:$MapiTest"
             
             $MailFlow = $reportline."Mail Flow Test"  
             Write-Output "Mail Flow Test:$MailFlow"
       
            $Cmd.commandtext = "insert into test_health values('$server','$site', '$role', '$version','$dns' , '$ping' ,'$uptime', '$CAservices', '$HTservices', '$MBservices', '$UMservices', '$TransportQueue', '$PfDb', '$MbDb', '$MapiTest', '$MailFlow')"
            $Cmd.executenonquery()
        }
                                          
         
                        
        
}
}
}
Catch {
        Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
}

Finally {
        $Connection.Close()    
}

