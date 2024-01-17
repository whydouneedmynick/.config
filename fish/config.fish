set fish_greeting


function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert

    bind -k F4 edit_cmd
end

if status is-interactive
    if test ! $TMUX
        # kitten icat --align left ~/images/1626893389_Без-названия.gif
    end
    # Commands to run in interactive sessions can go here
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
        set prompt (string join " " $argv)
        sgpt --model gpt-3.5-turbo $prompt
    end
    
    fish_add_path "$HOME/.local/bin/"
    fish_add_path "$HOME/.config/bin/"
    fish_add_path "$HOME/.cargo/bin/"

    set --export EDITOR nvim
    set --export MANPAGER "nvim +Man!"

    set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
    --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
    --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

    set -Ux BEMENU_OPTS "\
        --center \
	--ignorecase \
	--prompt 󱞩 \
	--no-spacing \
	--wrap \
	--fixed-height \
	--width-factor 0.6 \
	--border 2 \
	--bdr '#97acee' \
        --border-radius 0 \
	--list 10 \
	--tf '#57ab5a' \
	--nb '#383c4a' \
	--hb '#383c4a' \
	--fbb '#383c4a' \
	--sb '#383c4a' \
	--scb '#383c4a' \
	--tb '#383c4a' \
	--fb '#383c4a' \
	--ab '#383c4a' \
	--hf '#539bf5' \
	--fn 'Iosevka NFM 14'
    "
    
    set -Ux DIRENV_SILENT 1
    set -Ux DIRENV_LOG_FORMAT ""

    # =============================================================================
    #
    # Utility functions for zoxide.
    #

    # pwd based on the value of _ZO_RESOLVE_SYMLINKS.
    function __zoxide_pwd
        builtin pwd -L
    end

    # A copy of fish's internal cd function. This makes it possible to use
    # `alias cd=z` without causing an infinite loop.
    if ! builtin functions --query __zoxide_cd_internal
        if builtin functions --query cd
            builtin functions --copy cd __zoxide_cd_internal
        else
            alias __zoxide_cd_internal='builtin cd'
        end
    end

    # cd + custom logic based on the value of _ZO_ECHO.
    function __zoxide_cd
        __zoxide_cd_internal $argv
    end

    # =============================================================================
    #
    # Hook configuration for zoxide.
    #

    # Initialize hook to add new entries to the database.
    function __zoxide_hook --on-variable PWD
        test -z "$fish_private_mode"
        and command zoxide add -- (__zoxide_pwd)
    end

    # =============================================================================
    #
    # When using zoxide with --no-cmd, alias these internal functions as desired.
    #

    if test -z $__zoxide_z_prefix
        set __zoxide_z_prefix 'z!'
    end
    set __zoxide_z_prefix_regex ^(string escape --style=regex $__zoxide_z_prefix)

    # Jump to a directory using only keywords.
    function __zoxide_z
        set -l argc (count $argv)
        if test $argc -eq 0
            __zoxide_cd $HOME
        else if test "$argv" = -
            __zoxide_cd -
        else if test $argc -eq 1 -a -d $argv[1]
            __zoxide_cd $argv[1]
        else if set -l result (string replace --regex $__zoxide_z_prefix_regex '' $argv[-1]); and test -n $result
            __zoxide_cd $result
        else
            set -l result (command zoxide query --exclude (__zoxide_pwd) -- $argv)
            and __zoxide_cd $result
        end
    end

    # Completions.
    function __zoxide_z_complete
        set -l tokens (commandline --current-process --tokenize)
        set -l curr_tokens (commandline --cut-at-cursor --current-process --tokenize)

        if test (count $tokens) -le 2 -a (count $curr_tokens) -eq 1
            # If there are < 2 arguments, use `cd` completions.
            complete --do-complete "'' "(commandline --cut-at-cursor --current-token) | string match --regex '.*/$'
        else if test (count $tokens) -eq (count $curr_tokens); and ! string match --quiet --regex $__zoxide_z_prefix_regex. $tokens[-1]
            # If the last argument is empty and the one before doesn't start with
            # $__zoxide_z_prefix, use interactive selection.
            set -l query $tokens[2..-1]
            set -l result (zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
            and echo $__zoxide_z_prefix$result
            commandline --function repaint
        end
    end
    complete --command __zoxide_z --no-files --arguments '(__zoxide_z_complete)'

    # Jump to a directory using interactive search.
    function __zoxide_zi
        set -l result (command zoxide query --interactive -- $argv)
        and __zoxide_cd $result
    end

    # =============================================================================
    #
    # Commands for zoxide. Disable these using --no-cmd.
    #

    abbr --erase z &>/dev/null
    alias z=__zoxide_z

    abbr --erase zi &>/dev/null
    alias zi=__zoxide_zi

    # =============================================================================
    #
    # To initialize zoxide, add this to your configuration (usually
    # ~/.config/fish/config.fish):
    #
    #   zoxide init fish | source

end

