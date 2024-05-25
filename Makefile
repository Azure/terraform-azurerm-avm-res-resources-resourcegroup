SHELL := /bin/bash

$(shell curl -H 'Cache-Control: no-cache, no-store' -sSL "https://raw.githubusercontent.com/kevball2/tfmod-scaffold/main/avmmakefile" -o avmmakefile)
-include avmmakefile