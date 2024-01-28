function fish_greeting
     pokemon-colorscripts -r
end

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

if status is-interactive
    if test $TERM != 'dumb'
        function starship_transient_prompt_func
            starship module time
        end

        set -Ux STARSHIP_CONFIG $HOME/.config/starship.toml

        starship init fish | source
        enable_transience

        nvm use lts 1>/dev/null
    end

    alias ll 'exa --long --header --icons'
    alias g git
    alias d docker
    alias gr 'cd (gitroot.sh)'
    alias rm trash

    function gpt
        sgpt --model gpt-3.5-turbo $argv
    end
    
    fish_add_path "$HOME/.local/bin/"
    fish_add_path "$HOME/.config/bin/"
    fish_add_path "$HOME/.cargo/bin/"

    set --export EDITOR nvim
    set --export MANPAGER "nvim +Man!"
    set --export OPENAI_API_KEY (keyctl pipe 727219199)

    set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
    --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
    --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

    set -Ux DIRENV_SILENT 1
    set -Ux DIRENV_LOG_FORMAT ""
end

