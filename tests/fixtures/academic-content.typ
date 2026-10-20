#import "../../templates/common/utils.typ": three-line-table

= 正文布局检查
== 二级标题
=== 三级标题
==== 四级标题

BASELINEONE 中文 $x + y$。\
BASELINETWO 中文 $x + y$。

#set math.equation(numbering: "(1)")

$ "EQONE" = x + y $ <eq:one>

$ "EQTWO" = x - y $ <eq:two>

$ "EQTHREE" = frac(sum_(i=1)^n i^2, 1 + sqrt(1 + x^2)) $ <eq:tall>

$ "MULTIONE" &= x + y \
  "MULTITWO" &= x - y \
  "MULTITALL" &= frac(sum_(i=1)^n i, 1 + y^2) $ <eq:multi>

AFTERFORMULA 参见 @eq:one、@eq:two 和 @eq:multi。

#pagebreak()

= 图表间距

FIGUREBEFORE 图表之前的正文。

#figure(
  rect(width: 100pt, height: 24pt),
  caption: [CAPTIONONE],
) <fig:one>

#figure(
  three-line-table(columns: 2, header: ("列甲", "列乙"), [数据甲], [数据乙]),
  caption: [CAPTIONTWO],
) <fig:two>

#figure(
  rect(width: 120pt, height: 30pt),
  caption: [CAPTIONTHREE 这是一段刻意加长的图题，用来检查图题自动换行后，下一段正文仍与图题保持距离，并保留完整的字号和行距。],
) <fig:three>

FIGUREAFTER 参见 @fig:one、@fig:two 和 @fig:three。

#pagebreak()
#v(620pt)

= 页底标题

$ "PAGEBREAK" = frac(sum_(i=1)^n i^2, sqrt(1 + x^2)) $
