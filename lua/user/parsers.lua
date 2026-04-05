-- Tree-sitter parser manager (Neovim 0.10+, requires: git, curl, tree-sitter CLI)
-- Commands: :ParserInstall <lang>  :ParserUpdate [lang]  :ParserRemove <lang>
--           :ParserInstallAll      :ParserList

local M = {}

local parser_dir  = vim.fn.stdpath("data") .. "/site/parser"
local src_dir     = vim.fn.stdpath("data") .. "/ts-src"
local query_dir   = vim.fn.stdpath("config") .. "/queries"
local queries_url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/main/queries"

-- These languages ship with Neovim's own bundled queries — no download needed
local nvim_bundled = {
	bash = true, c = true, lua = true, markdown = true, markdown_inline = true,
	python = true, query = true, vim = true, vimdoc = true,
}

M.registry = {
	bash            = { url = "https://github.com/tree-sitter/tree-sitter-bash" },
	bicep           = { url = "https://github.com/tree-sitter-grammars/tree-sitter-bicep" },
	c               = { url = "https://github.com/tree-sitter/tree-sitter-c" },
	c_sharp         = { url = "https://github.com/tree-sitter/tree-sitter-c-sharp" },
	comment         = { url = "https://github.com/stsewd/tree-sitter-comment" },
	css             = { url = "https://github.com/tree-sitter/tree-sitter-css" },
	diff            = { url = "https://github.com/tree-sitter-grammars/tree-sitter-diff" },
	dockerfile      = { url = "https://github.com/camdencheek/tree-sitter-dockerfile" },
	git_config      = { url = "https://github.com/the-mikedavis/tree-sitter-git-config" },
	git_rebase      = { url = "https://github.com/the-mikedavis/tree-sitter-git-rebase" },
	gitcommit       = { url = "https://github.com/gbprod/tree-sitter-gitcommit" },
	gitignore       = { url = "https://github.com/shunsambongi/tree-sitter-gitignore" },
	go              = { url = "https://github.com/tree-sitter/tree-sitter-go" },
	graphql         = { url = "https://github.com/bkegley/tree-sitter-graphql" },
	hcl             = { url = "https://github.com/tree-sitter-grammars/tree-sitter-hcl" },
	helm            = { url = "https://github.com/ngalaiko/tree-sitter-go-template", subdir = "dialects/helm" },
	html            = { url = "https://github.com/tree-sitter/tree-sitter-html" },
	http            = { url = "https://github.com/rest-nvim/tree-sitter-http" },
	javascript      = { url = "https://github.com/tree-sitter/tree-sitter-javascript" },
	jsdoc           = { url = "https://github.com/tree-sitter/tree-sitter-jsdoc" },
	json            = { url = "https://github.com/tree-sitter/tree-sitter-json" },
	jsonnet         = { url = "https://github.com/sourcegraph/tree-sitter-jsonnet" },
	lua             = { url = "https://github.com/tree-sitter-grammars/tree-sitter-lua" },
	make            = { url = "https://github.com/tree-sitter-grammars/tree-sitter-make" },
	markdown        = { url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown", subdir = "tree-sitter-markdown" },
	markdown_inline = { url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown", subdir = "tree-sitter-markdown-inline" },
	proto           = { url = "https://github.com/coder3101/tree-sitter-proto" },
	python          = { url = "https://github.com/tree-sitter/tree-sitter-python" },
	regex           = { url = "https://github.com/tree-sitter/tree-sitter-regex" },
	ruby            = { url = "https://github.com/tree-sitter/tree-sitter-ruby" },
	rust            = { url = "https://github.com/tree-sitter/tree-sitter-rust" },
	sql             = { url = "https://github.com/derekstride/tree-sitter-sql" },
	toml            = { url = "https://github.com/tree-sitter-grammars/tree-sitter-toml" },
	tsx             = { url = "https://github.com/tree-sitter/tree-sitter-typescript", subdir = "tsx" },
	typescript      = { url = "https://github.com/tree-sitter/tree-sitter-typescript", subdir = "typescript" },
	vim             = { url = "https://github.com/tree-sitter-grammars/tree-sitter-vim" },
	xml             = { url = "https://github.com/tree-sitter-grammars/tree-sitter-xml", subdir = "xml" },
	yaml            = { url = "https://github.com/tree-sitter-grammars/tree-sitter-yaml" },
}

function M.is_installed(lang)
	return vim.fn.filereadable(parser_dir .. "/" .. lang .. ".so") == 1
end

local function notify(msg, level)
	vim.schedule(function()
		vim.notify("[parsers] " .. msg, level or vim.log.levels.INFO)
	end)
end

local function download_queries(lang)
	if nvim_bundled[lang] then return end
	local qdir = query_dir .. "/" .. lang
	vim.fn.mkdir(qdir, "p")
	for _, fname in ipairs({ "highlights.scm", "injections.scm", "folds.scm", "locals.scm" }) do
		local dest = qdir .. "/" .. fname
		if vim.fn.filereadable(dest) == 0 then
			vim.system({ "curl", "-sfL", queries_url .. "/" .. lang .. "/" .. fname, "-o", dest }, {}, function(r)
				if r.code ~= 0 then vim.fn.delete(dest) end
			end)
		end
	end
end

local function compile(lang, repo_root, info)
	local path   = repo_root .. (info.subdir and ("/" .. info.subdir) or "")
	local output = parser_dir .. "/" .. lang .. ".so"
	vim.system({ "tree-sitter", "build", "--output", output, path }, {}, function(r)
		if r.code == 0 then
			notify("installed " .. lang)
			download_queries(lang)
		else
			notify("compile failed for " .. lang .. "\n" .. (r.stderr or ""), vim.log.levels.ERROR)
		end
	end)
end

local function clone_or_pull(lang, info, pull)
	local repo_root = src_dir .. "/" .. info.url:match("[^/]+$")
	if vim.fn.isdirectory(repo_root) == 1 then
		if pull then
			vim.system({ "git", "-C", repo_root, "pull", "--ff-only" }, {}, function(r)
				if r.code ~= 0 then
					notify("pull failed for " .. lang .. ", recompiling anyway", vim.log.levels.WARN)
				end
				compile(lang, repo_root, info)
			end)
		else
			compile(lang, repo_root, info)
		end
	else
		notify("cloning " .. lang .. "…")
		vim.system({ "git", "clone", "--depth=1", info.url, repo_root }, {}, function(r)
			if r.code == 0 then
				compile(lang, repo_root, info)
			else
				notify("clone failed for " .. lang, vim.log.levels.ERROR)
			end
		end)
	end
end

function M.install(lang)
	local info = M.registry[lang]
	if not info then notify("unknown parser: " .. lang, vim.log.levels.WARN); return end
	vim.fn.mkdir(parser_dir, "p")
	vim.fn.mkdir(src_dir, "p")
	clone_or_pull(lang, info, false)
end

function M.update(lang)
	local targets = {}
	if lang and lang ~= "" then
		if not M.registry[lang] then notify("unknown parser: " .. lang, vim.log.levels.WARN); return end
		targets = { lang }
	else
		for l in pairs(M.registry) do
			if M.is_installed(l) then table.insert(targets, l) end
		end
	end
	if #targets == 0 then notify("no installed parsers to update"); return end
	notify("updating " .. #targets .. " parser(s)…")
	for _, l in ipairs(targets) do clone_or_pull(l, M.registry[l], true) end
end

function M.remove(lang)
	vim.fn.delete(parser_dir .. "/" .. lang .. ".so")
	vim.fn.delete(query_dir .. "/" .. lang, "rf")
	notify("removed " .. lang)
end

function M.install_missing(langs)
	for _, lang in ipairs(langs) do
		if not M.is_installed(lang) then M.install(lang) end
	end
end

-- Commands
vim.api.nvim_create_user_command("ParserInstall", function(opts)
	M.install(opts.args)
end, { nargs = 1, complete = function() return vim.tbl_keys(M.registry) end })

vim.api.nvim_create_user_command("ParserInstallAll", function()
	M.install_missing(vim.tbl_keys(M.registry))
end, {})

vim.api.nvim_create_user_command("ParserUpdate", function(opts)
	M.update(opts.args)
end, { nargs = "?", complete = function() return vim.tbl_keys(M.registry) end })

vim.api.nvim_create_user_command("ParserRemove", function(opts)
	M.remove(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("ParserList", function()
	local lines = { "Parser status:", "" }
	for lang in vim.spairs(M.registry) do
		local mark = M.is_installed(lang) and "✓" or "✗"
		table.insert(lines, string.format("  %s  %s", mark, lang))
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, {})

return M

