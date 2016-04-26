" Unite source for Cmus
" Creation     : 2016-04-17
" Modification : 2016-04-26

" To avoid conflict problems {{{1
let s:saveCpoptions = &cpoptions
set cpoptions&vim
" 1}}}

" Make source {{{1
let s:cmus_unite_source = {
			\ 'name': 'cmus/album',
			\ 'description': 'Play & queue cmus tracks',
			\ 'hooks': {},
			\ 'action_table': {},
			\ 'default_action': {'cmus': 'play'}
		\ }
" 1}}}

" Gather candidates {{{1
function! s:cmus_unite_source.gather_candidates(args, context) abort
	let l:src = {
				\   'files'  : [],
				\   'albums' : [],
				\ }
	let l:_ = system('cmus-remote -C "save -l -e -"')

	let l:file_exists = 0
	" Get filenames & albums
	for l:l in split(l:_, "\n")
		if l:l =~# '^file '
			if !l:file_exists
				call add(l:src.files, l:l[5:])
				let l:file_exists = 1
			else
				" In case no album tag is found
				call add(l:src.albums, '')
				call add(l:src.files, l:l[5:])
				let l:file_exists = 0
			endif
		endif
		if l:l =~# '^tag album '
			call add(l:src.albums, l:l[10:])
			let l:file_exists = 0
		endif
	endfor

	let l:m = []
	" Make the candidates: 'filename=album'
	for l:t in range(0, len(l:src.files) - 1)
		call add(l:m, l:src.files[l:t] . '=' . l:src.albums[l:t])
	endfor

	return map(l:m, '{
				\ "word"   : tr(v:val, "=", " "),
				\ "abbr"   : (
				\		fnamemodify(v:val, ":t:r") .
				\		repeat(" ", 100 - strchars(fnamemodify(v:val, ":t:r"))) .
				\		"[" . matchstr(v:val, "=.*")[1:] . "]"
				\	),
				\ "source" : "cmus",
				\ "kind"   : "cmus"
				\ }')
endfunction
" 1}}}

" Define source {{{1
function! unite#sources#cmus_album#define() abort
	return s:cmus_unite_source
endfunction
" 1}}}

" Restore default vim options {{{1
let &cpoptions = s:saveCpoptions
unlet s:saveCpoptions
" 1}}}

" vim:ft=vim:fdm=marker:fmr={{{,}}}:
