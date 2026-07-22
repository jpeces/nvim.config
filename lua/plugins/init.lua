-- Plugin loader: reads lua/plugins/*.lua, downloads sources, infers modules
-- from the URL, and runs setup. Entry: { "src" } or { "src", config = tbl|fn }.

local M = {}

local function expand_src(src)
    if src:find("://", 1, true) then return src end
    return "https://github.com/" .. src
end

local function infer_module(src)
    local last = src:match("[^/]+$") or src
    local candidates = { last }
    if last:sub(1, 5) == "nvim-" then
        table.insert(candidates, last:sub(6))
    end
    if last:sub(-5) == ".nvim" then
        table.insert(candidates, last:sub(1, -6))
    end
    for _, c in ipairs(candidates) do
        local ok, mod = pcall(require, c)
        if ok and type(rawget(mod, "setup")) == "function" then return c end
    end
    return nil
end

function M.setup()
    local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"

    local entries, urls = {}, {}
    for _, f in ipairs(vim.fn.readdir(plugins_dir)) do
        if f ~= "init.lua" then
            for _, e in ipairs(require("plugins." .. f:gsub("%.lua$", ""))) do
                if type(e) ~= "table" or type(e[1]) ~= "string" then
                    error("plugin entry must be {src, ...}")
                end
                table.insert(urls, expand_src(e[1]))
                table.insert(entries, e)
            end
        end
    end
    vim.pack.add(urls)

    -- Table-cfgs first, then fns: lsp.lua's fn needs mini.completion already set up.
    local fns = {}
    for _, e in ipairs(entries) do
        if type(e.config) == "function" then
            table.insert(fns, e.config)
        else
            local mod = infer_module(e[1])
            if mod then require(mod).setup(e.config or {}) end
        end
    end
    for _, fn in ipairs(fns) do fn() end
end

return M
