set autoindent
set clipboard=unnamedplus
set expandtab
set ignorecase
set nowrap
set number
set relativenumber
set scrolloff=10
set shiftwidth=2
set smartcase
set tabstop=2
set viminfo=""

autocmd FileType * call timer_start(1, { -> execute('set shiftwidth=2 tabstop=2') })
