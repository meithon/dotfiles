local bind = require("keymap.bind")
local map_cr = bind.map_cr
local vscode = require("vscode-neovim")

local vscode_range_command = function(name, cmd)
	vim.api.nvim_create_user_command(name, function(arg)
		vscode.call_range(cmd, arg.line1, arg.line2, 0)
	end, { range = "%" })

	return map_cr(name)
end
local vscode_command = function(cmd)
	return map_cr("call VSCodeNotify('" .. cmd .. "')")
end

local map = {
	-- buffer
	["n|<Leader><tab>"] = map_cr("call VSCodeNotify('workbench.action.quickOpen')"),
	["n|<C-W>q"] = map_cr("call VSCodeNotify('workbench.action.closeOtherEditors')"),
	["n|<Leader>e"] = map_cr("call VSCodeNotify('workbench.explorer.fileView.focus')"),
	["n|<Leader>tt"] = map_cr("call VSCodeNotify('workbench.action.terminal.focusAccessibleBuffer')"),
	["n|QQ"] = map_cr("call VSCodeNotify('workbench.action.closeActiveEditor')"),

	---- window
	-- resize
	["n|<C-W>y"] = vscode_command("workbench.action.increaseViewWidth"),
	["n|<C-W>o"] = vscode_command("workbench.action.decreaseViewWidth"),
	["n|<C-W>u"] = vscode_command("workbench.action.decreaseViewHeight"),
	["n|<C-W>i"] = vscode_command("workbench.action.increaseViewHeight"),
	-- move

	-- diagnosti
	["n|<Leader>ca"] = map_cr("call VSCodeNotify('editor.action.sourceAction')"),
	["n|<Leader>n"] = map_cr("call VSCodeNotify('editor.action.marker.next')"),
	["n|<Leader>p"] = map_cr("call VSCodeNotify('editor.action.marker.prev')"),
	-- lsp
	["n|gd"] = map_cr("call VSCodeNotify('editor.action.revealDefinition')"),
	["n|gr"] = map_cr("call VSCodeNotify('editor.action.goToReferences')"),
	["n|gi"] = map_cr("call VSCodeNotify('editor.action.goToImplementation')"),
	["n|<Leader>lr"] = map_cr("call VSCodeNotify('editor.action.rename')"),
	-- ["n|<Leader>gt"] = map_cmd("call VSCodeNotify('')"),
	-- git
	["n|<Leader>gs"] = map_cr("call VSCodeNotify('workbench.scm.focus')"),
	["n|gj"] = map_cr("call VSCodeNotify('workbench.action.editor.nextChange')"),
	["n|gk"] = map_cr("call VSCodeNotify('workbench.action.editor.previousChange')"),
	["v|<Leader>ga"] = vscode_range_command("GitAdd", "git.stageSelectedRanges"),
	["v|<Leader>gr"] = vscode_range_command("GitReset", "git.unstageSelectedRanges"),
	["n|<Leader>gd"] = vscode_range_command("GitDiff", "git.openChange"),
	["n|<Leader>gh"] = vscode_range_command("GitDiff", "git.openChange"),
	["n|K"] = map_cr("call VSCodeNotify('editor.action.showHover')"),
}

return map
