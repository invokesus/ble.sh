#!/bin/bash

# 本体は lib/core-syntax.sh にある。遅延読み込みする。

#------------------------------------------------------------------------------
# 公開変数

# exported variables
_ble_syntax_VARNAMES=(
  _ble_syntax_text
  _ble_syntax_lang
  _ble_syntax_stat
  _ble_syntax_nest
  _ble_syntax_tree
  _ble_syntax_attr
  _ble_syntax_attr_umin
  _ble_syntax_attr_umax
  _ble_syntax_word_umin
  _ble_syntax_word_umax
  _ble_syntax_vanishing_word_umin
  _ble_syntax_vanishing_word_umax
  _ble_syntax_dbeg
  _ble_syntax_dend)
_ble_syntax_lang=bash

function ble/syntax/initialize-vars {
  _ble_syntax_text=
  _ble_syntax_lang=bash
  _ble_syntax_stat=()
  _ble_syntax_nest=()
  _ble_syntax_tree=()
  _ble_syntax_attr=()

  _ble_syntax_attr_umin=-1 _ble_syntax_attr_umax=-1
  _ble_syntax_word_umin=-1 _ble_syntax_word_umax=-1
  _ble_syntax_vanishing_word_umin=-1
  _ble_syntax_vanishing_word_umax=-1
  _ble_syntax_dbeg=-1 _ble_syntax_dend=-1
}

#------------------------------------------------------------------------------
# 公開関数

# 関数 ble/syntax/parse は実際に import されるまで定義しない

# 関数 ble/highlight/layer:syntax/* は import されるまではダミーの実装にする

## @fn ble/highlight/layer:syntax/update (暫定)
##   PREV_BUFF, PREV_UMIN, PREV_UMAX を変更せずにそのまま戻れば良い。
function ble/highlight/layer:syntax/update { true; }
## @fn ble/highlight/layer:region/getg (暫定)
##   g を設定せず戻ればそのまま上のレイヤーに問い合わせが行く。
function ble/highlight/layer:syntax/getg { true; }


## @fn ble/syntax:bash/is-complete
##   sytax がロードされる迄は常に真値。
function ble/syntax:bash/is-complete { true; }


# 以下の関数に関しては遅延せずにその場で lib/core-syntax.sh をロードする
ble/util/autoload "$_ble_base/lib/core-syntax.sh" \
             ble/syntax/parse \
             ble/syntax/highlight \
             ble/syntax/tree-enumerate \
             ble/syntax/tree-enumerate-children \
             ble/syntax/completion-context/generate \
             ble/syntax/highlight/cmdtype \
             ble/syntax/highlight/cmdtype1 \
             ble/syntax/highlight/filetype \
             ble/syntax/highlight/getg-from-filename \
             ble/syntax:bash/extract-command \
             ble/syntax:bash/simple-word/eval \
             ble/syntax:bash/simple-word/evaluate-path-spec \
             ble/syntax:bash/simple-word/is-never-word \
             ble/syntax:bash/simple-word/is-simple \
             ble/syntax:bash/simple-word/is-simple-or-open-simple \
             ble/syntax:bash/simple-word/reconstruct-incomplete-word

#------------------------------------------------------------------------------
# 遅延読み込みの設定

# lib/core-syntax.sh の変数または ble/syntax/parse を使用する必要がある場合は、
# 以下の関数を用いて lib/core-syntax.sh を必ずロードする様にする。
function ble/syntax/import {
  ble/util/import "$_ble_base/lib/core-syntax.sh"
}
ble-import -d lib/core-syntax

#------------------------------------------------------------------------------
# グローバル変数の定義 (関数内からではできないのでここで先に定義)

bleopt/declare -v syntax_debug ''

bleopt/declare -v filename_ls_colors ''

bleopt/declare -v highlight_syntax 1
bleopt/declare -v highlight_filename 1
bleopt/declare -v highlight_variable 1
bleopt/declare -v highlight_timeout_sync 50
bleopt/declare -v highlight_timeout_async 5000

if ((_ble_bash>=40200||_ble_bash>=40000&&!_ble_bash_loaded_in_function)); then
  if ((_ble_bash>=40200)); then
    declare -gA _ble_syntax_highlight_filetype=()
    declare -gA _ble_syntax_highlight_lscolors_ext=()
  else
    declare -A _ble_syntax_highlight_filetype=()
    declare -A _ble_syntax_highlight_lscolors_ext=()
  fi
fi

builtin eval -- "${_ble_util_gdict_declare//NAME/_ble_syntax_bash_simple_eval}"
builtin eval -- "${_ble_util_gdict_declare//NAME/_ble_syntax_bash_simple_eval_full}"
