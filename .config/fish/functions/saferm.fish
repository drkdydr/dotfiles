# Defined via `source`
function saferm --wraps='shred -uvz' --description 'alias saferm shred -uvz'
    shred -uvz $argv
end
