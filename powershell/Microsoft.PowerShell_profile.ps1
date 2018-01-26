#######################################################################
# Shortcut u2 to go up 2 directories
#######################################################################
for($i = 1; $i -le 5; $i++){
  $u =  "".PadLeft($i,"u")
  $unum =  "u$i"
  $d =  $u.Replace("u","../")
  Invoke-Expression "function $u { push-location $d }"
  Invoke-Expression "function $unum { push-location $d }"
}

#######################################################################
# Set edit mode like Windows (not emacs)
#######################################################################
Set-PSReadlineOption -EditMode Windows

#######################################################################
# Load Posh-git profile
#######################################################################
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}

# Load posh-git example profile
. 'C:\tools\poshgit\dahlbyk-posh-git-f71b636\profile.example.ps1'

Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}

#######################################################################
# Upload PATH to add git/usr/bin
#######################################################################
$env:Path = $env:Path + ";C:\Program Files\Git\usr\bin"

#######################################################################
# Aliases
#######################################################################
New-Alias csc "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe"
