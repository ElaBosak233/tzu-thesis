# 基于 Typst 的台州学院学位论文模板

> [!IMPORTANT]
> 本项目为非官方项目，未获得官方支持。目前仍处于早期开发阶段，功能尚未稳定，可能随时发生变更或出现异常。

已依据 2027 届原版 Word 对封面、正文、摘要、目录、标题、参考文献和页码进行排版校准，详见[校准说明](docs/word-layout-matching.md)。正文的 23.4pt 行高对应这份原版保留网格后的实际效果，并非通用的 Word 行距换算。

```sh
typst compile --font-path assets/fonts main.typ dist/main.pdf
```

`thesis.with(graduation-year: 2027)` 可以将届别与 `date` 完成日期分别设置。
