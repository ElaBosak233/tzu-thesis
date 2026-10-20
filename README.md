# 基于 Typst 的台州学院学位论文模板

> [!IMPORTANT]
> 本项目为非官方项目，未获得官方支持。目前仍处于早期开发阶段，功能尚未稳定，可能随时发生变更或出现异常。

已依据 2027 届原版 Word 对封面、正文、摘要、目录、标题、参考文献和页码进行排版校准，详见[校准说明](docs/word-layout-matching.md)。正文的 23.4pt 行高对应这份原版保留网格后的实际效果，并非通用的 Word 行距换算。

## 使用

编辑根目录的 `main.typ` 填写学位论文，通过对应的论文模板导入：

```typ
#import "templates/thesis/lib.typ": thesis, abstract, abstract-en, acknowledgement, authorization, commitment
```

```sh
typst compile --font-path assets/fonts main.typ dist/main.pdf
```

`thesis.with(graduation-year: 2027)` 可以将届别与 `date` 完成日期分别设置。

编辑根目录的 `literature-review.typ` 填写文献综述，通过对应的综述模板导入。已依据同届 Word 原件校准题名、作者、同页摘要、三级标题、固定页眉与参考文献：

```typ
#import "templates/literature-review/lib.typ": literature-review
```

```sh
typst compile --font-path assets/fonts literature-review.typ dist/literature-review.pdf
```

两种材料分别使用 `thesis.with(...)` 和 `literature-review.with(...)`，可以共用 `ref.bib`；参考文献默认只列实际引用的条目，综述示例为展示排版设置了 `bibliography-full: true`。参数、原版测量值和验证命令见[文献综述说明](docs/literature-review-plan.md)。

## 目录结构

```text
main.typ                    # 学位论文写作与编译入口
literature-review.typ       # 文献综述写作与编译入口
ref.bib                     # 共用文献库
templates/
  thesis/
    lib.typ                 # 论文模板入口，导出 thesis 与论文内容接口
    pages/                  # 论文专属的封面、摘要、目录、声明等页面
  literature-review/
    lib.typ                 # 综述模板入口，导出 literature-review
  common/                   # 共用字体、行框、正文样式、参考文献和工具
assets/                     # 字体、图片、签名与学校标识
docs/                       # 使用、目录约定与排版校准说明
tests/                      # 排版检查与集成样本
dist/                       # 编译产物，已被 Git 忽略
```

模板按材料类型分目录，`lib.typ` 是各材料的导入入口；共用引用与表格工具从 `templates/common/utils.typ` 导入。目录职责、扩展约定与旧路径迁移见[模板目录说明](docs/template-structure.md)。
