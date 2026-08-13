function solong --wraps='sudo systemctl hibernate' --description 'alias hibernate=sudo systemctl hibernate'
    sudo systemctl hibernate $argv
end
