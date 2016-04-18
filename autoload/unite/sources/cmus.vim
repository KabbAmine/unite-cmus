" Unite source for Cmus
" Creation     : 2016-04-17
" Modification : 2016-04-18

" To avoid conflict problems {{{1
let s:saveCpoptions = &cpoptions
set cpoptions&vim
" 1}}}

" Make source {{{1
let s:cmus_unite_source = {
			\ 'name': 'cmus',
			\ 'description': 'Play cmus tracks',
			\ 'hooks': {},
			\ 'action_table': {},
			\ 'default_action': {'common': 'play'}
		\ }
" 1}}}

" Gather candidates {{{1
function! s:cmus_unite_source.gather_candidates(args, context) abort
	return map(systemlist('cmus-remote -C "save -l -"'), '{
				\ "word"    : v:val,
				\ "abbr"    : fnamemodify(v:val, ":t:r"),
				\ "source"  : "cmus",
				\ "kind"    : "common"
			\ }')
endfunction
" 1}}}

" Set action table {{{1
let s:cmus_action_table = {}
let s:cmus_action_table = {
			\ 'play'  : {'description': 'Play current track'},
			\ 'queue' : {
				\ 'description'   : 'Queue current track to playlist',
				\ 'is_selectable' : 1,
				\ 'is_quit'       : 0
			\ },
		\ }
function! s:cmus_action_table.play.func(candidate) abort " {{{2
	call system('cmus-remote -C ' . shellescape('player-play ' .  a:candidate.word))
endfunction
function! s:cmus_action_table.queue.func(candidate) abort " {{{2
	for l:i in range(0, len(a:candidate) - 1)
		call system('cmus-remote -C ' . shellescape('add -q ' .  a:candidate[l:i].word))
	endfor
endfunction " 2}}}
let s:cmus_unite_source.action_table.common = s:cmus_action_table
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
