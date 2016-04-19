" Unite source for Cmus
" Creation     : 2016-04-17
" Modification : 2016-04-19

" To avoid conflict problems {{{1
let s:saveCpoptions = &cpoptions
set cpoptions&vim
" 1}}}

" Make source {{{1
let s:cmus_unite_source = {
			\ 'name': 'cmus',
			\ 'description': 'Play & queue cmus tracks',
			\ 'hooks': {},
			\ 'action_table': {},
			\ 'default_action': {'cmus': 'play'}
		\ }
" 1}}}

" Gather candidates {{{1
function! s:cmus_unite_source.gather_candidates(args, context) abort
	return map(systemlist('cmus-remote -C "save -l -"'), '{
				\ "word"    : v:val,
				\ "abbr"    : fnamemodify(v:val, ":t:r"),
				\ "source"  : "cmus",
				\ "kind"    : "cmus"
			\ }')
endfunction
" 1}}}

" Define source {{{1
function! unite#sources#cmus#define() abort
	return s:cmus_unite_source
endfunction
" 1}}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
" 1}}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
