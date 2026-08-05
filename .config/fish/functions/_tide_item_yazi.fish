# Defined via `source`
function _tide_item_yazi --wraps='test -n "$YAZI_LEVEL"&&_tide_print_item yazi "yazi"' --description 'alias _tide_item_yazi test -n "$YAZI_LEVEL"&&_tide_print_item yazi "yazi"'
    test -n "$YAZI_LEVEL"&&_tide_print_item yazi "yazi" $argv
end
