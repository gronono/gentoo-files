# Path to your oh-my-zsh installation.
export ZSH=/home/arnaud/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="random"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  git-flow-avh
  zsh-mvn
  npm
  ruby
  my-cnx
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

zstyle ":completion:*:descriptions" format "%B%d%b"

# Autostarting X
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi

# GIT
alias git-cleanup='git remote prune origin && git branch --merged | grep -v -e "\*" -e 'master' -e 'develop' | xargs -r -n 1 git branch -d'


findjar() {
 find . -name "*.jar" -exec bash -c "echo {}: && jar tvf {} | grep $1 ; echo __DELIMITER__ " \; | awk 'BEGIN { FS="\n"; RS="\n__DELIMITER__" }; NF > 2 '
}

# Maven
mvn-getversion() {
        mvn org.apache.maven.plugins:maven-help-plugin:2.2:evaluate -Dexpression=project.version | grep -Ev '(^\[|Download\w+:)' | cut -d'-' -f 1
}
mvn-setversion() {
        mvn org.codehaus.mojo:versions-maven-plugin:2.2:set -DnewVersion=$1 -DgenerateBackupPoms=false
}
maven-clean() {
        find . -name "pom.xml" -exec mvn clean -f {} \; -print
}

# Ruby
#eval "$(rbenv init -)"

# Pour récupérer les certificats d'un serveur
ssl_certificate() {
        openssl s_client -showcerts -connect $1 < /dev/null
}

# Gentoo
alias eix-sync='sudo eix-sync'
alias emerge='sudo emerge'
alias env-update='sudo env-update'
alias eselect='sudo eselect'
alias grub-mkconfig='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias layman='sudo layman'
alias revdep-rebuild='sudo revdep-rebuild'
alias dispatch-conf='sudo dispatch-conf'
alias updatedb='sudo updatedb'

# Divers
alias weather='curl wttr.in/Noumea'

# PATH
export PATH="${PATH}:${HOME}/bin"

