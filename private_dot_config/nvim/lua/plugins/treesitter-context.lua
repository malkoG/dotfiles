require 'treesitter-context'.setup {
	patterns = {
		default = {
			'class',
			'function',
			'method',
			'for',
			'while',
			'if',
			'switch',
			'case',
			-- elixir 
			'defmodule',
			'def',
			'defprotocol',
			'defmacro',
			'defp',
			'describe',
			'test',
			-- kotin
			'fun'
		}
	}
}
