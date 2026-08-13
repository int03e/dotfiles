function f --wraps='fd --type f | fzf' --description 'alias f=fd --type f | fzf'
    fd --type f | fzf $argv
end
