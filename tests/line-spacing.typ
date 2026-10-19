#import "../templates/layout.typ": word-par, line-heights

// 验证自动换行和新段落没有因字体混排或上标产生额外间距。
#let check-spacing(font, size, height) = {
  set text(font: font, size: size, lang: "zh")
  let styled = word-par.with(height: height, indent: 0pt)
  let single = measure(styled[中文 Abc xyz]).height
  let wrapped = measure(styled[中文 Abc xyz\ 中文 Abc xyz]).height
  let paragraphs = measure(styled[中文 Abc xyz

    中文 Abc xyz]).height
  let superscript = measure(styled[中文#super[1] Abc xyz\ 中文 Abc xyz]).height
  let formula = measure(styled[中文 $x + y$ Abc\ 中文 Abc xyz]).height
  let automatic = measure(block(width: 100pt, styled[中文 Abc xyz 中文 Abc xyz 中文 Abc xyz 中文 Abc xyz])).height
  let line-count = automatic / height
  assert(line-count > 1 and calc.abs(line-count - calc.round(line-count)) < 0.001,
    message: "自动换行的行框高度不一致")
  for actual in (wrapped - single, paragraphs - single, superscript - single, formula - single) {
    assert(calc.abs(actual - height) < 0.01pt, message: "基线距离偏离校准值：" + repr(actual))
  }
}

#context {
  let mixed = ((name: "Times New Roman", covers: "latin-in-cjk"), "SimSun")
  check-spacing("SimSun", 10.5pt, line-heights.body)
  check-spacing(mixed, 10.5pt, line-heights.body)
  check-spacing(mixed, 12pt, line-heights.body)
  check-spacing("Times New Roman", 12pt, line-heights.body)
  check-spacing("SimHei", 14pt, line-heights.large)
  check-spacing(mixed, 9pt, line-heights.single)
  check-spacing(mixed, 13pt, line-heights.authorization)
  check-spacing("FangSong_GB2312", 16pt, line-heights.large)
}

行距校准检查通过。
