# Import Terminal Icons
Import-Module -Name Terminal-Icons

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# If so and the current host is a command line, then change to red color 
# as warning to user that they are operating in an elevated context
# Useful shortcuts for traversing directories
function cd...  { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }


# Set up command prompt and window title. Use UNIX-style convention for identifying 
# whether user is elevated (root) or not. Window title shows current version of PowerShell
# and appends [ADMIN] if appropriate for easy taskbar identification
function prompt 
{ 
    if ($isAdmin) 
    {
        "[" + (Get-Location) + "] # " 
    }
    else 
    {
        "[" + (Get-Location) + "] $ "
    }
}

$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
if ($isAdmin)
{
    $Host.UI.RawUI.WindowTitle += " [ADMIN]"
}

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs
{
    if ($args.Count -gt 0)
    {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else
    {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin
{
    if ($args.Count -gt 0)
    {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

# We don't need these any more; they were just temporary variables to get to $isAdmin. 
# Delete them to prevent cluttering up the user profile. 
Remove-Variable identity
Remove-Variable principal

function ll { Get-ChildItem -Path $pwd -File }

function uptime {
        #Windows Powershell    
        Get-WmiObject win32_operatingsystem | Select-Object csname, @{LABEL='LastBootUpTime';
        EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}

        #Powershell Core / Powershell 7+ (Uncomment the below section and comment out the above portion)

        <#
        $bootUpTime = Get-WmiObject win32_operatingsystem | Select-Object lastbootuptime
        $plusMinus = $bootUpTime.lastbootuptime.SubString(21,1)
        $plusMinusMinutes = $bootUpTime.lastbootuptime.SubString(22, 3)
        $hourOffset = [int]$plusMinusMinutes/60
        $minuteOffset = 00
        if ($hourOffset -contains '.') { $minuteOffset = [int](60*[decimal]('.' + $hourOffset.ToString().Split('.')[1]))}       
          if ([int]$hourOffset -lt 10 ) { $hourOffset = "0" + $hourOffset + $minuteOffset.ToString().PadLeft(2,'0') } else { $hourOffset = $hourOffset + $minuteOffset.ToString().PadLeft(2,'0') }
        $leftSplit = $bootUpTime.lastbootuptime.Split($plusMinus)[0]
        $upSince = [datetime]::ParseExact(($leftSplit + $plusMinus + $hourOffset), 'yyyyMMddHHmmss.ffffffzzz', $null)
        Get-WmiObject win32_operatingsystem | Select-Object @{LABEL='Machine Name'; EXPRESSION={$_.csname}}, @{LABEL='Last Boot Up Time'; EXPRESSION={$upsince}}
        #>


        #Works for Both (Just outputs the DateTime instead of that and the machine name)
        # net statistics workstation | Select-String "since" | foreach-object {$_.ToString().Replace('Statistics since ', '')}
        
}
function reload-profile {
        & $profile
}


function find-file($name) {
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
                $place_path = $_.directory
                Write-Output "${place_path}\${_}"
        }
}
function unzip ($file) {
        Write-Output("Extracting", $file, "to", $pwd)
	$fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object{$_.FullName}
        Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function grep($regex, $dir) {
        if ( $dir ) {
                Get-ChildItem $dir | select-string $regex
                return
        }
        $input | select-string $regex
}
function touch($file) {
        "" | Out-File $file -Encoding ASCII
}

function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function export($name, $value) {
        set-item -force -path "env:$name" -value $value;
}

function octave(){
	octave-7.3.0.bat
}



## Final Line to set prompt
oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
