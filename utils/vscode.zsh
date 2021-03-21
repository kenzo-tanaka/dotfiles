## ----------------------------------------
## VSCode
## code --list-extensions > ~/vsplug.txt
## ----------------------------------------
vscode-plug-install() {
  # This also updates.
  plugins=($(cat ./Vsplug))
  for plugin in ${plugins}; do
    code --install-extension ${plugin}
  done
}
vscode-plug-clean() {
  plugin=$(cat ./Vsplug | fzf)
  code --uninstall-extension ${plugin}
}
vscode-plug-list() {
  code --list-extensions > ./bundle/Vsplug
}
