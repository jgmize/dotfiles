set nocompatible

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'kchmck/vim-coffee-script'
Bundle 'drichard/vim-brunch'
"Bundle 'taglist-plus' "uncomment if exuberant-ctags installed
Bundle 'vcscommand.vim'
Bundle 'SuperTab'
Bundle 'nginx.vim'
Bundle 'iptables'
Bundle 'Gundo'
Bundle 'Jinja'
Bundle 'vim-stylus'
Bundle 'vimwiki'
Bundle 'SudoEdit.vim'
Bundle 'ack.vim'
Bundle 'jgmize/salt-vim'
Bundle 'bufexplorer.zip'
Bundle 'vim-scripts/Rename'
Bundle 'fugitive.vim'
Bundle 'tpope/vim-fireplace'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'guns/vim-clojure-static'
Bundle 'slimv.vim'
Bundle 'hylang/vim-hy'
Bundle 'ivanov/vim-ipython'
Bundle 'vim-scripts/vim-less'
Bundle 'tpope/vim-speeddating'
Bundle 'jceb/vim-orgmode'
Bundle 'utl.vim'

filetype plugin on

syntax on
set bg=dark
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set laststatus=2
set wildchar=<Tab>
set wildmenu
set whichwrap=h,l
set formatoptions=l
set lbr
set modeline
"use X11 clipboard
set clipboard=unnamedplus
"Highlight search
"set hlsearch
"incremental search
set incsearch
if !has('nvim')
    set mouse=a
    set ttymouse=xterm2
endif

" Enable rainbow parentheses for all buffers
augroup rainbow_parentheses
  au!
  au VimEnter * RainbowParenthesesActivate
  au BufEnter * RainbowParenthesesLoadRound
  au BufEnter * RainbowParenthesesLoadSquare
  au BufEnter * RainbowParenthesesLoadBraces
augroup END
 

if version > 700
    autocmd FileType python set omnifunc=pythoncomplete#Complete
"    autocmd FileType python let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
endif

autocmd BufRead *.js set tabstop=2
autocmd BufRead *.js set softtabstop=2
autocmd BufRead *.js set shiftwidth=2

autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufRead *.py set tabstop=4
autocmd BufRead *.py set softtabstop=4
autocmd BufRead *.py set shiftwidth=4
autocmd BufRead *.py set foldmethod=indent
autocmd BufRead *.py set foldlevel=99
autocmd BufRead *.py map <s-c-D> Oimport ipdb; ipdb.set_trace()<esc>
autocmd BufRead *.py map! <s-c-D> iimport ipdb; ipdb.set_trace()

set tags +=$HOME/.vim/tags/python.ctags

" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

function <SID>PythonGrep(tool)
  set lazyredraw
  " Close any existing cwindows.
  cclose
  let l:grepformat_save = &grepformat
  let l:grepprogram_save = &grepprg
  set grepformat&vim
  set grepformat&vim
  let &grepformat = '%f:%l:%m'
  if a:tool == "flake8"
    let &grepprg = 'flake8'
  elseif a:tool == "pep8"
    let &grepprg = 'pep8 -r'
  elseif a:tool == "pylint"
    let &grepprg = 'pylint --output-format=parseable --reports=n'
  elseif a:tool == "pyflakes"
    let &grepprg = 'pyflakes'
  elseif a:tool == "pychecker"
    let &grepprg = 'pychecker --quiet -q'
  else
    echohl WarningMsg
    echo "PythonGrep Error: Unknown Tool"
    echohl none
  endif
  if &readonly == 0 | update | endif
  silent! grep! %
  let &grepformat = l:grepformat_save
  let &grepprg = l:grepprogram_save
  let l:mod_total = 0
  let l:win_count = 1
  " Determine correct window height
  windo let l:win_count = l:win_count + 1
  if l:win_count <= 2 | let l:win_count = 4 | endif
  windo let l:mod_total = l:mod_total + winheight(0)/l:win_count |
        \ execute 'resize +'.l:mod_total
  " Open cwindow
  execute 'belowright copen '.l:mod_total
  nnoremap <buffer> <silent> c :cclose<CR>
  set nolazyredraw
  redraw!
endfunction

function! s:ExecuteInShell(command, bang)
    let _ = a:bang != '' ? s:_ : a:command == '' ? '' : join(map(split(a:command), 'expand(v:val)'))

    if (_ != '')
        let s:_ = _
        let bufnr = bufnr('%')
        let winnr = bufwinnr('^' . _ . '$')
        silent! execute  winnr < 0 ? 'new ' . fnameescape(_) : winnr . 'wincmd w'
        setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap
        silent! :%d
        let message = 'Execute ' . _ . '...'
        call append(0, message)
        echo message
        silent! 2d | resize 1 | redraw
        silent! execute 'silent! %!'. _
        silent! execute 'resize ' . line('$')
        silent! execute 'syntax on'
        silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr . ') . ''wincmd w'''
        silent! execute 'autocmd BufEnter <buffer> execute ''resize '' .  line(''$'')'
        silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
        silent! execute 'nnoremap <silent> <buffer> <LocalLeader>g :execute bufwinnr(' . bufnr . ') . ''wincmd w''<CR>'
        silent! syntax on
    endif
endfunction

command! -complete=shellcmd -nargs=* -bang Shell call s:ExecuteInShell(<q-args>, '<bang>')
cabbrev shell Shell

" Taglist
nnoremap <silent> <F2> :TlistToggle<CR>

"NERDTree and file browsing
"nnoremap <silent> <F3> :NERDTreeToggle<CR>
"let g:netrw_list_hide=".*\.pyc$"

if ( !hasmapto('<SID>PythonGrep(flake8)') && (maparg('<F8>') == '') )
  map <F8> :call <SID>PythonGrep('flake8')<CR>
  map! <F8> :call <SID>PythonGrep('flake8')<CR>
else
  if ( !has("gui_running") || has("win32") )
    echo "Python flake8 Error: No Key mapped.\n".
          \ "<F8> is taken and a replacement was not assigned."
  endif
endif

" based on:
"    http://vim.1045645.n5.nabble.com/editing-Python-files-how-to-keep-track-of-class-membership-td1189290.html

function! s:get_last_python_class()
    let l:retval = ""
    let l:last_line_declaring_a_class = search('^\s*class', 'bnW')
    let l:last_line_starting_with_a_word_other_than_class = search('^\ \(\<\)\@=\(class\)\@!', 'bnW')
    if l:last_line_starting_with_a_word_other_than_class < l:last_line_declaring_a_class
        let l:nameline = getline(l:last_line_declaring_a_class)
        let l:classend = matchend(l:nameline, '\s*class\s\+')
        let l:classnameend = matchend(l:nameline, '\s*class\s\+[A-Za-z0-9_]\+')
        let l:retval = strpart(l:nameline, l:classend, l:classnameend-l:classend)
    endif
    return l:retval
endfunction

function! s:get_last_python_def()
    let l:retval = ""
    let l:last_line_declaring_a_def = search('^\s*def', 'bnW')
    let l:last_line_starting_with_a_word_other_than_def = search('^\ \(\<\)\@=\(def\)\@!', 'bnW')
    if l:last_line_starting_with_a_word_other_than_def < l:last_line_declaring_a_def
        let l:nameline = getline(l:last_line_declaring_a_def)
        let l:defend = matchend(l:nameline, '\s*def\s\+')
        let l:defnameend = matchend(l:nameline, '\s*def\s\+[A-Za-z0-9_]\+')
        let l:retval = strpart(l:nameline, l:defend, l:defnameend-l:defend)
    endif
    return l:retval
endfunction

function! s:compose_python_location()
    let l:pyloc = s:get_last_python_class()
    if !empty(pyloc)
        let pyloc = pyloc . "."
    endif
    let pyloc = pyloc . s:get_last_python_def()
    return pyloc
endfunction

function! <SID>EchoPythonLocation()
    echo s:compose_python_location()
endfunction

command! PythonLocation :call <SID>EchoPythonLocation()
nnoremap <Leader>? :PythonLocation<CR>
