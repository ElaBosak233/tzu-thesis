#import "@preview/cuti:0.4.0": show-cn-fakebold

#import "../../common/fonts.typ": fonts, sizes
#import "../../common/layout.typ": word-grid, word-par, page-heading

#let abstract-content = state("abstract", "")

#let abstract-keywords = state("abstract-keywords", "")

#let abstract(
  keywords,
  body,
) = {
  context abstract-content.update(body)
  context abstract-keywords.update(keywords.join("；"))
}

#let abstract-page() = {
  show: show-cn-fakebold

  set page(numbering: "I")

  show: word-par
  set text(font: ((name: fonts.main, covers: "latin-in-cjk"), fonts.宋体), size: sizes.小四, lang: "zh")

  page-heading(weight: "bold", before: 0pt, outlined: false)[摘#h(1em)要]

  context abstract-content.final()

  block(above: 1.5 * word-grid, below: 1.5 * word-grid)[
    #set par(first-line-indent: 0pt)
    #text(font: fonts.黑体, size: sizes.小四, weight: "bold")[关键词：]
    #text(font: (fonts.main, fonts.宋体), size: sizes.小四)[#context abstract-keywords.final()]
  ]
}
