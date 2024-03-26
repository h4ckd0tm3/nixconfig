{ config, pkgs, lib, ... }:

{ 
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs = {
    git.enable = true;
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = ["--color=dark --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"];
    };
    zsh = {
      enable = true;
      plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "z"
        ];
        extraConfig = ''
          ENABLE_CORRECTION="true"
        '';
      };
      initExtra = ''
        alias nani='echo "\033[0;31mOmae wa mou shindeiru" && sleep 1.5s && nano'
        alias c='clear'
        alias fuck='sudo $(fc -ln -1)'
        alias x='exit'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
        alias diff='diff --color=auto'

        alias cat='bat --theme Dracula -p --paging=never'
        alias ssh="TERM=xterm-256color ssh"


        command -v lsd &> /dev/null && alias ls='lsd --group-dirs first'

        function mkcd() {
                mkdir -p "$1" && cd "$1"
        }

        function transfer() {
            if [ $# -eq 0 ]; then
                echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>" >&2
                return 1
            fi
            if tty -s; then
                file="$1"
                file_name=$(basename "$file")
                if [ ! -e "$file" ]; then
                    echo "$file: No such file or directory" >&2
                    return 1
                fi
                if [ -d "$file" ]; then
                    file_name="$file_name.zip"
                    ,
                    (cd "$file" && zip -r -q - .) | curl --progress-bar --upload-file "-" "https://tr.vuln.at/$file_name" | tee /dev/null | pbcopy,
                else
                    cat "$file" | curl --progress-bar --upload-file "-" "https://tr.vuln.at/$file_name" | tee /dev/null | pbcopy
                fi
            else
                file_name=$1
                curl --progress-bar --upload-file "-" "https://tr.vuln.at/$file_name" | tee /dev/null | pbcopy
            fi
        }

        function zen () {
          ~/.config/sketchybar/plugins/zen.sh $1
        }

        function suyabai () {
          SHA256=$(shasum -a 256 /opt/homebrew/bin/yabai | awk "{print \$1;}")
          if [ -f "/private/etc/sudoers.d/yabai" ]; then
            sudo sed -i \'\' -e 's/sha256:[[:alnum:]]*/sha256:'\$\{SHA256}'/' /private/etc/sudoers.d/yabai
          else
            echo "sudoers file does not exist yet"
          fi
        }

        function brew() {
          command brew "$@" 

          if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
            sketchybar --trigger brew_update
          fi
        }

        export XDG_CONFIG_HOME="$HOME/.config"
        export VIRTUALENVWRAPPER_PYTHON=/opt/homebrew/bin/python3
        export WORKON_HOME=$HOME/.virtualenvs
        export PROJECT_HOME=$HOME/Devel
        source /opt/homebrew/bin/virtualenvwrapper.sh

        export LESS_TERMCAP_mb=$'\e[1;32m'
        export LESS_TERMCAP_md=$'\e[1;32m'
        export LESS_TERMCAP_me=$'\e[0m'
        export LESS_TERMCAP_se=$'\e[0m'
        export LESS_TERMCAP_so=$'\e[01;33m'
        export LESS_TERMCAP_ue=$'\e[0m'
        export LESS_TERMCAP_us=$'\e[1;4;31m'

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        export PATH=$PATH:/Users/marcel.schnideritsch/.spicetify


        source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh
        source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh
      '';
    };
    direnv.enable = true;
  };
}