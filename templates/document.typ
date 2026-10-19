#import "thesis.typ": thesis, abstract, abstract-en, acknowledgement, authorization, commitment
#import "literature-review.typ": literature-review

// 保留 thesis 的旧入口；统一入口只分发模式，不共享各材料的页码和状态。
#let document(mode: "thesis", ..args) = {
  let render = (
    thesis: thesis,
    "literature-review": literature-review,
  ).at(mode, default: none)
  assert(render != none, message: "未知材料模式：" + repr(mode) + "。可选 thesis 或 literature-review。")
  render(..args)
}
