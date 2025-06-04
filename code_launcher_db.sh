#! /usr/bin/bash

#
# license ...
#

# https://habr.com/ru/articles/583320/
declare -la set_bash=(
  ## woozy-masta.shell-script-ide
  ## consist of:
  timonwong.shellcheck
  rogalmic.bash-debug
  foxundermoon.shell-format
  mads-hartmann.bash-ide-vscode
  tetradresearch.vscode-h2o # completion
  meronz.manpages
  Remisa.shellman # snippets
  ## formulahendry.code-runner # in utilities
  ## exiasr.hadolint # in docker
  ## jeff-hykin.better-dockerfile-syntax # in docker
  ## xshrim.txt-syntax # in docwriter or in utilities
  jeff-hykin.better-shellscript-syntax
)

declare -la set_pascal=(
  #alefragnani.pascal
  Wosi.omnipascal
  CNOC.fpdebug
  alefragnani.pascal-formatter
  #webfreak.debug #?
  #coolchyni.beyond-debug
)

declare -la set_c=(
)

declare -la set_cpp=(
  jeff-hykin.better-c-syntax
  jeff-hykin.better-cpp-syntax
  #jeff-hykin.experimental-cpp-syntax # ?
  ms-vscode.makefile-tools
  ##
  ## Project generator:
  #ACharLuk.fenix
  ## or
  danielpinto8zz6.c-cpp-project-generator
  ##
  webfreak.debug # Supports both GDB and LLDB.
  ## ms-vscode.cpptools-extension-pack
  ## consist of:
  ## 1. C/C++ for Visual Studio Code:
  ms-vscode.cpptools
  ## 2. C/C++ Extension UI Themes
  ms-vscode.cpptools-themes
  ## 3. CMake For VisualStudio Code
  twxs.cmake
  ## 4. CMake Tools
  ms-vscode.cmake-tools
  ## consist end.
)

declare -la set_mcu=(
  ms-vscode.vscode-serial-monitor
  platformio.platformio-ide
  # pioarduino.pioarduino-ide #:
  # supports the latest Arduino core for the ESP32
  # (version 3)
  # <https://randomnerdtutorials.com/\
  # vs-code-pioarduino-ide-esp32/>
  # Add the following line to the platformio.ini file:
  # platform = https://github.com/pioarduino/\
  # platform-espressif32/releases/download/\
  # stable/platform-espressif32.zip
)

declare -la set_html=(
  ecmel.vscode-html-css
  solnurkarim.html-to-css-autocompletion
  anteprimorac.html-end-tag-labels
  kamikillerto.vscode-linthtml
  # abusaidm.html-snippets
  # mkaufman.HTMLHint
  Zignd.html-css-class-completion
  ritwickdey.LiveServer
  # yandeu.five-server
)

declare -la set_css=(
  pranaygp.vscode-css-peek
  mrmlnc.vscode-scss
  # MamadOuologuem.frontone-vscode-scss
  Syler.sass-indented
  # glenn2223.live-sass
  michelemelluso.code-beautifier
  stylelint.vscode-stylelint
  diz.ecsstractor-port
  naumovs.color-highlight
  # vincaslt.highlight-matching-tag
  # deque-systems.vscode-axe-linter
  # <https://medium.com/@arslanijaz/\
  # vscode-tailwind-extensions-3c38bb2607fd>
  bradlc.vscode-tailwindcss
)

declare -la set_jsts=(
  dbaeumer.vscode-eslint
  ms-vscode.vscode-typescript-next
  ms-vscode.js-debug-nightly
  # capaj.vscode-standardjs-snippets
  # xabikos.JavaScriptSnippets
  mgmcdermott.vscode-language-babel
  humao.rest-client
  # lllllllqw.jsdoc
  # ChakrounAnas.turbo-console-log
  jeff-hykin.better-js-syntax
)

declare -la set_prettier=(
  esbenp.prettier-vscode
  tombonnike.vscode-status-bar-format-toggle
)

declare -la set_vue=(
  Vue.volar
)

# <https://code.visualstudio.com/docs/configure/profiles\
# #_angular-profile-template>
declare -la set_angular=(
)

# <https://code.visualstudio.com/docs/configure/profiles\
# #_nodejs-profile-template>
declare -la set_nodejs=(
  dbaeumer.vscode-eslint
  # ms-vscode-remote.remote-containers
  # ms-azuretools.vscode-docker
  mikestead.dotenv
  # EditorConfig.EditorConfig
  xabikos.JavaScriptSnippets
  Orta.vscode-jest
  ms-edgedevtools.vscode-edge-devtools
  christian-kohler.npm-intellisense
  humao.rest-client
  redhat.vscode-yaml
)
# This profile comes with the following settings:
# "editor.formatOnPaste": true,
# "git.autofetch": true,
# "[markdown]":  {
# "editor.wordWrap": "on"
# },
# "[json]": {
# "editor.defaultFormatter": "esbenp.prettier-vscode"
# },
# "[jsonc]": {
# "editor.defaultFormatter": "vscode.json-language-features"
# },
# "[html]": {
# "editor.defaultFormatter": "esbenp.prettier-vscode"
# },
# "[javascript]": {
# "editor.defaultFormatter": "esbenp.prettier-vscode"
# },
# "[typescript]": {
# "editor.defaultFormatter": "esbenp.prettier-vscode"

declare -la set_python=(
  ## donjayamanne.python-extension-pack
  ## consist of:
  ms-python.python #(Pylance, Python Debugger)
  # wholroyd.jinja
  # batisteo.vscode-django
  ## VisualStudioExptTeam.vscodeintellicode
  # donjayamanne.python-environment-manager
  # njpwerner.autodocstring
  # KevinRose.vsc-python-indent
  #
  # ms-toolsai.jupyter
  ## consist of:
  # ms-toolsai.jupyter-keymap
  # ms-toolsai.jupyter-renderers
  # ms-toolsai.vscode-jupyter-cell-tags
  # ms-toolsai.vscode-jupyter-slideshow
  # ms-toolsai.vscode-jupyter-powertoys #experimental 
  #
  # ms-python.vscode-python-envs #(depend ms-python.python)
  # ms-python.vscode-pylance
  # ms-python.debugpy
  # charliermarsh.ruff
  # ms-python.isort
)
# This profile also sets the following settings:
# "python.analysis.autoImportCompletions": true,
# "python.analysis.fixAll": ["source.unusedImports"],
# "editor.defaultFormatter": "charliermarsh.ruff"

declare -la set_data_science=(
  #ms-toolsai.datawrangler
  #GitHub.copilot
  ms-toolsai.jupyter
  #ms-vscode-remote.vscode-remote-extensionpack
  #charliermarsh.ruff
)
# This profile also sets the following settings:
# "[python]": {
# "editor.defaultFormatter": "charliermarsh.ruff",
# "editor.formatOnType": true,
# "editor.formatOnSave": true
# },
# "editor.inlineSuggest.enabled": true,
# "editor.lineHeight": 17,
# "breadcrumbs.enabled": false,
# "files.autoSave": "afterDelay",
# "notebook.output.scrolling": true,
# "jupyter.themeMatplotlibPlots": true,
# "jupyter.widgetScriptSources": [
# "unpkg.com",
# "jsdelivr.com"
# ],
# "files.exclude": {
# "**/.csv": true,
# "**/.parquet": true,
# "**/.pkl": true,
# "**/.xls": true
# }

declare -la set_java=(
  ## vscjava.vscode-java-pack
  ## consist of:
  redhat.java
  #vscjava.vscode-java-debug
  #vscjava.vscode-java-test
  #vscjava.vscode-maven
  #vscjava.vscode-gradle
  #vscjava.vscode-java-dependency
)

declare -la set_csharp=(
  ms-dotnettools.csharp
  ms-dotnettools.csdevkit
  #ms-dotnettools.vscode-dotnet-runtime # in combo_csharp
)

# for:
# set_csharp
# set_jsts
# set_python
# set_java
declare -la set_dotnet_runtime=(
  ms-dotnettools.vscode-dotnet-runtime
)

# for:
# set_python
# set_jsts
# set_java
declare -la set_intellicode=(
  # VisualStudioExptTeam.vscodeintellicode
  VisualStudioExptTeam.vscodeintellicode-insiders
)

# for:
# set_jsts
# set_python
declare -la set_intellicode_completions_and_api_examples=(
  VisualStudioExptTeam.vscodeintellicode-completions
  VisualStudioExptTeam.intellicode-api-usage-examples
)

declare -la set_php=(
  xdebug.php-debug
  bmewburn.vscode-intelephense-client
  zobo.php-intellisense
  neilbrayfield.php-docblocker
  junstyle.php-cs-fixer
  mrmlnc.vscode-apache
  shanoor.vscode-nginx
)

declare -la set_twig=(
  mblode.twig-language-2
)

declare -la set_sql=(
  #mtxr.sqltools
  #mtxr.sqltools-driver-pg
  #alexcvzz.vscode-sqlite
  #mtxr.sqltools-driver-sqlite
)

declare -la set_haskell=(
  #haskell.haskell
  #justusadam.language-haskell
  #sheaf.groovylambda
)

declare -la set_perl=(
  #jeff-hykin.better-perl-syntax
  ## Use a theme like one of the following
  ## to benefit from the changes:
  ## Material Theme
  ## Noctis
  ## XD Theme
  ## One Monokai Theme
  ## Winteriscoming
  ## Popping and Locking
  ## Syntax Highlight Theme
)

declare -la set_lisp=(
  #jeff-hykin.better-lisp-syntax
)

declare -la set_nix=(
  #jnoortheen.nix-ide
  #jeff-hykin.better-nix-syntax
)

declare -la set_prolog=(
  #jeff-hykin.better-prolog-syntax
)

declare -la set_go=(
  #golang.Go
  #jeff-hykin.better-go-syntax
)

declare -la set_rust=(
  ## https://open-vsx.org/extension/rust-lang/rust-analyzer
)

declare -la set_objectivec=(
  #jeff-hykin.better-objc-syntax
)

declare -la set_objectivecpp=(
  #jeff-hykin.better-objcpp-syntax
)

declare -la set_docker=(
  # Move all to set_remote_development ?
  ms-azuretools.vscode-docker
  exiasr.hadolint
  jeff-hykin.better-dockerfile-syntax
  ## Use a theme like one of the following
  ## to benefit from the changes:
  ## Material Theme
  ## Noctis
  ## XD Theme
  ## One Monokai Theme
  ## Winteriscoming
  ## Popping and Locking
  ## Syntax Highlight Theme
)

declare -la set_remote_development=(
  ## ms-vscode-remote.vscode-remote-extensionpack
  ## consist of:
  #ms-vscode-remote.remote-ssh
  #ms-vscode.remote-server
  ms-vscode-remote.remote-containers
  #ms-vscode-remote.remote-wsl
)

declare -la set_git=(
  #eamodio.gitlens
  #mhutchie.git-graph
  #github.vscode-pull-request-github
  #donjayamanne.githistory
  #huizhou.githd
  codezombiech.gitignore
  #GitHub.remotehub
  #GitHub.codespaces
  #GitHub.copilot
)

declare -la set_themes=(
  teabyii.ayu
  #arcticicestudio.nord-visual-studio-code
  #metaphore.kanagawa-vscode-color-theme
  #ahmadawais.shades-of-purple
  #wesbos.theme-cobalt2
  #johnpapa.vscode-peacock
)

declare -la set_icons=(
  # by download rating
  PKief.material-icon-theme # the best
  #Icons # by Mhammed Talhaouy # fo check
  # vscode-icons-team.vscode-icons
  # equinusocio.vsc-material-theme-icons
  #
  # emmanuelbeziat.vscode-great-icons
)

## See Semantic Colorization:
## <https://devblogs.microsoft.com/cppblog/\
## visual-studio-code-c-c-extension-july-2019-update/\
## #semantic-colorization>
## <https://marketplace.visualstudio.com/\
## items?itemName=jeff-hykin.better-syntax>
## Switch to the Dark+ theme
## or
## XD Theme
## Noctis
## Kary Pro Colors
## Material Theme
## One Monokai Theme
## Winteriscoming
## Popping and Locking
## Syntax Highlight Theme
## Default Theme Enhanced
declare -la set_better_syntax_themes=(
  ## XD Theme:
  ## optimized for syntax:
  ## C++, Dockerfile, Shell, Perl
  ## and also:
  ## (JS JSX Rust Vue JSON Python Ruby HTML C# \
  ## CoffeeScript CSS SASS YAML Markdown WASM Cython Toml)
  # jeff-hykin.xd-theme
  ## Noctis:
  #liviuschera.noctis
  ## Kary Pro Colors:
  # karyfoundation.theme-karyfoundation-themes
  ## Material Theme:
  # Equinusocio.vsc-material-theme # deprecated
  # vira.vsc-vira-theme
  ## One Monokai Theme:
  # azemoh.one-monokai
  ## Winteriscoming:
  #johnpapa.winteriscoming
  ## Popping and Locking:
  # hedinne.popping-and-locking-vscode
  ## Syntax Highlight Theme:
  # peaceshi.syntax-highlight
  ## Default Theme Enhanced:
  # ms-vscode.cpptools-themes
  ## Light Theme,
  ## Dark Theme,
  ## 2017 Light Theme,
  ## 2017 Dark Theme
)

## Doc Writer Profile Template
## <https://code.visualstudio.com/docs/editor/profiles\
## #_doc-writer-profile-template>
declare -la set_docwriter=(
  ms-vscode.wordcount
  johnpapa.read-time
  xshrim.txt-syntax
 # Doc Writer Profile Template
  # streetsidesoftware.code-spell-checker #:\
  # already in set_spelling
  # bierner.markdown-checkbox
  # bierner.markdown-emoji
  # bierner.markdown-footnotes
  # bierner.markdown-preview-github-styles
  # bierner.markdown-mermaid
  # bierner.markdown-yaml-preamble
  # DavidAnson.vscode-markdownlint
)
# This profile also sets the following settings:
# "workbench.colorTheme": "Default Light Modern",
# "editor.minimap.enabled": false,
# "breadcrumbs.enabled": false,
# "editor.glyphMargin": false,
# "explorer.decorations.badges": false,
# "explorer.decorations.colors": false,
# "editor.fontLigatures": true,
# "files.autoSave": "afterDelay",
# "git.enableSmartCommit": true,
# "window.commandCenter": true,
# "editor.renderWhitespace": "none",
# "workbench.editor.untitled.hint": "hidden",
# "markdown.validate.enabled": true,
# "markdown.updateLinksOnFileMove.enabled": "prompt",
# "workbench.startupEditor": "none"

declare -la set_markdown=(
  yzhang.markdown-all-in-one
  #
  # bierner.markdown-checkbox
  # bierner.markdown-emoji
  # bierner.markdown-footnotes
  # bierner.markdown-preview-github-styles
  # bierner.markdown-mermaid
  # bierner.markdown-yaml-preamble
  # DavidAnson.vscode-markdownlint
  #
  # shd101wyy.markdown-preview-enhanced
  #
  # DougFinke.vscode-pandoc # deprecated
  # ChrisChinchilla.vscode-pandoc
  # zaaack.markdown-editor
)

declare -la set_spelling=(
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-russian
)

declare -la set_csv=(
  jeff-hykin.better-csv-syntax
)

declare -la set_toml=(
  tamasfe.even-better-toml
)

declare -la set_path_processing=(
  christian-kohler.path-intellisense
  ionutvmi.path-autocomplete
)

declare -la set_organizing_comments_todos_bookmarks=(
  # aaron-bond.better-comments
  Gruntfuggly.todo-tree
  alefragnani.Bookmarks
  # ExodiusStudios.comment-anchors
  wayou.vscode-todo-highlight
)

## ?
declare -la set_code_documentation=(
  # PlantUML +
  # mgiesen.image-comments
  #
  lllllllqw.jsdoc
  cschlosser.doxdocgen
)

declare -la set_json=(
  richie5um2.vscode-sort-json
)

declare -la set_uml=(
  theumletteam.umlet
)

declare -la set_utilities=(
  alefragnani.project-manager
  EditorConfig.EditorConfig
  #vscode-pdf # by tomoki1207
  #Tyriar.vscode-terminal-here
  #robole.profile-status
  #natqe.reload
  #pomdtr.excalidraw-editor
  #hediet.vscode-drawio
  #adpyke.codesnap
  #deerawan.vscode-faker
  #MS-vsliveshare.vsliveshare
  #vscodevim.vim
  #formulahendry.code-runner
  ##drmerfy.overtype # deprecated
)

declare -la set_special_extensions=(
  WakaTime.vscode-wakatime
)

# End sets

# Combination of sets (combo)

declare -a combo_base=(
  #set_docker # move out
  #set_remote_development # move out
  #set_git
  #set_path_processing
  #set_organizing_comments_todos_bookmarks
  #set_json
  #
  #set_spelling
  #set_markdown
  #set_docwriter
  #
  set_utilities
  set_themes
  set_icons
  #set_special_extensions
  #set_dotnet_runtime # ! temporary !
)

declare -a combo_bash=(
  set_bash
)

declare -a combo_pascal=(
  set_pascal
)

declare -a combo_cpp=(
  set_cpp
)

declare -a combo_web_front_end=(
  set_html
  set_css
  #set_jsts
  #set_prettier 
)

declare -a combo_web_back_end=(
  set_jsts
  # set_dotnet_runtime
  set_intellicode
  set_intellicode_completions_and_api_examples
  set_nodejs
  set_prettier 
)

declare -a combo_python=(
  set_python
  set_dotnet_runtime
  set_intellicode
  set_intellicode_completions_and_api_examples
  set_data_science
)

declare -a combo_php=(
  set_php
)

declare -a combo_vue=(
  set_vue
)

declare -a combo_mcu=(
  set_cpp
  set_platformio
)

declare -a combo_haskell=(
  set_haskell
)

declare -a combo_java=(
  set_java
  set_dotnet_runtime
  set_intellicode
)

declare -a combo_go=(
  set_go
)

declare -a combo_csharp=(
  set_csharp
  set_dotnet_runtime
)

declare -a combo_perl=(
  set_perl
)

declare -a combo_lisp=(
  set_lisp
)

declare -a combo_nix=(
  set_nix
)

declare -a combo_prolog=(
  set_prolog
)

# Associative array
# combos=([language]=combo_* ...)

declare -A combos=(
  [base]=combo_base
  [bash]=combo_bash
  [pascal]=combo_pascal
  [cpp]=combo_cpp
  [frontend]=combo_web_front_end
  [backend]=combo_web_back_end
  [python]=combo_python
  # [mcu]=combo_mcu
  # [haskell]=combo_haskell
  [java]=combo_java
  # [go]=combo_go
  # [perl]=combo_perl
  # [lisp]=combo_lisp
  # [nix]=combo_nix
  # [prolog]=combo_prolog
  # [php]=combo_php
  # [vue]=combo_vue
)

return
