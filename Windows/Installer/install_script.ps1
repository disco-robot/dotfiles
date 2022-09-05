# Run this [Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072]
# before the script, otherwise the script wont work beacause it's not signed


#					     _  _
#  . _  _|_ _ | _ |_. _  _    _ _ _. _ |_   '/ / |
#  || )_)|_(_||(_||_|(_)| )___)(_| ||_)|_  /_.   |  
#  





# Elevate privileges

if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
 Exit
}


$initdir = $(echo $pwd)
cd $HOME


# Gen ssh-keys
ssh-keygen

# # Install choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


# Install Apps
choco install -y 7zip git vscodium firefox steam openjdk python marktext discord simplenote wget legendary logseq bulk-crap-uninstaller

# Uninstall Edge
rm 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk'
cd C:\'Program Files (x86)'\Microsoft\Edge\Application\[0-9]*\Installer
.\setup.exe --uninstall --force-uninstall --system-level
reg  add  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate /v  DoNotUpdateToEdgeWithChromium /t  REG_DWORD /d  1




# Unbloat
cd $initdir
.\windows_debloater.ps1 -SysPrep -Debloat -Privacy



 ## Remove One drive
  cd $initdir
  .\uninstall_one_drive.ps1
  reg  add  HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds /v  ShellFeedsTaskbarViewMode /t  REG_DWORD /d  2


## Change Wallpaper
 # cd $initdir
 # $p=Resolve-Path ..\..\..\Wallpapers\Tired.png 
 # .\wallpaper_change.ps1 -path "$p"

