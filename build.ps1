$scriptPath = (Get-Variable MyInvocation -Scope Script).Value.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location $dir

$distributions = (go tool dist list -json)|convertfrom-json 

$originalGoos = $env:GOOS
$originalGoarch = $env:GOARCH

If(Test-Path bin -PathType Container) {
    Remove-Item bin -Recurse
    New-Item bin -ItemType Directory
}

"#!/bin/bash`n" | Out-File bin\run-tests.sh -Encoding ascii -NoNewline

foreach ($dist in $distributions) {
    If ($dist.GOOS -eq "windows") {
        $extension = ".exe"
    } else {
        $extension = ""
    }

    $filename = "go-backup-finder-$($dist.GOOS)-$($dist.GOARCH)$extension"

    Write-Host "Attempting to build: $filename"

    $env:GOOS=$dist.GOOS
    $env:GOARCH=$dist.GOARCH
    go build -o bin\$filename

    "Write-Host ""Attempting to run: $filename""" >> bin\run-tests.ps1
    ".\$filename" >> bin\run-tests.ps1
    "" >> bin\run-tests.ps1

    "echo ""Attempting to run: $filename""`n" | Out-File bin\run-tests.sh -Append -Encoding ascii -NoNewline
    "chmod +x $filename`n" | Out-File bin\run-tests.sh -Append -Encoding ascii -NoNewline
    "./$filename`n" | Out-File bin\run-tests.sh -Append -Encoding ascii -NoNewline
    "`n" | Out-File bin\run-tests.sh -Append -Encoding ascii -NoNewline
}

"Write-Host ""Completed. These files ran successfully (recorded in results.log):""" >> bin\run-tests.ps1
"Get-Content results.log" >> bin\run-tests.ps1

"echo ""Completed. These files ran successfully (recorded in results.log):""`n" | Out-File bin\run-tests.sh -Append -Encoding ascii -NoNewline
"cat results.log`n" | Out-File bin\run-tests.sh -Append -Encoding ascii -NoNewline


$env:GOOS = $originalGoos
$env:GOARCH = $originalGoarch

Pop-Location