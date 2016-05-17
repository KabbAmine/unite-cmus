" Unite source for Cmus
" Creation     : 2016-04-17
" Modification : 2016-05-17

" To avoid conflict problems {{{1
let s:saveCpoptions = &cpoptions
set cpoptions&vim
" 1}}}

" Helpers {{{1
function! s:get(type, word) abort " {{{2
	return a:type ==# 'a' ?
				\ matchstr(a:word, ' \{5}\zs.*') : matchstr(a:word, '.*\ze \{5}')
endfunction " 2}}}
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

	let l:cacheFile = cmus#cache_dir() . '/cmus_album'

	if !filereadable(l:cacheFile) || a:context.is_redraw

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
		" Make each candidate: 'filename     album'
		for l:t in range(0, len(l:src.files) - 1)
			call add(l:m, l:src.files[l:t] . repeat(' ', 5) . l:src.albums[l:t])
		endfor

		call writefile(l:m, l:cacheFile)
	else

		let l:m = readfile(l:cacheFile)

	endif

	return map(l:m, '{
				\ "word"   : v:val,
				\ "abbr"   : (
				\		fnamemodify(s:get("f", v:val), ":t:r") .
				\		repeat(" ", 100 - strchars(fnamemodify(s:get("f", v:val), ":t:r"))) .
				\		"[" . s:get("a", v:val) . "]"
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
