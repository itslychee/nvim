local loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
    snippets = {
        loader.from_lang(),
    },
})
