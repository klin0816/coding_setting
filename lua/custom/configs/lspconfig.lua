local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
local util = require "lspconfig.util"
util.default_config = vim.tbl_extend("force", util.default_config, {
  capabilities = capabilities,
})

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "clangd", "pyright", "svelte", "tsserver", "denols" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

--
-- lspconfig.pyright.setup { blabla}
