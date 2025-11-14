local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node


ls.config.set_config({
    enable_autosnippets = true,
})


-- math detection (vimtex)
local function M() return vim.fn["vimtex#syntax#in_mathzone"]() == 1 end


local symbols = {
  -- Greek lowercase
  { trig = "@a",      tex = "\\alpha" },
  { trig = "@b",       tex = "\\beta" },
  { trig = "@g",      tex = "\\gamma" },
  { trig = "@d",      tex = "\\delta" },
  { trig = "@e",    tex = "\\epsilon" },
  { trig = "@ve", tex = "\\varepsilon" },
  { trig = "@z",       tex = "\\zeta" },
--  { trig = "@e",        tex = "\\eta" },
  { trig = "@q",      tex = "\\theta" },
  { trig = "@vte",   tex = "\\vartheta" },
  { trig = "@i",       tex = "\\iota" },
  { trig = "@k",      tex = "\\kappa" },
  { trig = "@vk",   tex = "\\varkappa" },
  { trig = "@l",     tex = "\\lambda" },
  { trig = "@m",         tex = "\\mu" },
  { trig = "@n",         tex = "\\nu" },
  { trig = "@x",         tex = "\\xi" },
  { trig = "@p",         tex = "\\pi" },
  { trig = "@vp",      tex = "\\varpi" },
  { trig = "@r",        tex = "\\rho" },
  { trig = "@vr",     tex = "\\varrho" },
  { trig = "@s",      tex = "\\sigma" },
  { trig = "@vs",   tex = "\\varsigma" },
  { trig = "@t",        tex = "\\tau" },
  { trig = "@u",    tex = "\\upsilon" },
  { trig = "@f",        tex = "\\phi" },
  { trig = "@vf",     tex = "\\varphi" },
  { trig = "@c",        tex = "\\chi" },
  { trig = "@ps",        tex = "\\psi" },
  { trig = "@w",      tex = "\\omega" },

  -- Greek uppercase (all plain roman)
  { trig = "@G",    tex = "\\Gamma" },
  { trig = "@D",    tex = "\\Delta" },
  { trig = "@T",    tex = "\\Theta" },
  { trig = "@L",   tex = "\\Lambda" },
  { trig = "@X",       tex = "\\Xi" },
  { trig = "@P",       tex = "\\Pi" },
  { trig = "@S",    tex = "\\Sigma" },
  { trig = "@U",  tex = "\\Upsilon" },
  { trig = "@PH",      tex = "\\Phi" },
  { trig = "@PS",      tex = "\\Psi" },
  { trig = "@W",    tex = "\\Omega" },
}
local snippets = {}
for _, entry in ipairs(symbols) do
  table.insert(snippets, s(
    { trig = entry.trig, snippetType = "autosnippet", condition = M },
    t(entry.tex)
  ))
end


--- Generates the LuaSnip node list for an R-row by C-column LaTeX table body.
local function dynamic_table(R, C)
  local nodes = {}
  local current_index = 1

  -- Loop through each row
  for r = 1, R do
      -- Loop through each column
      for c = 1, C do
          -- Insert the input field (tab-stop)
          table.insert(nodes, ls.insert_node(current_index))
          current_index = current_index + 1

          -- Add '&' separator if it's not the last column
          if c < C then
              table.insert(nodes, t(" & "))
          end
      end

      -- Add row break '\\ \n' if it's not the last row
      if r < R then
          table.insert(nodes, t( {"\\\\",""}))
      end
  end
    return nodes
end

for R = 1, 10 do
    -- Inner loop for columns (C, 1 to 10)
    for C = 1, 10 do
        -- 1. Create the trigger: e.g., "3x5"
        local trigger = R .. "x" .. C

        -- 2. Create the snippet definition
        local new_snippet = s({trig = trigger,snippetType="autosnippet", condition=M, wordTrig=false, dscr = string.format("LaTeX %dx%d Table Body", R, C)},
            dynamic_table(R, C)
        )

        -- 3. Add the new snippet to the list
        table.insert(snippets, new_snippet)
    end
end




local others ={

-------------------------------
--  FRACTION SMART SNIPPET
-------------------------------
-- expands "{x}/" → \frac{x}{•}
s(
  {
    trig = "(%b{})/",
    regTrig = true,
    wordTrig = false,
    snippetType = "autosnippet",
    condition = M,
  },

  -- ✅ THIS MUST BE A SINGLE NODE LIST
  {
    f(function(_, snip)
      local content = snip.captures[1]             -- "{expr}"
      local inner = content:sub(2, -2)             -- → expr
      return "\\frac{" .. inner .. "}{"
    end),
    i(1),
    t("}")                                         -- ✅ NOW INCLUDED PROPERLY
  }
),



-------------------------------
--  BASIC ARROWS
-------------------------------
s({ trig = "->", snippetType="autosnippet", condition=M, wordTrig=false }, t("\\rightarrow")),
s({ trig = "<-", snippetType="autosnippet", condition=M, wordTrig=false }, t("\\leftarrow")),
s({ trig = "<->", snippetType="autosnippet", condition=M, wordTrig=false }, t("\\Leftrightarrow")),
s({ trig = "=>", snippetType="autosnippet", condition=M, wordTrig=false }, t("\\implies")),
s({ trig = "<=", snippetType="autosnippet", condition=M, wordTrig=false }, t("\\Leftarrow")),
s({ trig = ">=", snippetType="autosnippet", condition=M, wordTrig=false }, t("\\Rightarrow")),
s({ trig = "iff", snippetType="autosnippet", condition=M }, t("\\iff")),
s({ trig = "maps", snippetType="autosnippet", condition=M }, t("\\mapsto")),

-------------------------------
--  RELATIONAL OPERATORS
-------------------------------
s({ trig="~=", snippetType="autosnippet", condition=M }, t("\\approx")),
s({ trig="==", snippetType="autosnippet", condition=M }, t("\\equiv")),
s({ trig="!=", snippetType="autosnippet", condition=M }, t("\\neq")),
s({ trig="<=", snippetType="autosnippet", condition=M }, t("\\leq")),
s({ trig=">=", snippetType="autosnippet", condition=M }, t("\\geq")),
s({ trig="::", snippetType="autosnippet", condition=M }, t("\\propto")),
s({ trig="~~", snippetType="autosnippet", condition=M }, t("\\sim")),
s({ trig=":=", snippetType="autosnippet", condition=M }, t("\\coloneqq")),
s({ trig="=:", snippetType="autosnippet", condition=M }, t("\\eqqcolon")),

-------------------------------
--  SETS
-------------------------------
s({ trig="RR", snippetType="autosnippet", condition=M }, t("\\mathbb{R}")),
s({ trig="NN", snippetType="autosnippet", condition=M }, t("\\mathbb{N}")),
s({ trig="ZZ", snippetType="autosnippet", condition=M }, t("\\mathbb{Z}")),
s({ trig="QQ", snippetType="autosnippet", condition=M }, t("\\mathbb{Q}")),
s({ trig="CC", snippetType="autosnippet", condition=M }, t("\\mathbb{C}")),
s({ trig="PP", snippetType="autosnippet", condition=M }, t("\\mathbb{P}")),
s({ trig="EE", snippetType="autosnippet", condition=M }, t("\\mathbb{E}")),
s({ trig="VV", snippetType="autosnippet", condition=M }, t("\\mathbb{V}")),



s({ trig="Re", snippetType="autosnippet", condition=M }, t("\\Re")),
s({ trig="Im", snippetType="autosnippet", condition=M }, t("\\Im")),
s({ trig="nb", snippetType="autosnippet", condition=M }, t("\\nabla")),
s({ trig="inf", snippetType="autosnippet", condition=M }, t("\\infty")),
-------------------------------
--  LOGICAL SYMBOLS
-------------------------------
s({ trig="tf", snippetType="autosnippet", condition=M }, t("\\therefore")),
s({ trig="bc", snippetType="autosnippet", condition=M }, t("\\because")),
s({ trig="and", snippetType="autosnippet", condition=M }, t("\\land")),
s({ trig="or", snippetType="autosnippet", condition=M }, t("\\lor")),
s({ trig="!>", snippetType="autosnippet", condition=M }, t("\\not\\Rightarrow")),
s({ trig="neg", snippetType="autosnippet", condition=M }, t("\\neg")),

-------------------------------
--  SPACING
-------------------------------
s({ trig="  ", snippetType="autosnippet", condition=M }, t("\\quad")),
s({ trig="\\quad  ", snippetType="autosnippet", condition=M }, t("\\qquad")),
s({ trig=";", snippetType="autosnippet", condition=M, wordTrig=false }, t("\\;")),
s({ trig=",,", snippetType="autosnippet", condition=M }, t("\\,")),

s({ trig="..", snippetType="autosnippet", condition=M }, t("\\dots")),
-------------------------------
--  CALCULUS
-------------------------------
s({ trig="dd", snippetType="autosnippet", condition=M }, t("\\,d")),
s({ trig="pp", snippetType="autosnippet", condition=M }, t("\\partial")),
s({ trig="oo", snippetType="autosnippet", condition=M }, t("\\infty")),
s({ trig="SS", snippetType="autosnippet", condition=M }, t("\\int")),
s({ trig="iSS", snippetType="autosnippet", condition=M }, t("\\iint")),
s({ trig="iiSS", snippetType="autosnippet", condition=M }, t("\\iiint")),
s({ trig="oSS", snippetType="autosnippet", condition=M }, t("\\oint")),

-------------------------------
--  OPERATORS
-------------------------------
s({ trig="lim", snippetType="autosnippet", condition=M }, t("\\lim")),
s({ trig="argmax", snippetType="autosnippet", condition=M }, t("\\argmax")),
s({ trig="argmin", snippetType="autosnippet", condition=M }, t("\\argmin")),
s({ trig="sup", snippetType="autosnippet", condition=M }, t("\\sup")),
s({ trig="inf", snippetType="autosnippet", condition=M }, t("\\inf")),
s({ trig="ker", snippetType="autosnippet", condition=M }, t("\\ker")),
s({ trig="span", snippetType="autosnippet", condition=M }, t("\\operatorname{span}")),
s({ trig="rank", snippetType="autosnippet", condition=M }, t("\\operatorname{rank}")),

-------------------------------
--  SET/LOGIC RELATIONS
-------------------------------
s({ trig="sub", snippetType="autosnippet", condition=M }, t("\\subseteq")),
s({ trig="sup", snippetType="autosnippet", condition=M }, t("\\supseteq")),
s({ trig="in", snippetType="autosnippet", condition=M }, t("\\in")),
s({ trig="nin", snippetType="autosnippet", condition=M }, t("\\notin")),
s({ trig="empty", snippetType="autosnippet", condition=M }, t("\\emptyset")),

-------------------------------
-- BAR
s(
  { trig="bar", snippetType="autosnippet", condition=M, wordTrig=true },
  { t("\\bar{"), i(1), t("}") }
  ),
  -- HAT
s(
  { trig="hat", snippetType="autosnippet", condition=M, wordTrig=true },
  { t("\\hat{"), i(1), t("}") }
),

-- TILDE
s(
  { trig="til", snippetType="autosnippet", condition=M, wordTrig=true },
  { t("\\tilde{"), i(1), t("}") }
),

-- VECTOR
s(
  { trig="vec", snippetType="autosnippet", condition=M, wordTrig=true },
  { t("\\vec{"), i(1), t("}") }
),

-- MATRIX
s(
  { trig="((", snippetType="autosnippet", condition=M },
  { t("\\left("), i(1), t("\\right)") }
),


s(
  { trig="[[", snippetType="autosnippet", condition=M },
  { t("\\left["), i(1), t("\\right]") }
),

s(
  { trig="{{", snippetType="autosnippet", condition=M },
  { t("\\left\\{"), i(1), t("\\right\\}") }
),

s(
  { trig="@(", snippetType="autosnippet", condition=M },
  { t({"\\left(","\\begin{matrix}",""}), i(1), t({"","\\end{matrix}","\\right)"}) }
),

s(
  { trig="@[", snippetType="autosnippet", condition=M },
  { t({"\\left[","\\begin{matrix}",""}), i(1), t({"","\\end{matrix}","\\right]"}) }
),

s(
  { trig="@{", snippetType="autosnippet", condition=M },
  { t({"\\left\\{","\\begin{matrix}",""}), i(1), t({"","\\end{matrix}","\\right\\}"}) }
),
s(
  { trig="_", snippetType="autosnippet", condition=M, wordTrig=false },
  { t("_{"), i(1), t("}") }
),

s(
  { trig="^", snippetType="autosnippet", condition=M, wordTrig=false },
  { t("^{"), i(1), t("}") }
),
s(
  { trig = "bf", snippetType = "autosnippet", condition = M, wordTrig = true },
  { t("\\boldsymbol{"), i(1), t("}") }
),

s(
  { trig = "tt", snippetType = "autosnippet", condition = M, wordTrig = true },
  { t("\\text{"), i(1), t("}") }
),
s(
  { trig = "sqrt", snippetType = "autosnippet", condition = M, wordTrig = true },
  { t("\\sqrt{"), i(1), t("}") }
),
s(
  { trig = "fr", snippetType = "autosnippet", condition = M, wordTrig = true },
  { t("\\frac{"), i(1), t("}{"),i(2), t("}") }
),
s(
  { trig = "sum", snippetType = "autosnippet", condition = M, wordTrig = true },
  { t("\\sum_{"), i(1), t("}^{"),i(2), t("}") }
),
s(
  { trig = "prod", snippetType = "autosnippet", condition = M, wordTrig = true },
  { t("\\prod_{"), i(1), t("}^{"),i(2), t("}") }
),
}

for _,element in ipairs(others) do
  table.insert(snippets,element)
end

return snippets
