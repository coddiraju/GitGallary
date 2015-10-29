param(
  [Parameter(Mandatory=$true)]
  [alias("s")]
  [string] $binPath,
  [alias("t")]
  [Parameter(Mandatory=$true)]
  [string] $targetPath, 
  [alias("h")]
  [int] $hours=24, # how many hours back last modified 
  [alias("a")]
  [int] $all=1,  # 0=only the files different based on the time stamp 
  [alias("l")]
  [int] $log=1   # 0=do not output each file name 1=Verbose 
)
$ErrorActionPreference= 'silentlycontinue'
clear
$limit = (Get-Date).AddHours(-1*$hours)

$array = @()

$files =Get-ChildItem -File -Path $binPath -Recurse -include "*.dll","*.pdb", "exe" | Where{$_.LastWriteTime -gt $limit }
if($files) 
{
    if($all) 
    {
        Write-Host  "copying all files`n"
    } 
    else 
    {
        Write-Host  "copying modified files only`n"
    }
	foreach($file in $files) 
    {
        Write-Progress "Processing " $file.Name

        $nExt = "." + ("?" * ($file.Extension.Length-1))
		
        $trg = Get-ChildItem -Path $targetPath -Filter ($file.BaseName +$nExt)  -Recurse
		
        if($trg)
        {
			if($trg[0].LastWriteTime -ne $file.LastWriteTime -or ($all)) 
            {
				if($log) 
                {
                    Write-Host -NoNewline  $file.Name  '->' $trg[0].DirectoryName
                }
				
                Copy-Item -Path $file.FullName -Destination $trg[0].Directory -Force 
                
                if(-not $?) 
                {
                    if($log) 
                    {
                        write-host  "    [**Failed**]"
                    }
                    $array += ($error[0].Exception.Message)
                }
                else
                {
                    if($log) 
                    {
                        write-host  "    [Succes]" 
                    } 
                }
			}
		}

    }    
    if($array)
    {
        Write-Host  -ForegroundColor Red "`nUnable to process following files"   " $($array | % {"`n" +$_})"
    } 
    else 
    {
        Write-Host  "`nDone!!"
    }
} 
else 
{
    Write-Host "No files to process"
}
