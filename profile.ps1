oh-my-posh init pwsh --config 'C:/Users/obergodmar/Code/dotfiles/obergodmar.omp.json' | Invoke-Expression

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

function rename_wezterm_title($title) {
  echo "$([char]27)]1337;SetUserVar=panetitle=$([Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($title)))$([char]7)"
}
