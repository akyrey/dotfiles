" Searches for the string under your cursor in your current working directory
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" Fuzzy search through the output of git ls-files command, respects .gitignore, optionally ignores untracked files
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
" Lists files in your current working directory, respects .gitignore
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
" Searches for the string under your cursor in your current working directory
nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
" Lists open buffers in current neovim instance
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
" Lists available help tags and opens a new window with the relevant help info on <cr>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>
" Search by tree-sitter symbols
nnoremap <leader>pt :lua require('telescope.builtin').treesitter()<CR>
