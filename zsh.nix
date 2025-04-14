{ hostname, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    history.size = 10000;
    profileExtra = ''
      #
    '';
    initExtra = ''
      zstyle ":completion:*" menu select
      zstyle ":completion:*" matcher-list "" "m:{a-z0A-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"
      if type nproc &>/dev/null; then
        export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
      fi
      bindkey '^[[3~' delete-char                     # Key Del
      bindkey '^[[5~' beginning-of-buffer-or-history  # Key Page Up
      bindkey '^[[6~' end-of-buffer-or-history        # Key Page Down
      bindkey '^[[1;3D' backward-word                 # Key Alt + Left
      bindkey '^[[1;3C' forward-word                  # Key Alt + Right
      bindkey '^[[H' beginning-of-line                # Key Home
      bindkey '^[[F' end-of-line                      # Key End
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';
    initExtraFirst = ''
      setopt autocd nomatch
      unsetopt beep extendedglob notify
      autoload -Uz compinit
      compinit
    '';
    sessionVariables = {
    };
    shellAliases = {
      rebuild-system-test = "nh os switch --hostname ${hostname} --dry";
      rebuild-system-switch = "nh os switch --hostname ${hostname}";
      rebuild-system-boot = "nh os boot --hostname ${hostname}";
      update-system-test = "nh os switch --hostname ${hostname} --update --dry";
      update-system-switch = "nh os switch --hostname ${hostname} --update";
      update-system-boot = "nh os boot --hostname ${hostname} --update";
      system-cleanup="nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      ls="lsd";
      ll="lsd -l";
      la="lsd -a";
      lal="lsd -al";
      ".."="cd ..";
    };
  };
  programs.starship.enable = true;
  programs.direnv.enable = true;
  programs.lsd.enable = true;
  programs.lsd.settings = {
    icons = {
      when = "auto";
      theme = "fancy";
      separator = " ";
    };
  };
}
