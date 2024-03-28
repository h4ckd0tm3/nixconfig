{ config, pkgs, lib, ... }:

{ 
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs = {
    git = {
      enable = true;
      userName  = "h4ckd0tm3";
      userEmail = "marcel@schnideritsch.at";
      lfs.enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
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

        alias n="nnn"
        function nnn () {
          command nnn "$@"

          if [ -f "$NNN_TMPFILE" ]; then
                  . "$NNN_TMPFILE"
          fi
        }

        function zen () {
          ~/.config/sketchybar/plugins/zen.sh $1
        }

        function suyabai () {
          SHA256=$(shasum -a 256 /opt/homebrew/bin/yabai | awk "{print \$1;}")
          if [ -f "/private/etc/sudoers.d/yabai" ]; then
            sudo sed -i ''\'''\' -e 's/sha256:[[:alnum:]]*/sha256:''\'''${SHA256}'/' /private/etc/sudoers.d/yabai
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

        # Color Scheme
        export BLACK=0xff1F2229
        export WHITE=0xffE6E6E6
        export RED=0xffBF2E5D
        export GREEN=0xff5EBDAB
        export BLUE=0xff367BF0
        export YELLOW=0xffFEA44C
        export ORANGE=0xfff5a97f
        export MAGENTA=0xffBF2E5D
        export GREY=0xff939ab7
        export TRANSPARENT=0x00000000
        export BG0=0xff2c2e34
        export BG1=0x603c3e4f
        export BG2=0x60494d64

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
      '';
    };
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      font.name = "Hack Nerd Font Mono";
      font.size = 13;
      keybindings = {
        "cmd+1" = "goto_tab 1";
        "cmd+2" = "goto_tab 2";
        "cmd+3" = "goto_tab 3";
        "cmd+4" = "goto_tab 4";
        "cmd+5" = "goto_tab 5";
        "cmd+6" = "goto_tab 6";
        "cmd+7" = "goto_tab 7";
        "cmd+8" = "goto_tab 8";
        "cmd+9" = "goto_tab 9";
        "cmd+0" = "goto_tab 10";
        "cmd+t" = "launch --type=tab --cwd=current";
        "cmd+n" = "launch --type=os-window --cwd=current";
        # jump to beginning and end of word
        "alt+left"  = "send_text all \\x1b\\x62";
        "alt+right" = "send_text all \\x1b\\x66";

        # jump to beginning and end of line
        "cmd+left"  = "send_text all \\x01";
        "cmd+right" = "send_text all \\x05";
      };
      settings = {
        bold_font        = "Hack Nerd Font Mono Bold";
        italic_font      = "Hack Nerd Font Mono Italic";
        bold_italic_font = "Hack Nerd Font Mono Bold Italic";
        hide_window_decorations = "titlebar-only";
        window_margin_width = 4;
        cursor_blink_interval = 0;
        macos_quit_when_last_window_closed = "no";
        macos_colorspace = "default";
        macos_show_window_title_in = "window";
        repaint_delay = 8;
        input_delay = 1;
        resize_draw_strategy = "blank";
        remember_window_size = "no";
        confirm_os_window_close = -2;

        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_activity_symbol ="";
        tab_title_max_length = 30;
        tab_title_template = "{fmt.fg.red}{bell_symbol}{fmt.fg.tab} {index}: ({tab.active_oldest_exe}) {title} {activity_symbol}";

        # OS Window titlebar colors
        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";
      };
      extraConfig = ''
        resize_debounce_time 0.001
        background_opacity 0.9
        symbol_map U+F0001-U+F1af0 Hack Nerd Font
        symbol_map U+F8FF,U+100000-U+1018C7 SF Pro

        # Color Theme: Flat Remix
        color0  #1F2229
        color1  #D41919
        color2  #5EBDAB
        color3  #FEA44C
        color4  #367BF0
        color5  #BF2E5D
        color6  #49AEE6
        color7  #E6E6E6
        color8  #8C42AB
        color9  #EC0101
        color10 #47D4B9
        color11 #FF8A18
        color12 #277FFF
        color13 #D71655
        color14 #05A1F7
        color15 #FFFFFF
        background #272A34
        foreground #FFFFFF

        cursor #FFFFFF
        cursor_text_color #1E1E2E

        selection_background #F5E0DC
        selection_foreground #1E1E2E

        active_tab_font_style bold
        inactive_tab_font_style normal
      '';
    };

    direnv.enable = true;
  };
}