"""正文块级排版检查。依赖 Typst 0.14+ 和 Python pdfplumber。

从仓库根目录运行：python3 tests/check-academic-layout.py
"""

from pathlib import Path
import subprocess
import tempfile

import pdfplumber


ROOT = Path(__file__).resolve().parents[1]


def find(pdf, text):
    matches = [(index, match) for index, page in enumerate(pdf.pages)
               for match in page.search(text, regex=False)]
    assert len(matches) == 1, (text, len(matches))
    return matches[0]


def baseline(match):
    return match["chars"][0]["matrix"][5]


def check_pdf(path, heading_size):
    with pdfplumber.open(path) as pdf:
        page, one = find(pdf, "BASELINEONE")
        next_page, two = find(pdf, "BASELINETWO")
        assert page == next_page
        assert abs(baseline(one) - baseline(two) - 23.4) < 0.01

        heading_page, heading = find(pdf, "1.1.1.1 四级标题")
        assert heading_page == page
        assert all(abs(char["size"] - heading_size) < 0.01 for char in heading["chars"])
        assert any("SimHei" in char["fontname"] for char in heading["chars"])

        _, eq_one = find(pdf, "EQONE")
        _, eq_two = find(pdf, "EQTWO")
        # 连续公式必须有明确留白，不能随普通段落的零段距挤在一起。
        assert eq_two["top"] - eq_one["bottom"] >= 15
        _, row_one = find(pdf, "MULTIONE")
        _, row_two = find(pdf, "MULTITWO")
        assert row_two["top"] - row_one["bottom"] >= 14
        _, row_tall = find(pdf, "MULTITALL")
        assert row_tall["top"] - row_two["bottom"] >= 14
        _, after = find(pdf, "AFTERFORMULA")
        assert after["top"] - row_tall["bottom"] >= 15
        assert "式1" in pdf.pages[page].extract_text().replace(" ", "")
        assert "式4" in pdf.pages[page].extract_text().replace(" ", "")

        figure_page, before = find(pdf, "FIGUREBEFORE")
        _, caption_one = find(pdf, "CAPTIONONE")
        _, caption_two = find(pdf, "CAPTIONTWO")
        _, caption_three = find(pdf, "CAPTIONTHREE")
        _, after = find(pdf, "FIGUREAFTER")
        content = pdf.pages[figure_page]
        rect_one = next(rect for rect in content.rects if abs(rect["width"] - 100) < 0.01)
        rect_three = next(rect for rect in content.rects if abs(rect["width"] - 120) < 0.01)
        table_edges = [edge for edge in content.edges
                       if edge["width"] > 400 and edge["height"] < 0.01
                       and rect_one["bottom"] < edge["top"] < rect_three["top"]]
        assert len(table_edges) == 3
        assert rect_one["top"] - before["bottom"] >= 7.7
        assert caption_one["top"] - rect_one["bottom"] >= 7.7
        assert caption_two["top"] - caption_one["bottom"] >= 7.7
        assert min(edge["top"] for edge in table_edges) - caption_two["bottom"] >= 7.7
        assert rect_three["top"] - max(edge["bottom"] for edge in table_edges) >= 7.7
        assert caption_three["top"] - rect_three["bottom"] >= 7.7
        caption_end = find(pdf, "完整的字号和行距。")[1]
        assert after["top"] - caption_end["bottom"] >= 7.7
        text = content.extract_text().replace(" ", "")
        for caption in ("图2-1", "表2-2", "图2-3"):
            assert caption in text, caption

        equation_page, _ = find(pdf, "PAGEBREAK")
        assert pdf.pages[equation_page].search("3. 页底标题", regex=False), "页底标题与后续公式分离"


def main():
    (ROOT / "dist").mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="academic-test-", dir=ROOT / "dist") as directory:
        for material in ("thesis", "literature-review"):
            source = Path(directory) / f"{material}.typ"
            output = source.with_suffix(".pdf")
            source.write_text(f'''#import "/templates/{material}/lib.typ": {material}
#show: {material}.with(bibliography: bibliography.with("/ref.bib"))
#include "/tests/fixtures/academic-content.typ"
''')
            subprocess.run(
                ["typst", "compile", "--root", str(ROOT), "--ignore-system-fonts",
                 "--font-path", str(ROOT / "assets/fonts"), str(source), str(output)],
                cwd=ROOT, check=True,
            )
            check_pdf(output, 10.5 if material == "thesis" else 12)
    print("通过：论文与综述的公式间距、分式与多行公式、图表题注、深层标题、编号引用及分页。")


if __name__ == "__main__":
    main()
