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

  
-------------------------------
--  BASIC ARROWS
-------------------------------
  {trig = "->",tex="\\rightarrow"},
  {trig = "<-",tex="\\leftarrow"},
  {trig = "<->",tex="\\Leftrightarrow"},
  {trig = "=>",tex="\\implies"},
  {trig = "<=",tex="\\Leftarrow"},
  {trig = ">=",tex="\\Rightarrow"},
  {trig = "iff",tex="\\iff"},
  {trig = "maps",tex="\\mapsto"},

-------------------------------
--  RELATIONAL OPERATORS
-------------------------------
  {trig="~=",tex="\\approx"},
  {trig="==",tex="\\equiv"},
  {trig="!=",tex="\\neq"},
  {trig="<=",tex="\\leq"},
  {trig=">=",tex="\\geq"},
  {trig="::",tex="\\propto"},
  {trig="~~",tex="\\sim"},
  {trig=":=",tex="\\coloneqq"},
  {trig="=:",tex="\\eqqcolon"},

-------------------------------
--  SETS
-------------------------------
  {trig="RR",tex="\\mathbb{R}"},
  {trig="NN",tex="\\mathbb{N}"},
  {trig="ZZ",tex="\\mathbb{Z}"},
  {trig="QQ",tex="\\mathbb{Q}"},
  {trig="CC",tex="\\mathbb{C}"},
  {trig="PP",tex="\\mathbb{P}"},
  {trig="EE",tex="\\mathbb{E}"},
  {trig="VV",tex="\\mathbb{V}"},



  {trig="Re",tex="\\Re"},
  {trig="Im",tex="\\Im"},
  {trig="nb",tex="\\nabla"},
  {trig="inf",tex="\\infty"},
-------------------------------
--  LOGICAL SYMBOLS
-------------------------------
  {trig="tf",tex="\\therefore"},
  {trig="bc",tex="\\because"},
  {trig="and",tex="\\land"},
  {trig="or",tex="\\lor"},
  {trig="!>",tex="\\not\\Rightarrow"},
  {trig="neg",tex="\\neg"},

-------------------------------
--  SPACING
-------------------------------
  {trig="  ",tex="\\quad"},
  {trig="\\quad  ",tex="\\qquad"},
  {trig=";",tex="\\;"},
  {trig=",",tex="\\,"},
  {trig="..",tex="\\dots"},
-------------------------------
--  CALCULUS
-------------------------------
  {trig="dd",tex="\\,d"},
  {trig="pp",tex="\\partial"},
  {trig="oo",tex="\\infty"},
  {trig="SS",tex="\\int"},
  {trig="iSS",tex="\\iint"},
  {trig="iiSS",tex="\\iiint"},
  {trig="oSS",tex="\\oint"},

-------------------------------
--  OPERATORS
-------------------------------
  {trig="lim",tex="\\lim"},
  {trig="argmax",tex="\\argmax"},
  {trig="argmin",tex="\\argmin"},
  {trig="sup",tex="\\sup"},
  {trig="inf",tex="\\inf"},
  {trig="ker",tex="\\ker"},
  {trig="span",tex="\\operatorname{span}"},
  {trig="rank",tex="\\operatorname{rank}"},

-------------------------------
--  SET/LOGIC RELATIONS
-------------------------------
  {trig="sub",tex="\\subseteq"},
  {trig="sump",tex="\\supseteq"},
  {trig="in",tex="\\in"},
  {trig="nin",tex="\\notin"},
  {trig="empty",tex="\\emptyset"},

}
local snippets = {}
for _, entry in ipairs(symbols) do
  table.insert(snippets, s(
    { trig = entry.trig, snippetType = "autosnippet", condition = M },
    t(entry.tex)
  ))
end


local function dynamic_table(R, C)
  local nodes = {}
  local current_index = 1

  for r = 1, R do
      for c = 1, C do
          table.insert(nodes, ls.insert_node(current_index))
          current_index = current_index + 1

          if c < C then
              table.insert(nodes, t(" & "))
          end
      end

      if r < R then
          table.insert(nodes, t( {"\\\\",""}))
      end
  end
    return nodes
end

for R = 1, 10 do
    for C = 1, 10 do
        local trigger = R .. "x" .. C

        local new_snippet = s({trig = trigger,snippetType="autosnippet", condition=M, wordTrig=false, dscr = string.format("LaTeX %dx%d Table Body", R, C)},
            dynamic_table(R, C)
        )

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

  {
    f(function(_, snip)
      local content = snip.captures[1]             -- "{expr}"
      local inner = content:sub(2, -2)             -- → expr
      return "\\frac{" .. inner .. "}{"
    end),
    i(1),
    t("}")
  }
),



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
