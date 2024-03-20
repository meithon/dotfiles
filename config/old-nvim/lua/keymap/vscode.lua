local bind = require("keymap.bind")
local map_cr = bind.map_cr
local vscode = require("vscode-neovim")

local vscode_range_command = function(name, cmd)
  vim.api.nvim_create_user_command(name, function(arg)
    vscode.call_range(cmd, arg.line1, arg.line2, 0)
  end, { range = "%" })

  return map_cr(name)
end
local vscode_command = function(cmd, arg)
  return map_cr("call VSCodeNotify('" .. cmd .. "')")
end

local vscode_command_with_arg = function(name, cmd, arg)
  vim.api.nvim_create_user_command(name, function()
    vscode.call(cmd, arg)
  end, { range = "%" })

  return map_cr(name)
end
local map = {
  -- edit
  ["v|<C-n>"] = vscode_command("editor.action.addSelectionToNextFindMatch"),
  -- buffer
  -- ["n|<Leader><tab>"] = map_cr("call VSCodeNotify('workbench.action.quickOpen')"),
  -- ["n|<C-W>q"] = map_cr("call VSCodeNotify('workbench.action.closeOtherEditors')"),
  -- ["n|<Leader>e"] = map_cr("call VSCodeNotify('workbench.explorer.fileView.focus')"),
  -- ["n|<Leader>tt"] = map_cr("call VSCodeNotify('workbench.action.terminal.focusAccessibleBuffer')"),
  -- ["n|QQ"] = map_cr("call VSCodeNotify('workbench.action.closeActiveEditor')"),
  --
  -- Telescope
  ["n|<leader>ff"] = vscode_command("binocular.searchFile"),
  ["n|<Leader>fg"] = vscode_command_with_arg(
    "BinocularFindGitFile",
    "binocular.customCommands",
    "find-git-file"
  ),
  ["n|<Leader><C-G>"] = vscode_command_with_arg(
    "BinocularFindGitFile",
    "binocular.customCommands",
    "find-git-file"
  ),

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
  -- ["n|<Leader>gs"] = map_cr("call VSCodeNotify(binocular.customCommands)"),
  ["n|<Leader>gs"] = vscode_command_with_arg("BinocularGit", "binocular.customCommands", "Lazygit"),
  ["n|gj"] = map_cr("call VSCodeNotify('workbench.action.editor.nextChange')"),
  ["n|gk"] = map_cr("call VSCodeNotify('workbench.action.editor.previousChange')"),
  ["v|<Leader>ga"] = vscode_range_command("GitAdd", "git.stageSelectedRanges"),
  ["v|<Leader>gr"] = vscode_range_command("GitReset", "git.unstageSelectedRanges"),
  ["n|<Leader>gd"] = vscode_range_command("GitDiff", "git.openChange"),
  ["n|<Leader>gh"] = vscode_range_command("GitDiff", "git.openChange"),
  ["n|K"] = map_cr("call VSCodeNotify('editor.action.showHover')"),
}

return map
