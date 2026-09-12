# Defined via `source`
function ed --wraps='nvim --clean -E' --description 'alias ed nvim --clean -E'
    nvim --clean -E $argv
end
