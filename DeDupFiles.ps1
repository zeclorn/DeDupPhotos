Clear-Content log.txt

foreach ($year in (Get-ChildItem -path "V:\temp Pics\Masters" -force)){
    foreach ($File in (Get-ChildItem -path "V:\temp Pics\Masters\$year" -Recurse -force)){
        
        $DestPath ="V:\temp Pics\Consolidated\$year"
        
        if(!(Test-Path $File.FullName -pathType container)){

            Write-host $File.FullName
            $sourceFile = $($File.FullName)


            if (!(Test-Path "$DestPath" -pathType container)){
                Mkdir $DestPath
                write-host "Makine $DestPath"
            }

            if (!(Test-Path "$DestPath\$File")){
            copy $sourceFile "$DestPath\$File"
            }
            else {
                $sourceFileHash =  Get-FileHash "$sourceFile" -Algorithm MD5
                $DestFileHas = Get-FileHash "$DestPath\$File" -Algorithm MD5

                if (!($sourceFileHash -eq $DestFileHas)){
                
                    if (!(Test-Path "$DestPath\Duplicates" -pathType container)){
                       Mkdir "$DestPath\Duplicates"
                    }
                    if (!(Test-Path "$DestPath\Duplicates\$File")){
                        copy $sourceFile "$DestPath\Duplicates\$File"
                    }

                    else {

                    $FileExists = $true
                    $i = 1

                    Do  {
                    
                        $canidatename = "$DestPath\Duplicates\$($File.BaseName)_$i.$($File.Extension)"

                        If (Test-Path $canidatename){
                        Add-content log.txt "$($canidatename) - name taken"
                        $i++

                        }
                        else {
                            $FileExists = $false
                            copy $sourceFile $canidatename
                            Add-content log.txt "$canidatename SuccessfullyCreated"
                        }

                    
                    }
                    
                    while ($FileExists -eq $true)
                }
            }
         }


    }
}
}



