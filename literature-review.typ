#import "templates/document.typ": document

// 此文件是排版示例。请替换为自己的题目、摘要和正文。
// 原版要求：1500 字以上、至少 20 篇参考文献、阅读至少两篇外文原文文献。
#show: document.with(
  mode: "literature-review",
  title: "毕业设计题目",
  student: "张三",
  advisor: "李四",
  abstract: [摘要内容],
  keywords: ("关键词1", "关键词2", "关键词3"),
  bibliography: bibliography.with("ref.bib"),
  // 示例没有实际引文，先展示文献库全部条目；成稿按实际引用可删除此项。
  bibliography-full: true,
)

= 一级标题一

正文内容……

= 一级标题二

正文内容……

= 一级标题三

== 二级标题1

正文内容……

== 二级标题2

正文内容………………………………

=== 三级标题1

正文内容……

=== 三级标题2

正文内容……
