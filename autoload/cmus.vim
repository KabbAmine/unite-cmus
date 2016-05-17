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

function! cmus#get() abort " {{{1
	return {
				\	'cache_dir'      : s:get_cache_dir(),
				\	'current'        : s:get_current(),
				\	'statusline_str' : function('s:statusline_str')
				\ }
endfunction
function! s:get_cache_dir() abort " {{{1
	let l:dir = exists('g:unite_cmus_cache_dir') ?
				\ g:unite_cmus_cache_dir : get(g:, 'unite_data_directory') . '/cmus'
	if !isdirectory(l:dir)
		call mkdir(l:dir)
	endif
	return l:dir
endfunction
function! s:get_current() abort " {{{1
	let l:current = systemlist('cmus-remote -Q')
	let l:artist = filter(copy(l:current), 'v:val =~# "^tag artist "')[0][11:]
	let l:title = filter(copy(l:current), 'v:val =~# "^tag title "')[0][10:]
	let l:album = filter(copy(l:current), 'v:val =~# "^tag album "')[0][10:]
	return {
				\	'artist': l:artist,
				\	'title': l:title,
				\	'album': l:album
				\ }
endfunction
function! s:statusline_str() dict " {{{1
	let l:cmusCurrent = '♬  ' . self.current.artist . ' - ' . self.current.title
	return unite#get_status_string() . l:cmusCurrent
endfunction
" 1}}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
" 1}}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
