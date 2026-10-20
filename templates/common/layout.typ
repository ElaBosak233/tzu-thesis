#import "fonts.typ": fonts

// 2027 Word 原版：w:docGrid/@w:linePitch = 312 twips = 15.6pt。
// 基线距离由保留网格的 Word 导出 PDF 校准，不是通用的倍数换算。
#let word-grid = 15.6pt
#let line-heights = (
  body: 23.4pt,
  large: 31.2pt,
  single: 15.6pt,
  authorization: 24pt,
)

// 整行高度纳入排版框，使中英混排保持同一基线距离。
// 0.34em 与原版普通文本在行框中的基线位置接近。
#let line-edges(height) = (
  top-edge: height / 2 + 0.34em,
  bottom-edge: -height / 2 + 0.34em,
)

#let word-par(height: line-heights.body, indent: 2em, justify: true, body) = {
  // 原版未启用自动断词，避免两端对齐后英文默认产生连字符换行。
  set text(hyphenate: false, ..line-edges(height))
  set par(
    leading: 0pt,
    spacing: 0pt,
    first-line-indent: (amount: indent, all: true),
    justify: justify,
  )
  // 上标只占字形的空间，避免继承完整行框后撑高引用所在行。
  show super: set text(top-edge: "bounds", bottom-edge: "bounds")
  body
}

// 保留目录/书签语义，独立设置前后置页面的无编号标题。
#let page-heading(
  size: 12pt,
  font: fonts.黑体,
  weight: "regular",
  height: line-heights.body,
  before: 1.5 * word-grid,
  after: 1.5 * word-grid,
  outlined: true,
  body,
) = {
  show heading: set text(font: font, size: size, weight: weight, ..line-edges(height))
  show heading: set align(center)
  show heading: set par(leading: 0pt, spacing: 0pt, first-line-indent: 0pt, justify: false)
  show heading: set block(above: 0pt, below: after)
  v(before)
  heading(numbering: none, outlined: outlined, body)
}
