# Defined via `source`
function tb --wraps='curl -F file=@- 0x0.st' --description 'alias tb curl -F file=@- 0x0.st'
    curl -F file=@- 0x0.st $argv
end
