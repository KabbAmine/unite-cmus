" CREATION     : 2016-05-17
" MODIFICATION : 2016-05-17

" Vim options {{{1
if exists('g:cmus_loaded')
    finish
endif
let g:cmus_loaded = 1

" To avoid conflict problems.
let s:saveCpoptions = &cpoptions
set cpoptions&vim
" 1}}}

function! cmus#cache_dir() abort " {{{1
	let l:dir = exists('g:unite_cmus_cache_dir') ?
				\ g:unite_cmus_cache_dir : get(g:, 'unite_data_directory') . '/cmus'
	if !isdirectory(l:dir)
		call mkdir(l:dir)
	endif
	return l:dir
endfunction
" 1}}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
" 1}}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
