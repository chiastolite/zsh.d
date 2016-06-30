#zmodload zsh/zprof && zprof

export LANG=ja_JP.UTF-8
setopt no_global_rcs
typeset -U path

path=(
  $HOME/bin(N-/)
  /usr/local/bin(N-/)
  /usr/bin(N-/)
  /bin(N-/)
  /usr/sbin(N-/)
  /sbin(N-/)
  /opt/X11/bin(N-/)
  )

export PERLBREW_ROOT=$HOME/.perlbrew
export RBENV_ROOT=$HOME/.rbenv
export PHPENV_ROOT=$HOME/.phpenv
export ANDROID_HOME=/usr/local/opt/android-sdk
export JAVA_HOME="$(/usr/libexec/java_home)"
export AWS_CLOUDWATCH_HOME="/usr/local/Library/LinkedKegs/cloud-watch/jars"
export SERVICE_HOME="$AWS_CLOUDWATCH_HOME"
export GOPATH=$HOME

if which rbenv > /dev/null; then eval "$(rbenv init --no-rehash - zsh)"; fi
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
