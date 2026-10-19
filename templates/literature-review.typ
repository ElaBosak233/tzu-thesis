#import "@preview/cuti:0.4.0": show-cn-fakebold
#import "fonts.typ": fonts, sizes
#import "layout.typ": word-grid, line-heights, line-edges, word-par
#import "styles.typ": academic-body
#import "pages/bibliography.typ": bibliography-page

// 来自 2027 文献综述原件，已通过 Word 保留网格的 PDF 校准。
// 四号黑体单倍行距同样占两个 15.6pt 网格，因此一级标题仍是 31.2pt。
#let literature-review(
  title: "毕业设计题目",
  student: "张三",
  advisor: "李四",
  second-advisor: none,
  abstract: [摘要内容],
  keywords: ("关键词1", "关键词2", "关键词3"),
  header: "人工智能学院毕业设计文献综述",
  bibliography: none,
  bibliography-full: false,
  bibliography-style: "gb-7714-2015-numeric",
  body,
) = {
  assert(type(keywords) == array, message: "keywords 应为包含 3–6 个关键词的数组。")
  assert(keywords.len() >= 3 and keywords.len() <= 6, message: "文献综述需要 3–6 个关键词。")
  assert(bibliography != none, message: "请为文献综述传入 bibliography.with(文献库路径)。")

  set std.document(title: "“" + title + "”文献综述", author: student)
  set page(
    paper: "a4",
    margin: (left: 3cm, right: 2.5cm, top: 79.4pt, bottom: 2.5cm),
    numbering: "1",
    header-ascent: 27.8pt,
    footer-descent: 0.75cm,
    header: {
      set text(font: (fonts.main, fonts.宋体), size: sizes.小五, top-edge: 0pt, bottom-edge: 0pt)
      set par(justify: false, first-line-indent: 0pt, leading: 0pt, spacing: 0pt)
      box(width: 100%, height: 0pt)[
        #place(top + center, text(header))
        #place(top + left, dx: -1.44pt, dy: 3.96pt,
          line(length: 100% + 2.88pt, stroke: 0.72pt + black))
      ]
    },
    footer: context {
      set text(font: fonts.main, size: sizes.小四, top-edge: 0pt, bottom-edge: 0pt)
      set par(justify: false, first-line-indent: 0pt, leading: 0pt, spacing: 0pt)
      align(center, move(dy: 0.68pt, counter(page).display(page.numbering)))
    },
  )
  counter(page).update(1)
  set text(font: ((name: fonts.main, covers: "latin-in-cjk"), fonts.宋体), size: sizes.五号, lang: "zh")
  show: show-cn-fakebold
  show: word-par

  // 首页各块使用正常文档流，长题名和摘要可以自然换行、分页。
  v(2 * word-grid)
  block(width: 100%, above: 0pt, below: word-grid, sticky: true)[
    #set align(center)
    #set par(first-line-indent: 0pt, justify: false)
    #set text(font: (fonts.main, fonts.黑体), size: sizes.三号, weight: "regular", ..line-edges(line-heights.large))
    “#title”文献综述
  ]
  block(width: 100%, above: word-grid, below: word-grid, sticky: true)[
    #set align(center)
    #set par(first-line-indent: 0pt, justify: false)
    #set text(font: (fonts.main, fonts.楷体), size: sizes.五号)
    学生姓名：#student#h(0.75em)指导教师：#advisor#if second-advisor != none [、#second-advisor]
  ]
  block(above: 0pt, below: 0pt)[
    #set par(first-line-indent: 0pt)
    #text(font: fonts.黑体, weight: "bold")[摘要：]#abstract
  ]
  block(above: 0pt, below: 0pt)[
    #set par(first-line-indent: 0pt)
    #text(font: fonts.黑体, weight: "bold")[关键词：]#keywords.join("；")
  ]

  // 综述三级标题为小四号；其余正文规则与论文共用。
  show: academic-body.with(heading-sizes: (sizes.四号, sizes.小四, sizes.小四))
  body

  pagebreak()
  bibliography-page(
    bib: bibliography,
    full: bibliography-full,
    style: bibliography-style,
    heading-weight: "bold",
  )
}
