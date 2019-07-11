title = "TTT2 Reference"
project = "TTT2"
convert_opt = true
sort = true
dir = "docs"
merge = true

file = {
	"lua/",
	"gamemodes/",
}

new_type("cmd", "ConCommands", false)
new_type("hook", "Hooks", false)

alias('p', 'param')
alias('ret', 'return')
alias('str', 'string')
alias('tab', 'table')
alias('int', 'number')
alias('bool', 'boolean')

tparam_alias('str', 'string')
tparam_alias('tab', 'table')
tparam_alias('int', 'number')
tparam_alias('bool', 'boolean')
tparam_alias('stn', 'string|table|number')
tparam_alias('st', 'string|table')
tparam_alias('sn', 'string|number')
