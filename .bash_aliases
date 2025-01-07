#!/bin/bash

alias fp='flatpak'
alias tf='terraform'

# Mike W M, 20180725:
alias grepie='grep --color=auto -irE'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ltr='ls -ltr'
alias lld='ls -ld'

# 2025-01-06
alias aws-docker="docker run --rm -it -v /code/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli:2.13.11"
