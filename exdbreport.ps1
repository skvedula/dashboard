$dll = "E:\Program Files\Exchsrvr\Bin\Microsoft.Exchange.Data.dll"
[Reflection.Assembly]::LoadFile($dll)

#Get DB details
write-DbTable 

Function write-DbTable 
{
    $dbs = Get-MailboxDatabase -Status | Sort-Object Name
    
    Write-Output "In db connection"
    #Dashboard database connectivity
    $MySQLAdminUserName = 'pinuser'
    $MySQLAdminPassword = 'pin@123'
    $MySQLDatabase = 'pdb60166'
    $MySQLHost = '172.31.49.151'
    $ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase
    $Query1 = "delete from exchangedbreport"

    Try {
        [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
        $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
        $Connection.ConnectionString = $ConnectionString
        $Connection.Open()
        Write-Output "Established connection"
          
        $Cmd = New-Object MySql.Data.MySqlClient.MySqlCommand
        $Cmd.connection = $Connection
        $Cmd.commandtext = $Query1 
        $Cmd.executenonquery()
        Write-Output "Executed Query"

        $Cmd = New-Object MySql.Data.MySqlClient.MySqlCommand
        $Cmd.connection = $Connection
        foreach($db in $dbs) {
                 $name = $db.name 
            Write-Output "name:$name"
            $svr = $db.servername     
            Write-Output "server:$svr"
            $edb = $db.edbfilepath    
			$edb = $edb -replace "\\" , "\\"
            Write-Output "edb:$edb"
            [Microsoft.Exchange.Data.ByteQuantifiedSize]$rawEdbSize = $db.DatabaseSize
            Write-Output "edbsize:$rawEdbSize"
            $edbSize = $rawEdbSize.ToGB()
            Write-Output "edbsize1:$edbSize"
            [Microsoft.Exchange.Data.ByteQuantifiedSize]$rawWhiteSpace = $db.AvailableNewMailboxSpace
             Write-Output "rawWhiteSpace:$rawWhiteSpace"
            $whiteSpace = $rawWhiteSpace.ToMB()/1024
             Write-Output "whiteSpace:$whiteSpace"
            $mbxCount = (Get-Mailbox -Database $db -ResultSize unlimited).count
            Write-Output "mbxCount:$mbxCount"
            $topMailbox = Get-Mailbox -Database $db -ResultSize unlimited | Get-MailboxStatistics | Sort-Object TotalItemSize -Descending |Select-Object DisplayName -First 1 | Format-Table Displayname -HideTableHeaders | Out-String 
            Write-Output "topMailbox:$topMailbox"
            $topMailboxSize = Get-Mailbox -Database $db -ResultSize unlimited | Get-MailboxStatistics | Sort-Object TotalItemSize -Descending | Select-Object totalitemsize -First 1 
            $topMailboxSize = $topMailboxSize.TotalItemSize.Value.ToMB() 
            Write-Output "topMailboxSize:$topMailboxSize"
			$lastBackup =  $db.LastFullBackup  #;$currentDate = Get-Date
			#if ($lastBackup -eq $null) {     
        #$howOldBkp =  $null      
   # }
     
   # else { 
      #  $howOldBkp = $currentDate - $lastBackup     
      #  $howOldBkp = $howOldBkp.days     
  #  } 
  if ($lastBackup -eq $null) { 
  $lastBackup = "NULL"    
        Write-Output "lastBackup is null value:$lastBackup"   
            $Cmd.commandtext = "insert into exchangedbreport values('$name','$svr', '$edb', '$edbSize','$mbxCount' , '$whiteSpace' ,'$topMailbox', '$topMailboxSize', NULL, 'NULL')"
    }
     
    else { 
      $lastBackup = $lastBackup.AddHours(-6) | Get-Date -Format "yyyy-MM-dd HH:mm:ss"
			Write-Output "lastBackup has a value:$lastBackup"     
    #$lastBackup = $lastBackup.AddHours(-6) | Get-Date -Format "yyyy-MM-dd HH:mm:ss"
			#Write-Output "lastBackup:$lastBackup"
			#Write-Output "oldBackup:$howOldBkp"
       
            $Cmd.commandtext = "insert into exchangedbreport values('$name','$svr', '$edb', '$edbSize','$mbxCount' , '$whiteSpace' ,'$topMailbox', '$topMailboxSize', '$lastBackup', 'NULL')"
      }
            $Cmd.executenonquery()
     }
    }

    Catch {
        Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
    }

    Finally {
        $Connection.Close()    }
}