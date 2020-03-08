set number relativenumber

set clipboard=unnamed

set cursorline
set cursorcolumn

let g:python3_host_prog='~/.pyenv/shims/python'

colorscheme dracula

" Golang
let g:go_fmt_command = 'goimports'

" Neomake
let g:neomake_tempfile_dir = '~/.cache/vim/neomake%:p:h'

autocmd FileType pullrequest set fo+=t
