$foo = New-TemporaryFile
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/huffstler/RiceBowl/master/Windows/winget-install.json" | Set-Content $foo
winget import --ignore-unavailable --accept-package-agreements -i $foo 
