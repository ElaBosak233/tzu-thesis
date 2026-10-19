#import "../fonts.typ": fonts, sizes
#import "../layout.typ": line-heights, word-par, page-heading

#let acknowledgement-content = state("acknowledgement", "")

#let acknowledgement(
  body,
) = {
  context acknowledgement-content.update(body)
}

#let acknowledgement-page() = {
  set text(font: ((name: fonts.main, covers: "latin-in-cjk"), fonts.宋体), size: sizes.小四)
  show: word-par
  page-heading(size: sizes.小三, height: line-heights.large)[谢#h(1em)辞]
  context acknowledgement-content.final()
}
