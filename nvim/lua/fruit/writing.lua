local harpoon = require("harpoon")
harpoon:setup()

local function k(keybind, func, description)
    vim.keymap.set("n", "," .. keybind, func, {
        desc = "[Harpoon] " .. description,
    })
end

k("a", function()
    harpoon:list():add()
end, "Add to harpoon")
k("1", function()
    harpoon:list():select(1)
end, "select index 1")
k("2", function()
    harpoon:list():select(2)
end, "select index 2")
k("3", function()
    harpoon:list():select(3)
end, "select index 3")
k("4", function()
    harpoon:list():select(4)
end, "select index 4")
k("5", function()
    harpoon:list():select(5)
end, "select index 5")
k(",", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, "enter quick menu")

-- I hate help
vim.keymap.set({ "n", "v", "i" }, "<F1>", function() end)
