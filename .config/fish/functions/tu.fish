# Defined via `source`
function tu --wraps='test -z "$argv"&&set argv fish;HOME=(mktemp -d -p /tmp/user --suffix=-home)' --description 'alias tu test -z "$argv"&&set argv fish;HOME=(mktemp -d -p /tmp/user --suffix=-home)'
    test -z "$argv"&&set argv fish;HOME=(mktemp -d -p /tmp/user --suffix=-home) $argv
end
