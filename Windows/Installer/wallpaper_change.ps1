Param(
    [Parameter(Mandatory,
    HelpMessage="You must enter path")]
    [string[]]
    $path
)

$WallpDestFl = $path #assigning wallpaper image
$LockScrFl = $path #assigning lock screen image

#assigning the wallpaper and lockscreen

$regKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'
$DesktopPath = "DesktopImagePath" 
$DesktopStatus = "DesktopImageStatus"
$DesktopUrl = "DesktopImageUrl"
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"
$StatusValue = "1"
$DesktopImageValue = "$WallpDestFl"
$LockScreenImageValue = "$LockScrFl"



#checking if registry key is already present

#creates new registry key and values if not found
if(!(Test-Path $regKey)) {
    New-Item -Path $regKey -Force | Out-Null
    New-ItemProperty -Path $regKey -Name $DesktopStatus -Value $Statusvalue -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $regKey -Name $LockScreenStatus -Value $StatusValue -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $regKey -Name $DesktopPath -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
    New-ItemProperty -Path $regKey -Name $DesktopUrl -Value $DesktopImageValue -PropertyType STRING -Force | Out-Null
    New-ItemProperty -Path $regKey -Name $LockScreenPath -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null
    New-ItemProperty -Path $regKey -Name $LockScreenUrl -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null
}

#sets the already present registry key with values
else {
    Set-ItemProperty -Path $regKey -Name $DesktopStatus -Value $Statusvalue -Type DWORD -Force
    Set-ItemProperty -Path $regKey -Name $LockScreenStatus -Value $StatusValue -Type DWORD -Force
    Set-ItemProperty -Path $regKey -Name $DesktopPath -Value $DesktopImageValue -Type STRING -Force
    Set-ItemProperty -Path $regKey -Name $DesktopUrl -Value $DesktopImageValue -Type STRING -Force
    Set-ItemProperty -Path $regKey -Name $LockScreenPath -Value $LockScreenImageValue -Type STRING -Force
    Set-ItemProperty -Path $regKey -Name $LockScreenUrl -Value $LockScreenImageValue -Type STRING -Force
}



#restarting explorer.exe

stop-process -name explorer -Force


reg  add  HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization /v  NoLockScreen /t  REG_DWORD /d  1

#clears the error log

$error.clear()