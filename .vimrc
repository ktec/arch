" ############################################################################ "
"                         vimrc by Keith
" ############################################################################ "

" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'                     " Git plugin
Plugin 'scrooloose/nerdtree'                    " A tree explorer plugin for vim
Plugin 'tpope/vim-surround'                     " quoting/parenthesizing made simple
Plugin 'kien/ctrlp.vim'                         " Fuzzy file, buffer, mru, tag, etc finder
Plugin 'bling/vim-airline'                      " Lean & mean status/tabline for vim that’s light as air
Plugin 'mattn/emmet-vim'                        " Emmet for Vim
Plugin 'othree/html5.vim'                       " HTML5 autocomplete and syntax
Plugin 'hail2u/vim-css3-syntax'                 " Vim syntax file for SCSS and improved CSS syntax highlighting
Plugin 'tpope/vim-rails'                        " Ruby on Rails power tools
Plugin 'tomtom/tcomment_vim'                    " An extensible & universal comment vim-plugin that also handles embedded filetypes
Plugin 'scrooloose/syntastic'                   " Syntax check hacks for Vim
Plugin 'rking/ag.vim'                           " Vim plugin to search using the silver searcher (ag)
Plugin 'cespare/vim-toml'                       " Syntax highlighting for TOML files
Plugin 'Shougo/neocomplete.vim'                 " Code completion engine
Plugin 'tpope/vim-endwise'                      " Wisely add “end” in Ruby
Plugin 'Raimondi/delimitMate'                   " Add closing delimiters automagically
Plugin 'christoomey/vim-tmux-navigator'         " Seamless navigation between tmux panes and splits
Plugin 'nginx.vim'                              " Nginx config syntax highlighting
Plugin 'pangloss/vim-javascript'                " Improves JavaScript syntax and indenting
Plugin 'mxw/vim-jsx'                            " Syntax highlighting and indenting for jsx
Plugin 'matchit.zip'                            " Extend % matching to support more than one character
Plugin 'elixir-lang/vim-elixir'                 " Syntax highlighting for Elixir

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" ############################################################################ "
"                           General Configurations
" ############################################################################ "

set hlsearch                                    " Highlight all search results
set incsearch                                   " Searches for strings incrementally
set scrolloff=3                                 " Give a margin around searches and movement

set autoindent                                  " Naïve indenting
set smartindent                                 " Smart indenting for C-like languages
set shiftwidth=2                                " Number of auto-indent spaces
set softtabstop=2                               " Number of spaces to make a Tab
set tabstop=2                                   " Number of spaces used per Tab
set smarttab                                    " Enable smart-tabs
set expandtab                                   " Replace tabs with spaces
set list listchars=tab:\ \ ,trail:·             " Display tabs and trailing spaces visually

set number                                      " Show line numbers
set ruler                                       " Show row and column ruler information
set nowrap                                      " No line wrapping
set backspace=indent,eol,start                  " Fix backspace for insert mode
set confirm                                     " Require confirmation before closing
set cursorline                                  " Highlight the current line
" let &colorcolumn=join(range(81, 512), ",")      " puts thick boundary after the 80 character line

" hi CursorLine   cterm=NONE ctermbg=darkgrey guibg=darkgrey
" hi CursorColumn cterm=NONE ctermbg=darkgrey guibg=darkgrey
" hi ColorColumn  cterm=NONE ctermbg=darkgrey guibg=darkgrey

set regexpengine=1                              " Force Vim to use the old Regex Engine, significantly improve performance (see https://bugs.archlinux.org/task/36693)

set fillchars+=vert:\ |                         " Remove the ugly vertical split character

syntax enable                                   " Enable syntax highlighting
set encoding=utf-8
set termencoding=utf-8

set background=dark
let g:solarized_termtrans = 1
colorscheme solarized
highlight clear SignColumn

set wildmode=longest,list                       " Tab completion shows the list of potential matches

set visualbell                                  " Turn off error bell
set shell=/bin/sh                               " Vim’s default shell

" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

set undolevels=1000                             " Because 100 isn’t enough
set noswapfile                                  " Turn off swap files
set nobackup
set nowb

" Because color matters
autocmd BufRead,BufNewFile *eslintrc,*jshintrc,*bowerrc set filetype=json
autocmd BufRead,BufNewFile *Guardfile,*pryrc set filetype=ruby
autocmd BufRead,BufNewFile *Procfile set filetype=yaml
autocmd BufRead,BufNewFile *Makefile set noexpandtab
" Add ES6 syntax highlighting for .es6 files
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" ############################################################################ "
"                             Custom Functions
" ############################################################################ "


" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction


function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic error location panel
        Errors
    endif
endfunction


" ############################################################################ "
"                         Plugin Configurations
" ############################################################################ "


" ====[ nginx ]====
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif


" ====[ CtrlP ]====
let g:ctrlp_by_filename = 1                                 " Grep by filename by default
let g:ctrlp_switch_buffer = 0
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" ====[ Ag ]====
let g:ag_highlight = 1

" ====[ Syntastic ]====
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1                " Populate the locations list with the warnings
let g:syntastic_check_on_open = 1                           " Run Syntastic when opening a file
let g:syntastic_check_on_wq = 0                             " Skip Syntastic when closing a file
let g:syntastic_html_tidy_ignore_errors=["proprietary attribute", "trimming empty", "<form> lacks \"action\"", "> is not recognized!", "discarding unexpected", "<img> lacks \"src\""]
let g:syntastic_javascript_checkers = ['eslint']

" ====[ Airline ]====
" see: https://coderwall.com/p/yiot4q/setup-vim-powerline-and-iterm2-on-mac-os-x
set laststatus=2                                            " Enable the Airline in single Vim panes
let g:airline_powerline_fonts = 1                           " Enable Powerline fonts

" ====[ Emmet ]====
autocmd BufEnter * call EnableEmmetIfHtml()                 " Optionally enable intelligent Emmet expansion

function EnableEmmetIfHtml()
  if &ft =~ 'html' || &ft =~ 'eruby' || &ft =~ 'javascript'
    imap <expr><C-e> emmet#expandAbbrIntelligent("\<Tab>")
  else
    imap <expr><C-e> "\<C-e>"
  endif
endfunction

" ====[ Neocomplete ]====
let g:acp_enableAtStartup = 0                                 " Disable default auto-complete
let g:neocomplete#enable_at_startup = 1                       " Use neocomplete
let g:neocomplete#enable_smart_case = 1                       " Use smartcase
let g:neocomplete#sources#syntax#min_keyword_length = 3       " Set minimum syntax keyword length
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"       " Enable tab completion for neocomplete
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"   " Tab completion in reverse

" ====[ Tmux Navigator ]====
let g:tmux_navigator_no_mappings = 1


" ############################################################################ "
"                             Custom Key Bindings
" ############################################################################ "
"
" NOTE: The trailing pipes just allow the comments on the right without
" messing up the commands


let mapleader = ","|                                                      " Change the leader key

nnoremap 0 ^|                                                             " Swap keys 0 -> ^
nnoremap ^ 0|                                                             " Swap keys ^ -> 0

nnoremap K 3k|                                                            " Faster vertical movement, because life is short
nnoremap J 3j|                                                            " Faster vertical movement, because life is short

nnoremap <Leader>w :%s/\s\+$<CR><C-o>:nohlsearch<CR>|                     " Clear all trailing whitespaces

nnoremap <Leader>gg :Ag ""<Left>|                                         " Recursively grep for text matches in all files under the current directory
vnoremap <Leader>gg <Esc>:Ag "<C-r>=GetVisual()<CR>"<Left>|               " Same as above, but using the selected text
nnoremap <Leader>gf :AgFile ""<Left>|                                     " Recursively grep for file matches in the current directory
vnoremap <Leader>gf <Esc>:AgFile "<C-r>=GetVisual()<CR>"<Left>|           " Same as above, but using the selected text

let g:ctrlp_map = '<Leader>t'|                                            " Shortcut for CtrlP
nnoremap <Leader>t :CtrlP<CR>|                                            " Same as above, but prevents remapping
nnoremap <Leader>b :CtrlPBuffer<CR>|                                      " Shortcut for CtrlPBuffer

nnoremap <Leader>n :nohlsearch<CR>|                                       " Clear search highlighting
nnoremap <Leader>s *N|                                                    " Search for the word under the cursor
vnoremap <Leader>s <Esc>/<C-r>=GetVisual()<CR><CR>N|                      " Search for the current selection
nnoremap <Leader>r *N:%s///gc<Left><Left><Left>|                          " Search and replace word under the cursor
vnoremap <Leader>r <Esc>:%s/<C-r>=GetVisual()<CR>//gc<Left><Left><Left>|  " Search and replace selection
nnoremap <Leader>c *Nce|                                                  " Search for the word under the cursor and change current word

nnoremap <Leader>d /\<<C-r>=expand('<cword>')<CR>\>

nnoremap <C-l> :TmuxNavigateRight<CR>|                                    " Shortcut to switch to right pane
nnoremap <C-h> :TmuxNavigateLeft<CR>|                                     " Shortcut to switch to left pane
nnoremap <C-j> :TmuxNavigateDown<CR>|                                     " Shortcut to switch to bottom pane
nnoremap <C-k> :TmuxNavigateUp<CR>|                                       " Shortcut to switch to top pane

nnoremap <Leader>p :set invpaste paste?<CR>|                              " Toggle paste mode
nnoremap <Leader>l :<C-u>call ToggleErrors()<CR>|                         " Toggle locations list

nnoremap vv :vsplit<CR>|                                                  " Shortcut for :vsplit
nnoremap ss :split<CR>|                                                   " Shortcut for :split

" ====[ Ruby Helpers ]====
nnoremap <Leader>RA :! bundle exec rspec<CR>|                             " Run all specs
nnoremap <Leader>RR :! bundle exec rspec %<CR>|                           " Run the current spec

" ====[ JavaScript Helpers ]====
nnoremap <Leader>KK :! karma start --single-run<CR>|                      " Run the karma start task with the single run option
nnoremap <Leader>KR :! karma run<CR>|                                     " Run the karma run task

" ====[ Teaching Aids ]====
noremap <Left> :throw " Vim Tip #1: Use “h” to navigate left"<CR>
noremap <Right> :throw " Vim Tip #2: Use “l” to navigate right"<CR>
noremap <Up> :throw " Vim Tip #3: Use “k” to navigate upwards"<CR>
noremap <Down> :throw " Vim Tip #4: Use “j” to navigate down"<CR>

inoremap <Left> <C-o>:throw " Vim Tip #5: Always leave insert mode before trying to navigate"<CR>
inoremap <Right> <C-o>:throw " Vim Tip #5: Always leave insert mode before trying to navigate"<CR>
inoremap <Up> <C-o>:throw " Vim Tip #5: Always leave insert mode before trying to navigate"<CR>
inoremap <Down> <C-o>:throw " Vim Tip #5: Always leave insert mode before trying to navigate"<CR>

" ====[ Move Lines ]====
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
