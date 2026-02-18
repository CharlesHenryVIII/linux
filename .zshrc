source /usr/share/cachyos-zsh-config/cachyos-config.zsh
export VISUAL="vim"
export EDITOR="$VISUAL"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

copy_and_link() {
    local src="$1"
    local dst="$2"

    if [[ -z "$src" || -z "$dst" ]]; then
        echo "Usage: copy_and_link <source> <destination>"
        return 1
    fi

    if [[ ! -df "$src" ]]; then
        echo "Error: source file does not exist: $src"
        return 1
    fi

    mkdir -p -- "$(dirname -- "$dst")" || return 1

    cp -- "$src" "$dst" || return 1
    rm -- "$src" || return 1
    ln -vfs -- "$dst" "$src" || return 1
}
