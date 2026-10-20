#import "@preview/cuti:0.4.0": show-fakebold

#import "../../common/fonts.typ": fonts, sizes
#import "../../common/layout.typ": line-edges, line-heights

#let cover(
  title,
  school,
  major,
  class,
  uid,
  student,
  advisor,
  second-advisor,
  date,
  graduation-year: none,
) = {
  let year = if graduation-year == none { date.year() } else { graduation-year }
  show: show-fakebold
  set page(numbering: none)
  set text(overhang: false)
  set par(justify: false, first-line-indent: 0pt, leading: 0pt, spacing: 0pt)

  // 坐标取自原版 Word 导出的封面，均换算到正文区域的左上角。
  // 固定封面各区域的位置，避免正文行距或字体设置改变封面留白。
  block(width: 100%, height: 100%, breakable: false)[
    #place(top + left, dx: 85.05pt - 3cm, dy: 77.27pt - 2.5cm,
      image("/assets/vi/tzu-logo.png", width: 80.85pt))
    #place(top + left, dx: 168.4pt - 3cm, dy: 178pt - 2.5cm,
      image("/assets/vi/tzu-text.svg", width: 9.5cm))

    #place(top + left, dx: 132.11pt - 3cm, dy: 288.17pt - 2.5cm,
      box(scale(x: 200%, reflow: true,
        text(font: fonts.华文新魏, size: sizes.一号, weight: "bold",
          tracking: 2pt, top-edge: 0pt, bottom-edge: 0pt)[本科毕业设计])))
    #place(top + left, dx: 251.93pt - 3cm, dy: 335.96pt - 2.5cm,
      box(text(font: fonts.黑体, size: sizes.二号, weight: "bold",
        tracking: 0.32pt, top-edge: 0pt, bottom-edge: 0pt)[（#year#h(6pt)届）]))

    #place(top + left, dx: 134.56pt - 3cm,
      dy: 450.96pt - (line-heights.large / 2 + 0.34 * sizes.三号) - 2.5cm,
      block(width: 380.96pt)[
        #set text(size: sizes.三号, ..line-edges(line-heights.large))
        #set align(left)

        // 宋体标签和楷体填写内容共用基线；每行 31.2pt。
        // 长内容自动增高该行，后面的字段随之下移。
        #let info-row(label, value, key-width: 64pt) = grid(
          columns: (key-width, 1fr),
          align: top,
          column-gutter: 0pt,
          text(font: fonts.宋体, label),
          block(width: 100%, below: 0pt,
            stroke: (bottom: 0.72pt + black),
            // 下划线中心在基线下方 2.28pt，不改变行高。
            outset: (bottom: -7.88pt),
          )[
            #set text(font: (fonts.main, fonts.楷体))
            #set align(center)
            #box(width: 0pt, height: 0pt)#value
          ],
        )

        #info-row([题#h(2em)目], title)
        #info-row([学#h(2em)院], school)
        #info-row([专#h(2em)业], major)
        #info-row([班#h(2em)级], class)
        #info-row([学#h(2em)号], uid)
        #info-row([学生姓名], student)
        #info-row([指导教师], advisor)
        #if second-advisor != none {
          info-row([第二指导教师], second-advisor, key-width: 96pt)
        }
        #info-row([完成日期], date.display("[year]年[month]月"))
      ],
    )
  ]
}
