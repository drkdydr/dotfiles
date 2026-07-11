# Defined via `source`
function _tide_item_zmx --wraps='test -n "$ZMX_SESSION"&&_tide_print_item zmx " $ZMX_SESSION"' --description 'alias _tide_item_zmx test -n "$ZMX_SESSION"&&_tide_print_item zmx " $ZMX_SESSION"'
    test -n "$ZMX_SESSION"&&_tide_print_item zmx " $ZMX_SESSION" $argv
end
