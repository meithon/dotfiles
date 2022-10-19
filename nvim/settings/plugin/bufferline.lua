require("bufferline").setup({
    options = {
        mode = "tabs",
        number = "none",
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon', -- | 'underline' | 'none',
        },
        modified_icon = "●",
        buffer_close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 13,
        tab_size = 18,
        show_buffer_close_icons = false,
        show_buffer_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        always_show_bufferline = true,
        separator_style = "thick",
        offsets = { {
            filetype = "vfiler",
            text_align = "center",
            text = "File Explorer",
            padding = 1,
        }, },
    },
})
