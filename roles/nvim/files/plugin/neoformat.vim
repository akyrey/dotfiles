" Automatically format files on same
" augroup fmt
"  autocmd!
  " Put changes made by Neoformat into the same undo-block with the preceding change
"  autocmd BufWritePre * undojoin | Neoformat
" augroup END

