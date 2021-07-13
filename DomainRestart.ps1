echo "Populating temp folder..."
New-Item /temp -ItemType Directory -ea 0
get-adcomputer -filter * |where{$_.distinguishedname -like '*Workstations*'} | Select Name | Export-csv -Path C:\temp\domaincomputers.txt
echo "Populating list of computers..."
start-sleep -s 5
echo "Remove excess quote marks and the first two lines of the file..."
$b = Get-Content -Path C:\temp\domaincomputers.txt
@(ForEach ($a in $b) {$a.Replace('"', '')})[2..($b.length-1)] > C:\temp\domaincomputers.txt
$b = Get-Content -Path C:\temp\domaincomputers.txt
echo "Get authorization..."
$s = get-content C:\temp\domaincomputers.txt
$c = get-credential domain\username
$answer = Read-Host "Are you sure you want to restart every computer in your domain? yes/no"
if ( $answer -eq "yes" )
{
    restart-computer -computername $s -force -throttlelimit 15 -credential $c
}

