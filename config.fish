source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

alias gs="git status"
alias gc="git clone --recurse-submodules -j(nproc) --shallow-submodules --progress"

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


function copy_and_link
    if test (count $argv) -ne 2
        echo "Usage: copy_and_link <source> <destination>"
        return 1
    end

    set src $argv[1]
    set dst $argv[2]

    if not test -e $src
        echo "Error: source file/dir does not exist: $src"
        return 1
    end

    mkdir -p (dirname $dst)
    or return 1

    if test -d $src
        # Directory
        cp -a $src $dst
        or return 1

        rm -rf $src
        or return 1
    else
        # File
        cp $src $dst
        or return 1

        rm $src
        or return 1
    end

    ln -sv $dst $src
end
