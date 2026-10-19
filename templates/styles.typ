#import "fonts.typ": fonts, sizes
#import "layout.typ": word-grid, line-heights, line-edges

// 两种材料共用正文、编号、图表和引用规则；字号差异由各模式传入。
// 行框及伪粗体由外层模式设置，首页和后置页面可继续独立覆盖样式。
#let academic-body(
  heading-sizes: (sizes.四号, sizes.小四, sizes.五号),
  body,
) = {
  set heading(
    numbering: (..nums) => {
      let level = nums.pos().len()
      let n = nums.pos()

      if level == 1 {
        numbering("1.", ..n)
      } else if level == 2 {
        numbering("1.1", ..n)
      } else if level == 3 {
        numbering("1.1.1", ..n)
      }
    },
  )

  show heading: set text(font: (fonts.main, fonts.黑体), weight: "regular")
  show heading: set par(first-line-indent: 0pt, leading: 0pt, spacing: 0pt, justify: false)
  show heading: set align(left)
  show heading.where(level: 1): set text(size: heading-sizes.at(0), ..line-edges(line-heights.large))
  show heading.where(level: 2): set text(size: heading-sizes.at(1), ..line-edges(line-heights.body))
  show heading.where(level: 3): set text(size: heading-sizes.at(2), ..line-edges(line-heights.body))
  show heading.where(level: 1): set block(above: word-grid, below: word-grid)
  show heading.where(level: 2): set block(above: 0.5 * word-grid, below: 0.5 * word-grid)
  show heading.where(level: 3): set block(above: 0.5 * word-grid, below: 0.5 * word-grid)

  set text(
    font: ((name: fonts.main, covers: "latin-in-cjk"), fonts.宋体),
    size: sizes.五号,
    lang: "zh",
  )

  show figure.where(
    kind: table,
  ): set figure.caption(position: top)

  // 图表共享编号
  show figure.where(kind: table): set figure(kind: image, supplement: [表])

  show figure.where(kind: image): set figure(supplement: [图])

  set figure(
    gap: 0.5 * word-grid,
    numbering: n => {
      let ch = counter(heading).get().first()

      numbering("1-1", ch, n)
    },
  )

  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    it
  }

  set figure.caption(separator: h(2em))
  show figure.caption: set text(font: (fonts.main, fonts.宋体), size: sizes.五号)
  show figure.caption: set par(first-line-indent: 0pt, justify: false)

  show cite: it => {
    set text(font: fonts.宋体, size: sizes.五号, baseline: -0.1em)
    super(it)
  }


  body
}
