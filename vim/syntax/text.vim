" Language: text
" Maintainer: Kuangyu Jing
" Latest Revision: April 15, 2020

if exists("b:current_syntax")
  finish
endif

"syntax match Label '\<\u\i\+'
"syntax match Constant '\<\d\+\>'
syntax match identifier '^\s*[\-+*>]'
syntax match comment '\<\@<!#.*$'

syntax match type '\<TODO\>'
syntax match todo '\<FIXME\>'
syntax match error '\<XXX\>'
syntax match special '\<DONE\>'

let b:current_syntax = 'text'
