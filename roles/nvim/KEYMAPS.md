# Keymap reference

Every keymap inherited from the old LazyVim setup. The config carries **all** of
them, so this is a pruning list, not a todo: tick `[x]` for keep, leave `[ ]` for
drop, then remove the unticked ones from `files/lua/core/keymaps.lua` (first
section) or the relevant plugin spec's `keys = {}` (second section).

Keymaps that were already in the hand-written config are not listed - they all
carried over unchanged.

## <A-*>

- [ ] `<A-j>` (n) — Move Down
- [ ] `<A-k>` (n) — Move Up
- [ ] `<A-j>` (i) — Move Down
- [ ] `<A-k>` (i) — Move Up
- [ ] `<A-j>` (v) — Move Down
- [ ] `<A-k>` (v) — Move Up

## <C-*>

- [ ] `<C-h>` (n) — Go to Left Window
- [ ] `<C-j>` (n) — Go to Lower Window
- [ ] `<C-k>` (n) — Go to Upper Window
- [ ] `<C-l>` (n) — Go to Right Window
- [ ] `<C-Up>` (n) — Increase Window Height
- [ ] `<C-Down>` (n) — Decrease Window Height
- [ ] `<C-Left>` (n) — Decrease Window Width
- [ ] `<C-Right>` (n) — Increase Window Width
- [ ] `<C-s>` (ixns) — Save File

## <S-*>

- [ ] `<S-h>` (n) — Prev Buffer
- [ ] `<S-l>` (n) — Next Buffer

## <leader>-

- [ ] `<leader>-` (n) — Split Window Below

## <leader><

- [ ] `<leader><tab>l` (n) — Last Tab
- [ ] `<leader><tab>o` (n) — Close Other Tabs
- [ ] `<leader><tab>f` (n) — First Tab
- [ ] `<leader><tab><tab>` (n) — New Tab
- [ ] `<leader><tab>]` (n) — Next Tab
- [ ] `<leader><tab>d` (n) — Close Tab
- [ ] `<leader><tab>[` (n) — Previous Tab

## <leader>K

- [ ] `<leader>K` (n) — Keywordprg

## <leader>L

- [ ] `<leader>L` (n) — LazyVim Changelog

## <leader>`

- [ ] `<leader>`` (n) — Switch to Other Buffer

## <leader>b

- [ ] `<leader>bb` (n) — Switch to Other Buffer
- [ ] `<leader>bd` (n) — Delete Buffer
- [ ] `<leader>bo` (n) — Delete Other Buffers
- [ ] `<leader>bi` (n) — Delete Invisible Buffers
- [ ] `<leader>bD` (n) — Delete Buffer and Window

## <leader>c

- [ ] `<leader>cf` (nx) — Format
- [ ] `<leader>cd` (n) — Line Diagnostics

## <leader>f

- [ ] `<leader>fn` (n) — New File
- [ ] `<leader>fT` (n) — Terminal (cwd)
- [ ] `<leader>ft` (n) — Terminal (Root Dir)

## <leader>g

- [ ] `<leader>gg` (n) — Lazygit (Root Dir)
- [ ] `<leader>gG` (n) — Lazygit (cwd)
- [ ] `<leader>gL` (n) — Git Log (cwd)
- [ ] `<leader>gb` (n) — Git Blame Line
- [ ] `<leader>gf` (n) — Git Current File History
- [ ] `<leader>gl` (n) — Git Log
- [ ] `<leader>gB` (nx) — Git Browse (open)
- [ ] `<leader>gY` (nx) — Git Browse (copy)

## <leader>l

- [ ] `<leader>l` (n) — Lazy

## <leader>q

- [ ] `<leader>qq` (n) — Quit All

## <leader>u

- [ ] `<leader>ur` (n) — Redraw / Clear hlsearch / Diff Update
- [ ] `<leader>ui` (n) — Inspect Pos
- [ ] `<leader>uI` (n) — Inspect Tree

## <leader>w

- [ ] `<leader>wd` (n) — Delete Window

## <leader>x

- [ ] `<leader>xl` (n) — Location List
- [ ] `<leader>xq` (n) — Quickfix List

## <leader>|

- [ ] `<leader>|` (n) — Split Window Right

## [  (prev)

- [ ] `[b` (n) — Prev Buffer
- [ ] `[q` (n) — Previous Quickfix
- [ ] `[d` (n) — Prev Diagnostic
- [ ] `[e` (n) — Prev Error
- [ ] `[w` (n) — Prev Warning

## ]  (next)

- [ ] `]b` (n) — Next Buffer
- [ ] `]q` (n) — Next Quickfix
- [ ] `]d` (n) — Next Diagnostic
- [ ] `]e` (n) — Next Error
- [ ] `]w` (n) — Next Warning

## g*

- [ ] `gco` (n) — Add Comment Below
- [ ] `gcO` (n) — Add Comment Above

## other

- [ ] `j` (nx) — Down
- [ ] `<Down>` (nx) — Down
- [ ] `k` (nx) — Up
- [ ] `<Up>` (nx) — Up
- [ ] `<esc>` (ins) — Escape and Clear hlsearch
- [ ] `n` (n) — Next Search Result
- [ ] `n` (x) — Next Search Result
- [ ] `n` (o) — Next Search Result
- [ ] `N` (n) — Prev Search Result
- [ ] `N` (x) — Prev Search Result
- [ ] `N` (o) — Prev Search Result
- [ ] `,` (i) — 
- [ ] `.` (i) — 
- [ ] `;` (i) — 
- [ ] `<` (x) — 
- [ ] `>` (x) — 
- [ ] `<c-/>` (nt) — Terminal (Root Dir)
- [ ] `<c-_>` (nt) — which_key_ignore
- [ ] `<localleader>r` (nx) — Run Lua


---

# Plugin-provided keymaps (from `:map`, not in config/keymaps.lua)

143 additional leader keymaps supplied by LazyVim plugin specs
(pickers, LSP, git, trouble, flash, dap, neotest, ...).
These live in the plugin specs in the new config, not in `core/keymaps.lua`.

## <leader>,

- [ ] `<leader>,` (n) — Switch Buffer

## <leader>.

- [ ] `<leader>.` (n) — Toggle Scratch Buffer

## <leader>/

- [ ] `<leader>/` (n) — Grep (Root Dir)

## <leader>:

- [ ] `<leader>:` (n) — Command History

## <leader><

- [ ] `<leader><Space>` (n) — Find Files (Root Dir)

## <leader>?

- [ ] `<leader>?` (n) — Buffer Keymaps (which-key)

## <leader>E

- [ ] `<leader>E` (n) — Explorer Snacks (cwd)

## <leader>S

- [ ] `<leader>S` (n) — Select Scratch Buffer

## <leader>U

- [ ] `<leader>U` (n) — Toggle undotree

## <leader>a

- [ ] `<leader>as` (v) — Send to Claude
- [ ] `<leader>ab` (n) — Add current buffer
- [ ] `<leader>aC` (n) — Continue Claude
- [ ] `<leader>ar` (n) — Resume Claude
- [ ] `<leader>af` (n) — Focus Claude
- [ ] `<leader>ac` (n) — Toggle Claude
- [ ] `<leader>a` (v) — +ai
- [ ] `<leader>ad` (n) — Deny diff
- [ ] `<leader>aa` (n) — Accept diff

## <leader>b

- [ ] `<leader>br` (n) — Delete Buffers to the Right
- [ ] `<leader>bj` (n) — Pick Buffer
- [ ] `<leader>bl` (n) — Delete Buffers to the Left
- [ ] `<leader>bP` (n) — Delete Non-Pinned Buffers
- [ ] `<leader>bp` (n) — Toggle Pin

## <leader>c

- [ ] `<leader>cS` (n) — LSP references/definitions/... (Trouble)
- [ ] `<leader>cs` (n) — Symbols (Trouble)
- [ ] `<leader>cm` (n) — Mason
- [ ] `<leader>cF` (n) — Format Injected Langs

## <leader>d

- [ ] `<leader>dps` (n) — Profiler Scratch Buffer
- [ ] `<leader>de` (x) — Eval
- [ ] `<leader>du` (n) — Dap UI
- [ ] `<leader>d?` (n) — Display current word value
- [ ] `<leader>dw` (n) — Widgets
- [ ] `<leader>dt` (n) — Terminate
- [ ] `<leader>ds` (n) — Session
- [ ] `<leader>dr` (n) — Toggle REPL
- [ ] `<leader>dP` (n) — Pause
- [ ] `<leader>dO` (n) — Step Out
- [ ] `<leader>do` (n) — Step Over
- [ ] `<leader>dl` (n) — Run Last
- [ ] `<leader>dk` (n) — Up
- [ ] `<leader>dj` (n) — Down
- [ ] `<leader>di` (n) — Step Into
- [ ] `<leader>dg` (n) — Go to Line (No Execute)
- [ ] `<leader>dC` (n) — Run to Cursor
- [ ] `<leader>da` (n) — Run with Args
- [ ] `<leader>dc` (n) — Run/Continue
- [ ] `<leader>db` (n) — Toggle Breakpoint
- [ ] `<leader>dB` (n) — Breakpoint Condition

## <leader>e

- [ ] `<leader>e` (n) — Explorer Snacks (root dir)

## <leader>f

- [ ] `<leader>fE` (n) — Explorer Snacks (cwd)
- [ ] `<leader>fe` (n) — Explorer Snacks (root dir)
- [ ] `<leader>fr` (n) — Recent
- [ ] `<leader>fR` (n) — Recent (cwd)
- [ ] `<leader>fg` (n) — Find Files (git-files)
- [ ] `<leader>fF` (n) — Find Files (cwd)
- [ ] `<leader>ff` (n) — Find Files (Root Dir)
- [ ] `<leader>fc` (n) — Find Config File
- [ ] `<leader>fB` (n) — Buffers (all)
- [ ] `<leader>fb` (n) — Buffers

## <leader>g

- [ ] `<leader>gS` (n) — Git Stash
- [ ] `<leader>gs` (n) — Status
- [ ] `<leader>gd` (n) — Git Diff (files)
- [ ] `<leader>gc` (n) — Commits

## <leader>n

- [ ] `<leader>n` (n) — Notification History

## <leader>o

- [ ] `<leader>ot` (n) — Task action
- [ ] `<leader>oo` (n) — Run task
- [ ] `<leader>ow` (n) — Task list

## <leader>p

- [ ] `<leader>p` (x) — Open Yank History

## <leader>r

- [ ] `<leader>rf` (n) — Extract Function
- [ ] `<leader>rc` (n) — Debug Cleanup
- [ ] `<leader>ri` (x) — Inline Variable
- [ ] `<leader>rs` (x) — Select Refactor
- [ ] `<leader>r` (x) — +refactor
- [ ] `<leader>rp` (x) — Debug Print Variable
- [ ] `<leader>rP` (n) — Debug Print Location
- [ ] `<leader>rx` (x) — Extract Variable
- [ ] `<leader>rF` (x) — Extract Function To File

## <leader>s

- [ ] `<leader>snt` (n) — Noice Picker (Telescope/FzfLua)
- [ ] `<leader>snd` (n) — Dismiss All
- [ ] `<leader>sna` (n) — Noice All
- [ ] `<leader>snh` (n) — Noice History
- [ ] `<leader>snl` (n) — Noice Last Message
- [ ] `<leader>sn` (n) — +noice
- [ ] `<leader>sr` (x) — Search and Replace
- [ ] `<leader>sT` (n) — Todo/Fix/Fixme
- [ ] `<leader>st` (n) — Todo
- [ ] `<leader>sS` (n) — Goto Symbol (Workspace)
- [ ] `<leader>ss` (n) — Goto Symbol
- [ ] `<leader>sW` (x) — Selection (cwd)
- [ ] `<leader>sw` (x) — Selection (Root Dir)
- [ ] `<leader>sW` (n) — Word (cwd)
- [ ] `<leader>sw` (n) — Word (Root Dir)
- [ ] `<leader>sq` (n) — Quickfix List
- [ ] `<leader>sR` (n) — Resume
- [ ] `<leader>sm` (n) — Jump to Mark
- [ ] `<leader>sM` (n) — Man Pages
- [ ] `<leader>sl` (n) — Location List
- [ ] `<leader>sk` (n) — Key Maps
- [ ] `<leader>sj` (n) — Jumplist
- [ ] `<leader>sH` (n) — Search Highlight Groups
- [ ] `<leader>sh` (n) — Help Pages
- [ ] `<leader>sG` (n) — Grep (cwd)
- [ ] `<leader>sg` (n) — Grep (Root Dir)
- [ ] `<leader>sD` (n) — Buffer Diagnostics
- [ ] `<leader>sd` (n) — Diagnostics
- [ ] `<leader>sC` (n) — Commands
- [ ] `<leader>sc` (n) — Command History
- [ ] `<leader>sb` (n) — Buffer Lines
- [ ] `<leader>sa` (n) — Auto Commands
- [ ] `<leader>s/` (n) — Search History
- [ ] `<leader>s"` (n) — Registers

## <leader>t

- [ ] `<leader>td` (n) — Debug Nearest
- [ ] `<leader>tO` (n) — Toggle Output Panel (Neotest)
- [ ] `<leader>to` (n) — Show Output (Neotest)
- [ ] `<leader>ts` (n) — Toggle Summary (Neotest)
- [ ] `<leader>tl` (n) — Run Last (Neotest)
- [ ] `<leader>tr` (n) — Run Nearest (Neotest)
- [ ] `<leader>tT` (n) — Run All Test Files (Neotest)
- [ ] `<leader>tt` (n) — Run File (Neotest)
- [ ] `<leader>ta` (n) — Attach to Test (Neotest)
- [ ] `<leader>t` (n) — +test
- [ ] `<leader>tw` (n) — Toggle Watch (Neotest)
- [ ] `<leader>tS` (n) — Stop (Neotest)

## <leader>u

- [ ] `<leader>un` (n) — Dismiss All Notifications
- [ ] `<leader>uC` (n) — Colorscheme with Preview

## <leader>x

- [ ] `<leader>xT` (n) — Todo/Fix/Fixme (Trouble)
- [ ] `<leader>xt` (n) — Todo (Trouble)
- [ ] `<leader>xX` (n) — Buffer Diagnostics (Trouble)
- [ ] `<leader>xx` (n) — Diagnostics (Trouble)
- [ ] `<leader>xQ` (n) — Quickfix List (Trouble)
- [ ] `<leader>xL` (n) — Location List (Trouble)

