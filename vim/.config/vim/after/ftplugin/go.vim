augroup format_golang
	autocmd!
	let g:lsp_format_sync_timeout = 1000
	autocmd BufWritePre <buffer> call execute('LspDocumentFormatSync')
augroup END
