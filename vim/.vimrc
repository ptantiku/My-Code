"
" Original from: Bram Moolenaar <Bram@vim.org>
"

" using pathogen to load vim-bundles
call pathogen#incubate()

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" ---- INVISIBLE CHARACTERS ----
" for toggle between show invisible characters(tab,space) with \l
nmap <leader>l :set list!<CR>
" Replace invisible characters with
set listchars=tab:▸\ ,eol:$,trail:~
" set invisible characters color to barely visible
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" ------set tabwidth------
" tabstop=4 : for 4 width by one tab character
" softtabstop=4 : set 4 width of spaces as tab
" shiftwidth=4 : indent with < or > as width as 4
" Ruby Rule: use tab=2
set ts=2 sts=2 sw=2 noexpandtab

" Automatically reload vimrc when it's saved (from Vimbits)
au BufWritePost .vimrc so ~/.vimrc

" Keep search pattern on screen
" nnoremap <silent> n nzz
" nnoremap <silent> N Nzz
" nnoremap <silent> * *zz
" nnoremap <silent> # #zz
" nnoremap <silent> g* g*zz
" nnoremap <silent> g# g#zz

" Smash Escape (press jk together to switch to normal mode) 
inoremap jk <Esc>
inoremap kj <Esc>

" ----------------FOR RUBY---------------------
"  executing ruby script(when enable +ruby)
map <f5> :w <CR>:!ruby % <CR>

" Auto complete block for ruby
if !exists( "*RubyEndToken" )
	function RubyEndToken()
		let current_line = getline( '.' )
		let braces_at_end = '{\s*|\(,\|\s\|\w*|\s*\)\?$'
		let stuff_without_do = '^\s*class\|if\|unless\|begin\|case\|for\|module\|while\|until\|def'
		let with_do = 'do\s*|\(,\|\s\|\w*|\s*\)\?$'
		if match(current_line, braces_at_end) >= 0
			return "\<CR>}\<C-O>O"
		elseif match(current_line, stuff_without_do) >= 0
			return "\<CR>end\<C-O>O"
		elseif match(current_line, with_do) >= 0
			return "\<CR>end\<C-O>O"
		else
			return "\<CR>"
		endif
	endfunction
endif
imap <buffer> <CR> <C-R>=RubyEndToken()<CR>
