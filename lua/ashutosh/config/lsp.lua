local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, 'fm', function()
        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
    end, opts)
end)

lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['tsserver'] = { 'javascript', 'typescript' },
        ['rust_analyzer'] = { 'rust' },
    }
})

lsp_zero.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'tsserver', 'rust_analyzer' },
    handlers = {
        lsp_zero.default_setup,
    },
})

require('lspconfig').tsserver.setup({
    single_file_support = false,
})

local cmp = require('cmp')

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
    },
    mapping = {
        ['<return>'] = cmp.mapping.confirm({ select = false }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
        ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

require("luasnip.loaders.from_vscode").lazy_load()
