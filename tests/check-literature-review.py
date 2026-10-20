"""综述 PDF 集成检查。依赖 Typst 0.14+ 和 Python pdfplumber。

从仓库根目录运行：python3 tests/check-literature-review.py
临时文献条目仅供分页测试，不写入用户的文献库或示例成稿。
"""

from pathlib import Path
import subprocess
import tempfile

import pdfplumber


ROOT = Path(__file__).resolve().parents[1]
HEADER = "人工智能学院毕业设计文献综述"


def compile_pdf(source, output, error=None):
    result = subprocess.run(
        ["typst", "compile", "--root", str(ROOT), "--ignore-system-fonts",
         "--font-path", str(ROOT / "assets/fonts"), str(source), str(output)],
        cwd=ROOT, capture_output=True, text=True,
    )
    if error is not None:
        assert result.returncode != 0 and error in result.stderr, result.stderr
    else:
        assert result.returncode == 0, result.stderr


def baseline(page, char):
    return page.height - char["matrix"][5]


def near(actual, expected, tolerance=0.5):
    assert abs(actual - expected) <= tolerance, (actual, expected)


def check_running_matter(pdf):
    for number, page in enumerate(pdf.pages, 1):
        header = [c for c in page.chars if baseline(page, c) < 60]
        assert "".join(c["text"] for c in header) == HEADER
        for char in header:
            near(baseline(page, char), 51.6, 0.01)
            near(char["size"], 9, 0.01)
        footer = [c for c in page.chars if baseline(page, c) > 780]
        assert "".join(c["text"] for c in footer) == str(number)
        for char in footer:
            near(baseline(page, char), 792.96, 0.01)
            near(char["size"], 12, 0.01)
        assert any(abs(line["top"] - 55.56) < 0.01
                   and abs(line["linewidth"] - 0.72) < 0.01 for line in page.lines)


def check_sample(path):
    with pdfplumber.open(path) as pdf:
        assert len(pdf.pages) == 2
        check_running_matter(pdf)
        page = pdf.pages[0]
        # 与原版 Word 导出 PDF 的基线比较，允许其 0.24pt 坐标取整。
        title = next(c for c in page.chars if c["text"] == "“" and c["size"] == 16)
        near(baseline(page, title), 132)
        near(title["x0"], 217.53)
        author = next(c for c in page.chars if c["text"] == "学" and c["size"] == 10.5)
        near(baseline(page, author), 172.8)
        for label, expected in [("摘", 211.68), ("关", 235.2)]:
            char = next(c for c in page.chars if c["text"] == label and "SimHei" in c["fontname"])
            near(baseline(page, char), expected)
        body = [c for c in page.chars if c["text"] == "正"]
        for char, expected in zip(body, [320.88, 406.8, 523.68, 586.08, 648.48, 710.88], strict=True):
            near(baseline(page, char), expected)
            near(char["x0"], 106.04, 0.01)  # 正文统一首行缩进两字。
        third = [c for c in page.chars if c["text"] == "三" and baseline(page, c) > 600]
        assert len(third) == 2 and all(c["size"] == 12 for c in third)
        refs = pdf.pages[1]
        heading = next(c for c in refs.chars if c["text"] == "参")
        near(baseline(refs, heading), 118.56)
        first = next(c for c in refs.chars if c["text"] == "[" and c["size"] == 9)
        near(baseline(refs, first), 160.56)


def main():
    (ROOT / "dist").mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="review-test-", dir=ROOT / "dist") as directory:
        temp = Path(directory)
        sample = temp / "sample.pdf"
        compile_pdf(ROOT / "literature-review.typ", sample)
        check_sample(sample)

        overflow = temp / "overflow.pdf"
        compile_pdf(ROOT / "tests/literature-review.typ", overflow)
        with pdfplumber.open(overflow) as pdf:
            check_running_matter(pdf)
            assert len(pdf.pages) >= 4
            text = [page.extract_text() for page in pdf.pages]
            assert "摘要：" in text[0] and "关键词：" not in text[0]
            assert "关键词：" in text[1] and "1. 引言" in text[1]
            joined = "\n".join(text)
            assert "第一条引用应从一开始[1]" in joined and "由文献[1]可知" in joined
            assert "表 1-1" in joined and "图 2-1" in joined
            assert any("1.1.1 具体方法" in part and "三级标题应为小四号" in part for part in text)
            assert "参考文献" in text[-1] and "[6]" in text[-1]
            title = [c for c in pdf.pages[0].chars if c["size"] == 16]
            assert len({round(baseline(pdf.pages[0], c), 2) for c in title}) == 2

        source = temp / "variant.typ"
        output = temp / "variant.pdf"
        prefix = '#import "/templates/literature-review/lib.typ": literature-review\n'
        source.write_text(prefix + '''#show: literature-review.with(
          bibliography: bibliography.with("/ref.bib"),
        )
        = 引言
        只引用一篇文献 @cai2021densenet。
        ''')
        compile_pdf(source, output)
        with pdfplumber.open(output) as pdf:
            refs = pdf.pages[-1].extract_text()
            assert "DenseNet" in refs and "多模态" not in refs and "[2]" not in refs

        # 刻意加长的测试文献，验证独立参考文献页能继续分页。
        entries = [f'''@article{{test{i},
          author = {{测试作者}},
          title = {{仅供分页测试的占位文献第{i}条：{"跨页排版验证" * 12}}},
          journal = {{测试刊物}}, year = {{2026}}, volume = {{1}}, pages = {{1--10}}
        }}''' for i in range(1, 41)]
        (temp / "pagination.bib").write_text("\n".join(entries))
        source.write_text(prefix + '''#show: literature-review.with(
          bibliography: bibliography.with("pagination.bib"),
          bibliography-full: true,
        )
        = 引言
        仅供测试。
        ''')
        compile_pdf(source, output)
        with pdfplumber.open(output) as pdf:
            check_running_matter(pdf)
            assert len(pdf.pages) >= 4
            text = [page.extract_text() for page in pdf.pages]
            assert "参考文献" in text[1] and "参考文献" not in text[0]
            assert "[40]" in "\n".join(text[2:])

        for arguments, message in [
            ('', "请为文献综述传入"),
            ('keywords: "一个"', "keywords 应为包含 3–6 个关键词的数组"),
            ('keywords: ("一个",)', "文献综述需要 3–6 个关键词"),
        ]:
            source.write_text(prefix + f"#show: literature-review.with({arguments})\n正文")
            compile_pdf(source, output, error=message)
    print("通过：Word 坐标、页眉页码、长题名、跨页摘要与文献、引用及参数检查。")


if __name__ == "__main__":
    main()
