" Modification : 2016-05-17

" To avoid conflict problems {{{1
let s:saveCpoptions = &cpoptions
set cpoptions&vim
" 1}}}

" Helpers {{{1
function! s:format_file_name(word) abort " {{{2
	return a:word =~# ' .* \{5}.*' ?
				\ matchstr(a:word, '.*\ze \{5}') : a:word
endfunction
function! s:cmus_remote(cmd, candidate) abort " {{{2
	call system('cmus-remote -C ' . shellescape(a:cmd . ' ' . s:format_file_name(a:candidate)))
endfunction " 2}}}
" 1}}}

" Define initial properties of the kind {{{1
let s:cmus_unite_kind = {
			\ 'name': 'cmus',
			\ 'default_action': 'play',
			\ 'action_table': {},
			\ 'parents': []
		\ }
" 1}}}

" Define action table {{{1
let s:cmus_unite_kind.action_table = {
			\ 'play'  : {'description' : 'Play current track'},
			\ 'queue' : {
				\ 'description'   : 'Add current track(s) to queue list',
				\ 'is_selectable' : 1,
				\ 'is_quit'       : 0
			\ },
			\ 'prepend2queue' : {
				\ 'description'   : 'Prepend current track(s) to queue playlist',
				\ 'is_selectable' : 1,
				\ 'is_quit'       : 0
			\ },
		\ }
function! s:cmus_unite_kind.action_table.play.func(candidate) abort " {{{2
	call s:cmus_remote('player-play', a:candidate.word)
endfunction
function! s:cmus_unite_kind.action_table.queue.func(candidate) abort " {{{2
	for l:i in range(0, len(a:candidate) - 1)
		call s:cmus_remote('add -q', a:candidate[l:i].word)
	endfor
endfunction
function! s:cmus_unite_kind.action_table.prepend2queue.func(candidate) abort " {{{2
	for l:i in range(0, len(a:candidate) - 1)
		call s:cmus_remote('add -Q', a:candidate[l:i].word)
	endfor
endfunction " 2}}}
" 1}}}

" Define kind {{{1
function! unite#kinds#cmus#define() abort
	return s:cmus_unite_kind
endfunction
" 1}}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
" 1}}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
