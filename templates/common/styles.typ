#import "fonts.typ": fonts, sizes
#import "layout.typ": word-grid, line-heights, line-edges

// 两种材料共用正文、编号、图表和引用规则；字号差异由各材料模板传入。
// 行框及伪粗体由外层模板设置，首页和后置页面可继续独立覆盖样式。
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
      } else {
        n.map(str).join(".")
      }
    },
  )

  // 四级及更深标题沿用三级样式，避免回落到 Typst 默认字号和段距。
  show heading: set text(
    font: (fonts.main, fonts.黑体), weight: "regular", size: heading-sizes.at(2),
    ..line-edges(line-heights.body),
  )
  show heading: set par(first-line-indent: 0pt, leading: 0pt, spacing: 0pt, justify: false)
  show heading: set align(left)
  show heading.where(level: 1): set text(size: heading-sizes.at(0), ..line-edges(line-heights.large))
  show heading.where(level: 2): set text(size: heading-sizes.at(1), ..line-edges(line-heights.body))
  show heading: set block(above: 0.5 * word-grid, below: 0.5 * word-grid)
  show heading.where(level: 1): set block(above: word-grid, below: word-grid)

  set text(
    font: ((name: fonts.main, covers: "latin-in-cjk"), fonts.宋体),
    size: sizes.五号,
    lang: "zh",
  )

  // 普通段落以完整行框排版、额外段距为零；块级内容必须另设留白。
  // 公式使用自然高度，分式、上下标和多行推导不受固定行框裁切。
  show math.equation.where(block: true): set block(above: word-grid, below: word-grid)
  show math.equation.where(block: true): set par(leading: word-grid)

  show figure: set block(above: 0.5 * word-grid, below: 0.5 * word-grid)

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
