"""封面题目栏对齐检查。依赖 Typst 0.14+ 和 Python pdfplumber。

从仓库根目录运行：python3 tests/check-cover.py
"""

from pathlib import Path
import subprocess
import tempfile

import pdfplumber


ROOT = Path(__file__).resolve().parents[1]


def near(actual, expected):
    assert abs(actual - expected) < 0.01, (actual, expected)


def check_cover(path, title_lines, second_advisor):
    with pdfplumber.open(path) as pdf:
        assert len(pdf.pages) == 1
        page = pdf.pages[0]
        underlines = sorted(
            [shape for shape in page.curves + page.rects
             if shape["width"] > 280 and abs(shape["height"] - 0.72) < 0.01],
            key=lambda shape: shape["top"],
        )
        labels = ["题目", "学院", "专业", "班级", "学号", "学生姓名", "指导教师"]
        if second_advisor:
            labels.append("第二指导教师")
        labels.append("完成日期")
        assert len(underlines) == len(labels)

        title_baselines = {
            round(page.height - char["matrix"][5], 2)
            for char in page.chars
            if char["x0"] >= 198.5
            and 430 < page.height - char["matrix"][5] < underlines[0]["top"]
        }
        assert len(title_baselines) == title_lines, title_baselines
        near(min(title_baselines), 450.96)

        previous_line = 430
        for index, (label, line) in enumerate(zip(labels, underlines, strict=True)):
            baseline = 450.96 + (title_lines - 1 + index) * 31.2
            center = (line["top"] + line["bottom"]) / 2
            near(center, baseline + 2.28)
            near(line["x0"], 230.56 if label == "第二指导教师" else 198.56)
            near(line["x1"], 515.52)
            chars = [char for char in page.chars
                     if 134.5 <= char["x0"] < line["x0"]
                     and previous_line < page.height - char["matrix"][5] < center
                     and "SimSun" in char["fontname"]]
            assert "".join(char["text"] for char in chars).replace(" ", "") == label
            for char in chars:
                near(page.height - char["matrix"][5], baseline)
                near(char["size"], 16)
            previous_line = center
        near(max(title_baselines), 450.96 + (title_lines - 1) * 31.2)


def main():
    (ROOT / "dist").mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="cover-test-", dir=ROOT / "dist") as directory:
        source = Path(directory) / "cover.typ"
        output = source.with_suffix(".pdf")
        for title, lines, second_advisor in [
            ("毕业设计题目", 1, True),
            ("面向高校毕业设计管理的信息系统" * 2, 2, True),
            ("面向高校毕业设计管理的信息系统" * 3, 3, True),
            ("面向高校毕业设计管理的信息系统" * 2, 2, False),
        ]:
            source.write_text('''#import "/templates/thesis/pages/cover.typ": cover
#set page(paper: "a4", margin: (left: 3cm, right: 2.5cm, top: 2.5cm, bottom: 2.5cm))
#cover(
  "%s", "人工智能学院", "计算机科学与技术", "23 计算机班", "2362120000",
  "张三", "李四", %s, datetime(year: 2027, month: 5, day: 1),
)
''' % (title, '"王五"' if second_advisor else "none"))
            subprocess.run(
                ["typst", "compile", "--root", str(ROOT), "--ignore-system-fonts",
                 "--font-path", str(ROOT / "assets/fonts"), str(source), str(output)],
                cwd=ROOT, check=True,
            )
            check_cover(output, lines, second_advisor)
    print("通过：单行及多行题目的标签与横线对齐、后续字段位置和可选第二导师。")


if __name__ == "__main__":
    main()
