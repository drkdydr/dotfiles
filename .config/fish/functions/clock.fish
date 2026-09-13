# Defined via `source`
function clock --wraps='termdown -z -Z "%H : %M : %S"' --description 'alias clock termdown -z -Z "%H : %M : %S"'
    termdown -z -Z "%H : %M : %S" $argv
end
