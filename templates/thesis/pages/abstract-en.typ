#import "../../common/fonts.typ": fonts, sizes
#import "../../common/layout.typ": word-grid, line-heights, word-par, page-heading

#let abstract-en-content = state("abstract-en", "")

#let abstract-en-keywords = state("abstract-en-keywords", "")

#let abstract-en(
  keywords,
  body,
) = {
  context abstract-en-content.update(body)
  context abstract-en-keywords.update(keywords.join("; "))
}

#let abstract-en-page() = {
  set page(numbering: "I")

  set text(font: fonts.main, size: sizes.小四, lang: "en")
  show: word-par.with(indent: 2.5em)

  page-heading(size: sizes.四号, font: fonts.main, weight: "bold", height: line-heights.large, before: 0pt, outlined: false)[Abstract]

  context abstract-en-content.final()

  block(above: 1.5 * word-grid, below: 1.5 * word-grid)[
    #set par(first-line-indent: 0pt)
    #text(size: sizes.小四, weight: "bold")[Keywords: ]
    #text(
      size: sizes.小四,
    )[#context abstract-en-keywords.final()]
  ]
}
