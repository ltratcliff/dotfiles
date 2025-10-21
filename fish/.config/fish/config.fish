if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path ~/.nix-profile/bin
set -gx EDITOR nvim
zoxide init fish | source
starship init fish | source
