#import "../templates/document.typ": document
#import "../templates/utils.typ": parencite, three-line-table

// 多页集成样本：验证长题名、跨页摘要与正文、引用和图表。
#show: document.with(
  mode: "literature-review",
  title: "面向高校毕业设计管理的多源数据融合与智能分析系统的设计与实现及其相关技术研究进展",
  student: "测试学生",
  advisor: "测试导师",
  second-advisor: "第二导师",
  abstract: [
    #for i in range(12) [
      文献综述需要整理研究历史、比较现有方法，并分析研究问题和发展趋势。
      本段使用中英混排 Typst、Word 与 PDF 检查长摘要的自动换行和跨页布局。

    ]
  ],
  keywords: ("研究历史", "研究现状", "发展趋势"),
  bibliography: bibliography.with("../ref.bib"),
)

= 引言

第一条引用应从一开始 @cai2021densenet。同处多篇引用 @zhao2021multimodal @qi2021citespace。

由#parencite(<cai2021densenet>)可知，正文引用与上标引用应共用编号。

== 研究现状

#for i in range(18) [
  这是第 #i 段跨页正文，用于检查首行缩进、两端对齐及连续页码。
  含中英混排 natural language processing 与基线校准，不能因语言和字体切换改变行高。

]

=== 具体方法

三级标题应为小四号黑体，紧接正文不与标题分到不同页面。

#figure(
  three-line-table(columns: 2, header: ("方法", "特点"), [方法一], [文字内容], [方法二], [中英混排 Word]),
  caption: [综述示例表],
) <review:table>

正文能够引用#ref(<review:table>)，并继续引用其他文献 @wu2022ai @chen2018peer @dong2020pganet。

= 发展趋势

新章的图表编号应重新开始。

#figure(rect(width: 4cm, height: 1cm), caption: [综述示例图]) <review:figure>

参见#ref(<review:figure>)。
