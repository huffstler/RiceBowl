
$psstyle.fileinfo.Directory = $psstyle.Italic

function foo(){
@"
  print("I am a lua script embedded in a powershell profile script")
  print("bow down to me")
"@ | nvim -l -
}

function hist() {
	Get-Content (Get-PSReadlineOption).HistorySavePath
}

function rgh(){
$out = @"
Common Scenarios:

Search for a filename:
	rg --files <directory> | rg <search pattern>

Match all lines in Java files that contain:
	rg 'Statement\(\"(.*?)"' -otjava
	
Escaping:
	Backtick, not backslash
	```

Common Flags:

-o		: Only prints the matching portion
-t<filegroup>	: Only searches files associated with that file group
-i 		: Case Insensitive Search
-g		: Filename glob to match

"@

	Write-Host $out
}

function git() {
	# Call git with splatting
	& (Get-Command git -commandType Application) @args 2>&1
}

function notGitRepo() {
  # git status slow on repo's with binaries or lots of history
  $g = git status
  return $g -like "fatal*"
}

function colorize([string]$in) {
	return "$($PSStyle.Foreground.Cyan)$in $($PSStyle.Reset)"
}

function Prompt {
	$branch = if (notGitRepo) { "" } 
		Else { 
			colorize -in "[$(git symbolic-ref --short HEAD)]" 
		}

	$cdir = Get-Location
	Write-Output "$cdir`n$branch>> "
}
