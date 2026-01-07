####################
#     ALIASES      #
####################

alias pr="nvim -c 'Octo pr'"

alias syncnotes="git add . && git commit -m \"Sync mac $(date -I)\" && git push"

# Git aliases
alias git=hub
alias gst="git status"
alias gp="git push"
alias gl="git pull"
alias glg="git log"
alias gd="git diff"
alias gco="git checkout"
alias prn='gh pr view --json number -q .number'

####################
# CUSTOM FUNCTIONS #
####################

# mkcd recursively creates and cds into a directory
function mkcd() {
    mkdir -p $1
    cd $1
}


function latest_tag {
    echo "latest tag: $(git tag -l | sort -r --version-sort | head -n1)"
}
# macbook. what is the charger wattage, and what is the current charging power?
wattage () {
  info=$(ioreg -w 0 -f -r -c AppleSmartBattery)
  vol=$(echo $info | grep '"Voltage" = ' | grep -oE '[0-9]+')
  amp=$(echo $info | grep '"Amperage" = ' | grep -oE '[0-9]+')
  amp=$(bc <<< "if ($amp >= 2^63) $amp - 2^64 else $amp")
  wat="$(( (vol / 1000.0) * (amp / 1000.0) ))"
  /usr/sbin/system_profiler SPPowerDataType | grep Wattage
  printf "      Charging with: %.0f W\n" $wat
}

