local blink = require("blink.cmp")

blink.setup({
    cmdline = {
        enabled = true,
        completion = {
            menu = {
                auto_show = true,
            },
        },
    },
    completion = {
        menu = { auto_show = true },
        list = {
            selection = {
                preselect = false,
                auto_insert = true,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
        },
    },
})
