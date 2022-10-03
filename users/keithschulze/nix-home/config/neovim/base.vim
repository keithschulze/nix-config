" Init
filetype on

autocmd FileType * setlocal formatoptions-=r formatoptions-=o

" Remove whitespaces on save
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()



" Options
syntax on
filetype plugin indent on

set timeout timeoutlen=1000 ttimeoutlen=10

" basic options
" set autochdir
set laststatus=2                  " always show the status line
set cmdheight=2                   " and use a two-line tall status line
set showcmd                       " show the command
set noshowmode                    " don't show the mode, vim-airline will do that for us
set autoindent                    " turns it on
set cursorline
set smartindent                   " does the right thing (mostly) in programs
set linespace=3                   " prefer a slight higher line height
set linebreak                     " wrap intelligently, won't insert hard line breaks
set wrap                          " use line wrapping
set textwidth=79                  " at column 79
set ruler                         " display current cursor position
set list                          " show invisible characters
set showmatch                     " show matching brackets
" set relativenumber                " use relative line numbers
set number                        " except for the current line - absolute number there
set mouse=a
set mousehide                     " hide mouse when typing
set foldenable                    " enable code folding
set history=1000
set ffs=unix,mac,dos              " default file types
set autoread                      " automatically update file when editted outside of vim
set noerrorbells visualbell t_vb= " no bell

" Setup automatic text formatting/wrapping (previously: grn1 )
set formatoptions=
set formatoptions-=t              " don't autowrap text
set formatoptions+=c              " do autowrap comments
set formatoptions+=r              " automatically continue comments
set formatoptions+=o              " automatically continue comments when hitting 'o' or 'O'
set formatoptions+=q              " allow formating of comments with 'gq'
set formatoptions+=n              " recognize numbered lists
set formatoptions+=l              " don't break long lines that were already there

" Set tab stuff
set tabstop=2           " 2 spaces for a tab
set shiftwidth=2        " 2 spaces for autoindenting
set softtabstop=2       " when <BS>, pretend a tab is removed even if spaces
set expandtab           " expand tabs to spaces (overloadable by file type)

set autoread            " reload files changed on disk, i.e. via `git checkout`
set hidden              " switch beteen buffers without saving

set clipboard=unnamed   " yank and paste with the system clipboard

set gdefault            " apply substitutions globally by default. add `g` for old behavior
set hlsearch            " highlight search results
set ignorecase          " ignore case when searching
set smartcase           " ignore case if search string is all lower case, case-sensitve otherwise

if exists('&inccommand')
  set inccommand=split
endif


" Style
syntax enable
set background=dark

" Indent guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

if (!has("nvim"))
  if (empty($TMUX))
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  else
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  endif
endif

"if theme supports true colour
if (has("termguicolors"))
  set termguicolors
endif


" Nord options
" let g:nord_italic = 1
" let g:nord_italic_comments = 1
" let g:nord_underline = 1

let &fcs='eob: '
" colorscheme nord

" Tokyo Night
let g:tokyonight_style = "storm"
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = [ "qf", "vista_kind", "terminal", "packer" ]
let g:lightline = {'colorscheme': 'tokyonight'}

colorscheme tokyonight

" Keybindings

:let mapleader = "\<Space>"

" Move line(s) up or down via C-j and C-k respectively

" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
" inoremap <C-j> <ESC>:m .+1<CR>==gi
" inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Tab navigation
nnoremap ‘ :bnext<CR> " alt-right-square-bracket
nnoremap “ :bprevious<CR> " alt-left-square-bracket
nnoremap ≈ :bp\|bd #<CR> " alt-x

" use <C>hjkl to switch between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" also space hjkl
nnoremap <Leader>h <C-w>h<CR>
nnoremap <Leader>l <C-w>l<CR>
nnoremap <Leader>j <C-w>j<CR>
nnoremap <Leader>k <C-w>k<CR>

nnoremap Q <nop>

" fix Vim's regex handling
nnoremap / /\v
vnoremap / /\v


" remap esc to something that is faster
imap fd <esc>
imap jk <esc>
vno v <esc>


" project
nnoremap <silent> <leader>pt :NERDTreeToggle<CR>   " open a horizontal split and switch to it (,h)
nnoremap <silent> <leader>pF :NERDTreeFind<CR>   " open a horizontal split and switch to it (,h)
nnoremap <leader>pf :GitFiles<CR>
nnoremap <leader>pr :History<CR>
nnoremap <leader>s/ :Rg<CR>

" window
nnoremap <leader>wv <C-w>v<C-w>l   " split vertically
nnoremap <leader>wh <C-w>s<C-w>j   " split horizontally

" Telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" buffer
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bc :BD<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>

nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gl :Commits<CR>

" mode keybindings are inside each langs file

"" Wiki
let g:vimwiki_list = [{'path': '~/Documents/notes/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags': 1, 'auto_diary_index': 1},
                     \{'path': '~/Documents/wiki/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags': 1}]

let g:nv_search_paths = ['~/Documents/notes/']

" Filename format. The filename is created using strftime() function
let g:zettel_format = "%y%m%d-%H%M"

let g:zettel_fzf_command = "rg --column --line-number --ignore-case --no-heading --color=always "

" Set template and custom header variable for the second Wiki
" let g:zettel_options = [{"front_matter" : {"tags" : ""}, "template" :  "./vimztl.tpl"},{}]

nnoremap <leader>sn/ :NV<CR>

nnoremap <leader>zn :ZettelNew<space>
nnoremap <leader>z<leader>i :ZettelGenerateLinks<CR>
nnoremap <leader>z<leader>t :ZettelGenerateTags<CR>

