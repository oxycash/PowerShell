$result = @()

$VersionList = Get-Content C:\temp\s.txt | ForEach-Object {
    $result = Invoke-WebRequest -Uri "https://www.google.com/search?client=firefox-b-d&q=$($_)"
    $data = $result.ParsedHtml.getElementsByTagName("html") |    select -ExpandProperty InnerText
    $vhost = $data

  

    [pscustomobject]@{
        Computer = $_
        VirtualHost = $vhost
       
    }
}
$versionList