" nnoremap <C-Left> :call AfPPAlternatePluthPluth()<CR>
" nnoremap <C-Up> :call AfPPAlternate()<CR>
" inoremap <C-Left> <esc>:call AfPPAlternatePluthPluth()<CR>
" inoremap <C-Up> <esc>:call AfPPAlternate()<CR>
" Go to next occurence in global quickfix list
nnoremap <leader><C-k> :cnext<CR>zz
" Go to previous occurence in global quickfix list
nnoremap <leader><C-j> :cprev<CR>zz
" Go to next occurence in local quickfix list
nnoremap <leader>k :lnext<CR>zz
" Go to previous occurence in local quickfix list
nnoremap <leader>j :lprev<CR>zz
" Open global quickfix list
nnoremap <C-q> :call ToggleQFList(1)<CR>
" Open local quickfix list
nnoremap <leader>q :call ToggleQFList(0)<CR>

let g:akyrey_qf_l = 0
let g:akyrey_qf_g = 0

fun! ToggleQFList(global)
    if a:global
        if g:akyrey_qf_g == 1
            let g:akyrey_qf_g = 0
            cclose
        else
            let g:akyrey_qf_g = 1
            copen
        end
    else
        if g:akyrey_qf_l == 1
            let g:akyrey_qf_l = 0
            lclose
        else
            let g:akyrey_qf_l = 1
            lopen
        end
    endif
endfun
