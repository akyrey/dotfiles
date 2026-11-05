-- minuet's request timeout, in seconds; blink's source timeout must match it.
local MINUET_REQUEST_TIMEOUT = 3

return {
  -- AI completion from a local model served by Ollama (`ollama pull
  -- qwen2.5-coder:7b`), shown through blink.cmp rather than as virtual text so
  -- there is one completion UI. Config follows minuet's Ollama recipe.
  {
    "milanglacier/minuet-ai.nvim",
    -- Loaded as a blink.cmp dependency (VeryLazy); no requests until insert mode.
    lazy = true,
    opts = {
      provider = "openai_fim_compatible",
      -- Local inference: one candidate and a small context keep requests fast.
      -- Raise context_window if completions lack context and the machine copes.
      n_completions = 1,
      context_window = 512,
      request_timeout = MINUET_REQUEST_TIMEOUT,
      provider_options = {
        openai_fim_compatible = {
          -- Ollama needs no key, but minuet requires a non-empty one. The
          -- README's `api_key = "TERM"` relies on $TERM, which GUI clients and
          -- non-terminal launches may not set; a function avoids the env lookup.
          api_key = function()
            return "ollama"
          end,
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:7b",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
    },
  },

  -- minuet as a blink.cmp source.
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "milanglacier/minuet-ai.nvim" },
    opts = {
      keymap = {
        -- Ask the model explicitly, e.g. after toggling auto-complete off with
        -- `:Minuet blink toggle`.
        ["<A-y>"] = {
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
      },
      sources = {
        default = { "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            async = true,
            timeout_ms = MINUET_REQUEST_TIMEOUT * 1000,
            score_offset = 50,
          },
        },
      },
      -- Recommended by minuet: don't fire a model request on entering insert mode.
      completion = { trigger = { prefetch_on_insert = false } },
    },
  },

  -- Claude Code integration: send buffers/selections to a Claude session and
  -- review its diffs in nvim.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {},
    keys = {
      { "<leader>a", nil, desc = "+ai" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
