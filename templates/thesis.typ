#import "@preview/cuti:0.4.0": show-cn-fakebold

#import "fonts.typ": fonts, sizes
#import "layout.typ": word-grid, line-heights, line-edges, word-par
#import "patches.typ": patch-enum-item, patch-list-item
#import "styles.typ": academic-body
#import "pages/cover.typ": cover
#import "pages/authorization.typ": authorization, authorization-page
#import "pages/abstract.typ": abstract, abstract-page
#import "pages/abstract-en.typ": abstract-en, abstract-en-page
#import "pages/toc.typ": toc
#import "pages/bibliography.typ": bibliography-page
#import "pages/acknowledgement.typ": acknowledgement, acknowledgement-page
#import "pages/commitment.typ": commitment, commitment-page

#let thesis(
  title: "基于 Typst 的台州学院学位论文模板",
  title-en: "A Thesis Template Based on Typst",
  school: "人工智能学院",
  major: "计算机科学与技术（奇安信）",
  class: "23 计算机奇安信班",
  uid: "2362120000",
  student: "张三",
  advisor: "李四",
  second-advisor: none,
  date: datetime.today(),
  graduation-year: none,
  bibliography: none,
  body,
) = {
  set page(
    paper: "a4",
    margin: (left: 3cm, right: 2.5cm, bottom: 2.5cm, top: 2.5cm),
    header-ascent: 1cm,
    footer-descent: 0.75cm,
    footer: context {
      if page.numbering != none {
        let roman = page.numbering == "I"
        set text(font: fonts.main, size: if roman { sizes.小五 } else { sizes.小四 }, top-edge: 0pt, bottom-edge: 0pt)
        set par(first-line-indent: 0pt, leading: 0pt, spacing: 0pt)
        align(center, move(dy: if roman { -6pt } else { 0pt }, counter(page).display(page.numbering)))
      }
    },
  )

  cover(title, school, major, class, uid, student, advisor, second-advisor, date, graduation-year: graduation-year)

  pagebreak()

  authorization-page(date)
  abstract-page()
  abstract-en-page()

  toc

  set page(numbering: "1")

  counter(page).update(1)

  show: show-cn-fakebold

  show: word-par

  align(center)[
    #set par(first-line-indent: 0pt, justify: false)
    // 原版首页题目首行基线距正文区域顶部约 37pt。
    #v(word-grid)
    #block(below: word-grid)[
      #set text(font: (fonts.main, fonts.黑体), size: sizes.三号, ..line-edges(line-heights.large))
      #title
    ]
    #block(below: word-grid)[
      #set text(font: fonts.main, size: sizes.三号, weight: "bold", ..line-edges(line-heights.large))
      #title-en
    ]

    #text(font: fonts.楷体, size: sizes.小五)[
      #school#h(1em)#major

      #student

      指导教师：#advisor#if second-advisor != none [、#second-advisor]
    ]
  ]

  show: academic-body

  body

  pagebreak()
  bibliography-page(bib: bibliography)

  pagebreak()
  acknowledgement-page()

  pagebreak()
  commitment-page(date)
}
