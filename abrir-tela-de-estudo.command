#!/bin/zsh

set -eu

PROJETO="/Users/franci/Documents/Codex/2026-07-23/pesquisa-de-cursos-ia-ciberseguran-a-5/outputs/ola-mundo-c"
ARQUIVO="$PROJETO/ola_mundo.c"

if [[ ! -f "$ARQUIVO" ]]; then
  print -- "Erro: não encontrei o arquivo $ARQUIVO"
  exit 1
fi

# Abre o código-fonte em um editor que já vem no macOS.
open -a TextEdit "$ARQUIVO"

# Abre e posiciona duas janelas reais do Terminal: uma para Fastfetch e outra para o projeto.
osascript <<'APPLESCRIPT'
set projectFolder to "/Users/franci/Documents/Codex/2026-07-23/pesquisa-de-cursos-ia-ciberseguran-a-5/outputs/ola-mundo-c"
tell application "Finder" to set screenBounds to bounds of window of desktop

set leftEdge to item 1 of screenBounds
set topEdge to item 2 of screenBounds
set rightEdge to item 3 of screenBounds
set bottomEdge to item 4 of screenBounds
set splitPoint to leftEdge + ((rightEdge - leftEdge) * 0.50)
set middlePoint to topEdge + ((bottomEdge - topEdge) * 0.50)

tell application "Terminal"
  activate
  set fastfetchTab to do script "clear; /opt/homebrew/bin/fastfetch"
  set fastfetchWindow to window of fastfetchTab
  set projectTab to do script "export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin; cd " & quoted form of projectFolder & "; clear; printf 'PROJETO C: '; pwd; printf '\n--- GIT ---\n'; git status --short --branch; printf '\n--- COMPILAR E EXECUTAR ---\n'; /usr/bin/clang -Wall -Wextra -Werror -std=c17 ola_mundo.c -o ola_mundo && ./ola_mundo"
  set projectWindow to window of projectTab
  set bounds of fastfetchWindow to {splitPoint + 10, topEdge + 35, rightEdge - 10, middlePoint - 5}
  set bounds of projectWindow to {splitPoint + 10, middlePoint + 5, rightEdge - 10, bottomEdge - 10}
end tell

tell application "TextEdit"
  if exists window "ola_mundo.c" then
    set bounds of window "ola_mundo.c" to {leftEdge + 10, topEdge + 35, splitPoint - 10, bottomEdge - 10}
  end if
  activate
end tell
APPLESCRIPT
