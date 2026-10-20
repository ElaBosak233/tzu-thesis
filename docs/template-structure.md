# 模板目录约定

根目录的 `main.typ` 和 `literature-review.typ` 是填写内容、直接编译的文档；`templates/` 保存可复用的排版实现。两种材料各有同级目录和 `lib.typ` 入口，函数名称直接表达材料类型。

## 材料模板

| 目录 | 入口与职责 |
| --- | --- |
| `templates/thesis/` | `lib.typ` 导出 `thesis`、`abstract`、`abstract-en`、`authorization`、`acknowledgement`、`commitment`；负责完整学位论文的页面编排 |
| `templates/thesis/pages/` | 封面、授权书、中英文摘要、目录、谢辞、诚信承诺书等论文专属页面与内容状态 |
| `templates/literature-review/` | `lib.typ` 导出 `literature-review`；负责综述题名、作者、同页摘要、页眉页码及正文编排 |

两种材料分别编译，各自管理页面、计数器和内容状态。文献综述直接调用对应模板：

```typ
#import "templates/literature-review/lib.typ": literature-review

#show: literature-review.with(
  title: "毕业设计题目",
  abstract: [在此填写摘要。],
  keywords: ("关键词一", "关键词二", "关键词三"),
  bibliography: bibliography.with("ref.bib"),
)

= 引言
在此填写正文。
```

## 共用排版

| 文件 | 职责 |
| --- | --- |
| `templates/common/fonts.typ` | 字体名称与中文字号 |
| `templates/common/layout.typ` | Word 网格校准值、固定行框、段落和页面标题工具 |
| `templates/common/styles.typ` | 正文、多级标题、公式间距、图表编号、题注与引用样式 |
| `templates/common/bibliography.typ` | 两种材料共用的参考文献页面 |
| `templates/common/utils.typ` | 正文内引用 `parencite` 与三线表 `three-line-table` |
| `templates/common/patches.typ` | 列表排版补丁工具 |

材料模板依赖 `common/`；论文专属页面也可以依赖 `common/`。共用层不导入具体材料，各材料不导入彼此的专属页面。参考文献已被两种材料使用，因此放在共用层。

增加新材料时，在 `templates/<材料名>/lib.typ` 定义对应函数，并在根目录添加同名写作入口。专属页面按需要放入该材料的 `pages/`；多种材料实际共用的规则再抽取到 `common/`，材料间的字号和页面差异通过参数或各自编排处理。

## 旧路径迁移

本次调整移除了旧的平铺模板文件和 `document(mode: ...)` 分发接口。已有文档需更新导入路径：

| 旧用法 | 新用法 |
| --- | --- |
| `#import "templates/thesis.typ": thesis, ...` | `#import "templates/thesis/lib.typ": thesis, ...` |
| `#import "templates/document.typ": document`，配合 `document.with(mode: "literature-review", ...)` | `#import "templates/literature-review/lib.typ": literature-review`，配合 `literature-review.with(...)`，删除 `mode` 参数 |
| `document.with(mode: "thesis", ...)` | 从 `templates/thesis/lib.typ` 导入 `thesis`，改为 `thesis.with(...)` |
| `templates/literature-review.typ` | `templates/literature-review/lib.typ` |
| `templates/fonts.typ`、`layout.typ`、`styles.typ`、`utils.typ`、`patches.typ` | 对应的 `templates/common/<文件名>.typ` |
| `templates/pages/bibliography.typ` | `templates/common/bibliography.typ` |
| `templates/pages/` 下的其他页面 | `templates/thesis/pages/` 下的同名文件 |

仅调整模块组织与调用方式；写作入口、内容参数、资产路径、文献库位置及编译命令保持原有用法。
