local rules = {}

local single_occurence_constraint = "^"
local optional_blank = "%s*"
local blank = "%s+"
local tag = "@%S+"

local comment = {
  ["ruby"] = "#",
  ["lua"] = "---",
  ["javascript"] = "*",
  ["typescript"] = "*",
  ["javascriptreact"] = "*",
  ["typescriptreact"] = "*"
}

local function capture(pattern)
  return "(" .. pattern .. ")"
end

local function optional(pattern)
  return pattern .. "?"
end

local function define_highright_rules_for(filetype, captured_pattern, highlight_group)
  local pattern = single_occurence_constraint .. optional_blank .. comment[filetype] .. blank .. captured_pattern
  return {
    filter = { filetype = filetype }, pattern = pattern, hl = highlight_group
  }
end

local humanized_highlight_group = {
  ["tag"] = "String",
  ["definition"] = "Constant",
  ["parameter_name"] = "Operator",
  ["type"] = "Delimiter"
}

rules.highlights = {
  -- lua
  define_highright_rules_for("lua", capture(tag), humanized_highlight_group.tag),

  -- ruby (yard)
  define_highright_rules_for("ruby", capture(tag), humanized_highlight_group.tag),
  define_highright_rules_for("ruby", capture("{.+}"), humanized_highlight_group.definition),
  define_highright_rules_for("ruby", tag .. blank .. capture("#%w+"), humanized_highlight_group.parameter_name),
  define_highright_rules_for("ruby", tag .. blank .. capture("%w+%.%w+"), humanized_highlight_group.parameter_name),
  define_highright_rules_for("ruby", tag .. blank .. capture("%w+"), humanized_highlight_group.parameter_name),
  define_highright_rules_for("ruby", tag .. blank .. capture("%[%S+%]"), humanized_highlight_group.type),
  define_highright_rules_for("ruby", tag .. blank .. "%w+" .. blank .. capture("%[%S+%]"), humanized_highlight_group.type),
  define_highright_rules_for("ruby", tag .. blank .. "%[%S+%]" .. blank .. capture("%S+"), humanized_highlight_group.parameter_type),
  define_highright_rules_for("ruby", tag .. blank .. "%w+" .. blank .. "%[%S+%]" .. optional_blank .. capture("%S+"), humanized_highlight_group.parameter_type), -- doesn't work
}

return rules
