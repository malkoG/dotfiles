local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
keymap("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
keymap("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
keymap("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)

local ls = require("luasnip")
local prelude = require("utilities.prelude")

-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local lambda = require("luasnip.extras").lambda
local postfix = require("luasnip.extras.postfix").postfix

local dynamicn = ls.dynamic_node

local date = function() return {os.date('%Y-%m-%d')} end
local thismonth = function() return {os.date('%Y-%m')} end
local yesterday = function() return { os.date('%Y-%m-%d', os.time() - 60 * 60 * 24) } end
local tomorrow = function() return { os.date('%Y-%m-%d', os.time() + 60 * 60 * 24) } end

local ruby_snippets = {}
local ruby_snippets_at_work = {}

ruby_snippets = prelude.concat(ruby_snippets, ruby_snippets_at_work)

ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
}

require("luasnip/loaders/from_vscode").load {
  paths = {
    "~/.config/nvim/snippets",
    "~/toolbox/snippets"
  }
}

ls.filetype_extend("dart", { "flutter" })

local markdown_snippets = {
  postfix({
    trig = ".kb",
    namr = ".kb",
    dscr = "Generates kbd element for given textContent"
  }, {
    lambda("<kbd>" .. lambda.POSTFIX_MATCH .. "</kbd>")
  })
}

ls.add_snippets(nil, {
  all = {
    snip({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      func(date, {}),
    }),
    snip({
      trig = "yesterday",
      namr = "Yesterday",
      dscr = "Yesterday in the form of YYYY-MM-DD",
    }, {
      func(yesterday, {}),
    }),
    snip({
      trig = "thismonth",
      namr = "This Month",
      dscr = "This month in the form of YYYY-MM",
    }, {
      func(thismonth, {}),
    }),
    snip({
      trig = "tomorrow",
      namr = "Tomorrow",
      dscr = "Tomorrow in the form of YYYY-MM-DD",
    }, {
      func(tomorrow, {}),
    }),
  },

  ruby = ruby_snippets,

  markdown = markdown_snippets,
  telekasten = markdown_snippets,

  kotlin = {
    snip({
      trig = "main-ps",
      namr = "main function for PS",
      dscr = "main function definition for Problem Solving",
    }, {
      text("fun main(args: Array<String>) = with(Scanner(System.`in`)) {}")
    })
  }
})
