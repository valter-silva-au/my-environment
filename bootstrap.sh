#!/bin/bash

set -x

REPORT="${HOME}/bootstrap.txt"

rm -f "${REPORT}"

update(){
  sudo apt-get -qq update
}

report(){
  echo "${1}" | tee -a "${REPORT}"
}

install(){
  report "installing ${1}"
  sudo apt-get -qqy install "${1}"
  if is_installed "${1}"; then
    report "${1} installed successfully!"
  fi
}

# verify if a package is installed
# return 0 if true, 1 if false
# Also informs about it in a report
is_installed() {
    dpkg -l "${1}" | grep -q ^ii \
    && report "${1} already installed, skipping." && return 0
    # return
    return 1
}

install_atom(){
  if ! is_installed atom; then
      sudo add-apt-repository -y ppa:webupd8team/atom \
      && update && install atom
  fi
}

install_google_chrome(){
  if ! is_installed google-chrome-stable; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list \
    && update && install google-chrome-stable
  fi
}

install_spotify(){
  if ! is_installed spotify-client; then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 \
    && echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list \
    && update && install spotify-client
  fi
}

install_vlc(){
  if ! is_installed vlc; then
    install vlc
  fi
}

show_report(){
  cat "${REPORT}"
}

update

install_atom
install_google_chrome
install_spotify
install_vlc

show_report
