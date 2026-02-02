---@type overseer.ComponentFileDefinition
return {
  desc = "Fidget progress bridge",
  serializable = false,
  constructor = function(_params)
    local has_fidget, fidget_progress = pcall(require, "fidget.progress")
    return {
      fidget = nil,
      output_lines = 0,
      _debounce = nil,
      on_start = function(self, task)
        self.output_lines = 0
        self._debounce = nil
        if has_fidget then
          self.fidget = fidget_progress.handle.create({
            title = string.format("%s (0 lines)", task.name),
            message = "Running",
          })
        end
        task:subscribe("on_status", function(_, status)
          if not self.fidget then
            return
          end
          if status == "RUNNING" then
            self.fidget:report({ message = "Running", done = false })
          elseif status == "PENDING" then
            self.fidget:report({ message = "Pending", done = false })
          elseif status == "SUCCESS" then
            self.fidget:report({ message = "Success" })
            self.fidget:finish()
            self.fidget = nil
          elseif status == "FAILURE" then
            self.fidget:report({ message = "Failure" })
            self.fidget:finish()
            self.fidget = nil
          elseif status == "CANCELED" then
            self.fidget:report({ message = "Canceled" })
            self.fidget:finish()
            self.fidget = nil
          end
        end)
        task:subscribe("on_output_lines", function(_task, lines)
          self.output_lines = self.output_lines + #lines
          if self.fidget and not self._debounce then
            self._debounce = true
            vim.defer_fn(function()
              self._debounce = nil
              if not self.fidget then
                return
              end
              local base = _task.status
              if base == "PENDING" then
                base = "Pending"
              elseif base == "RUNNING" then
                base = "Running"
              end
              self.fidget:report({ message = base })
              self.fidget.title = string.format("%s (%d lines)", _task.name, self.output_lines)
            end, 200)
          end
          for _, line in ipairs(lines) do
            local address = line:match("^Serving at (http.*)")
            if address then
              vim.ui.open(address)
              return true -- self-unsubscribe
            end
          end
        end)
      end,
      on_complete = function(self)
        if self.fidget then
          self.fidget:report({ message = "Done" })
          self.fidget.title = string.format("%s (%d lines)", task.name, self.output_lines)
          self.fidget:finish()
          self.fidget = nil
        end
      end,
      on_dispose = function(self)
        if self.fidget then
          self.fidget:finish()
          self.fidget = nil
        end
      end,
    }
  end,
}
