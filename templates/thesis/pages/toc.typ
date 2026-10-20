#import "../../common/fonts.typ": fonts, sizes
#import "../../common/layout.typ": word-grid, line-heights, word-par, page-heading

#let toc = {
  set page(numbering: "I")
  set text(font: ((name: fonts.main, covers: "latin-in-cjk"), fonts.宋体), size: sizes.小四)
  show: word-par.with(indent: 0pt, justify: false)

  // 目录条目采用下方的基线行框，补偿与普通段落不同的首行位置。
  page-heading(size: sizes.小二, height: line-heights.large, before: 0pt, after: 1.5 * word-grid + 4.2pt, outlined: false)[目#h(1em)录]

  // 引导点由 repeat 排版，使用以基线为下边界的行框才能与文字对齐。
  show outline.entry: set text(top-edge: 1em, bottom-edge: 0pt)
  show outline.entry: set par(leading: line-heights.body - sizes.小四)
  show outline.entry: set block(above: line-heights.body - sizes.小四, below: 0pt)
  outline(depth: 3, title: none, indent: 21pt)
}
