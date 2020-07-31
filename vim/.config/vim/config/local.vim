set number relativenumber

if system('uname -s') ==? "Darwin\n"
	set clipboard=unnamed
else
	set clipboard=unnamedplus
endif

set cursorline
set cursorcolumn

let g:python3_host_prog=expand('~/.pyenv/shims/python')

colorscheme dracula

" Golang
let g:go_fmt_command = 'goimports'

" Neomake
let g:neomake_tempfile_dir = expand('~/.cache/vim/neomake%:p:h')

augroup github
	autocmd FileType pullrequest set fo+=t
augroup end!
augroup helm
	autocmd FileType helm set expandtab
augroup end!
