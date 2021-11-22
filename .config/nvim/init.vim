syntax on
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set ic
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
" set relativenumber
set clipboard+=unnamedplus
set nohlsearch
set noshowmode
set completeopt=menu,menuone,noselect
set termguicolors
set shortmess+=c
set background=dark
set mouse=a

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
" Plug 'miyakogi/seiya.vim' " Enables transparency

Plug 'mattn/vim-goimports'
Plug 'tomlion/vim-solidity'

" Neovim v0.5 plugins
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim' " Needed for gitsigns and telescope
Plug 'lewis6991/gitsigns.nvim' " Like git gutter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/popup.nvim' " Needed for telescope
Plug 'nvim-telescope/telescope.nvim' " Fuzzy finder
" Plug 'norcalli/nvim-colorizer.lua' " Colorizes RGB color codes
" Plug 'kyazdani42/nvim-tree.lua'
Plug 'hoob3rt/lualine.nvim'
Plug 'glepnir/dashboard-nvim'
" Plug 'kyazdani42/nvim-tree.lua'
Plug 'Mofiqul/vscode.nvim'

" These deal with autocompletions and diagnostics
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/lsp_signature.nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'mattn/efm-langserver'

call plug#end()

lua <<EOF
require('nvim-treesitter.configs').setup { highlight = { enable = true }}
require('gitsigns').setup()
require('telescope').setup()
-- require('colorizer').setup()
-- require('nvim-tree').setup()

require('lualine').setup{
    options = {
        theme = 'vscode',
        section_separators = {},
    },
}

-- LSP Config setup
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
end

require('lsp_signature').setup({
    bind = true,
    fix_pos = true,
    handler_opts = { border = "none" },
    always_trigger = true,
    hint_enable = false,
})

local cmp = require('cmp')

cmp.setup({
    snippet = {
      expand = function(args)
         require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    }
})

local shellcheck = {
    lintCommand = "shellcheck -f gcc -x -",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m"},
}

local shfmt = {
    formatCommand = 'shfmt -ci -s -sr -i 2',
    formatStdin = true,
}

nvim_lsp["efm"].setup({
    init_options = {
        documentFormatting = true,
        hover = false,
        documentSymbol = false,
        codeAction = false,
        completion = false,
    },
    settings = {
        rootMarkers = { "package.json", "pyproject.toml", "Cargo.toml", ".git/" },
        languages = {
            sh = { shellcheck },
        },
    },
    root_dir = function() return vim.loop.cwd() end,
})

local servers = { "pyright", "gopls", "texlab" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        flags = {
            debounce_text_changes = 500,
        },
    }
end
EOF

let g:vscode_style = "dark"
colorscheme vscode

let g:dashboard_default_executive = 'telescope'
let g:dashboard_custom_header = [
\ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
\ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
\ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
\ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
\ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
\ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
\]

" Nvim transparency
let g:seiya_auto_enable = 1
let g:seiya_target_groups = has('nvim') ? ['guibg'] : ['ctermbg']

" Spell check toggle on F6
map <F6> :setlocal spell! spelllang=en_us<CR>
map <F7> :set nowrap!<CR>

nnoremap j gj
nnoremap k gk
inoremap jj <ESC>

nnoremap <SPACE> <Nop>
let mapleader=" "
nnoremap <leader>d "_d
xnoremap <leader>d "_d

map <C-_> <plug>NERDCommenterToggle
nnoremap <C-n> :NvimTreeToggle<CR>
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

filetype plugin on

" Find files using Telescope command-line sugar.
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap fb <cmd>Telescope buffers<cr>

" Nvim tree stuff
let g:nvim_tree_special_files = {}
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache', '.vscode' ]

" Stops yanking when pasting in visual mode
vnoremap p pgvy

" Ctrl+S to save
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

let g:goimports_simplify = 1 " Enables -s flag for gofmt

autocmd BufWritePre *.sh lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd FileType sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
