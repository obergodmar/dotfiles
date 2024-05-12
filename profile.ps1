oh-my-posh init pwsh --config 'C:/Users/obergodmar/Code/dotfiles/obergodmar.omp.json' | Invoke-Expression

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

function rename_wezterm_title($title) {
  echo "$([char]27)]1337;SetUserVar=panetitle=$([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($title)))$([char]7)"
}

function Add-Alias($name, $alias) {
    $func = @"
function global:$name {
    `$expr = ('$alias ' + (( `$args | % { if (`$_.GetType().FullName -eq "System.String") { "``"`$(`$_.Replace('``"','````"').Replace("'","``'"))``"" } else { `$_ } } ) -join ' '))
    Invoke-Expression `$expr
}
"@
    $func | Invoke-Expression
}

Add-Alias Run-Eza 'eza --tree --level=1 --icons=always'
Set-Alias -Name ls -Value Run-Eza
