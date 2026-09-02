#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
生成 Noto Sans SC 的精简字体 CSS（仅保留 woff2，剥离 woff 兜底）。

背景：
  @fontsource/noto-sans-sc 官方 CSS 里每条 @font-face 都同时声明 woff2 + woff，
  woff 体积占比约 55%，但只有不支持 woff2 的老浏览器（<2%）才用得上。
  Vite 会无条件把 url() 里引用的所有字体文件复制进 dist，
  因此剥离 woff 可让产物体积直接减半，且不影响现代浏览器。

用法：
  python tools/gen-font-css.py mall-web
  python tools/gen-font-css.py admin-web

产物：
  <project>/src/styles/fonts-noto-sc.css
"""

import re
import sys
from pathlib import Path

# 需要的字重：项目实际使用 400/500/600/700，
# 按 CSS 字重匹配规范，装 400+700 即可覆盖（500→400，600→700）。
WEIGHTS = [400, 700]

FONT_FACE_RE = re.compile(r"@font-face\s*\{[^}]*\}", re.S)
WOFF2_RE = re.compile(r"url\(\./files/([^)]+?\.woff2)\)")
UNICODE_RANGE_RE = re.compile(r"unicode-range:\s*([^;]+);")

# 生成的 CSS 位于 <project>/src/styles/，向上两级即项目根
NODE_MODULES_PREFIX = "../../node_modules/@fontsource/noto-sans-sc/files/"


def generate(project: str) -> int:
    root = Path(__file__).resolve().parent.parent
    proj_dir = root / project
    pkg_dir = proj_dir / "node_modules" / "@fontsource" / "noto-sans-sc"
    out_file = proj_dir / "src" / "styles" / "fonts-noto-sc.css"

    if not pkg_dir.is_dir():
        print(f"[错误] 未找到字体包：{pkg_dir}")
        print(f"       请先在 {project} 执行 npm install @fontsource/noto-sans-sc")
        return 1

    lines = [
        "/* 自动生成文件，请勿手动编辑 */",
        "/* 源：@fontsource/noto-sans-sc  |  生成脚本：tools/gen-font-css.py */",
        "/* 策略：仅保留 woff2（剥离 woff 兜底），按 unicode-range 分片按需加载 */",
        "",
    ]

    total = 0
    for weight in WEIGHTS:
        src = pkg_dir / f"{weight}.css"
        if not src.is_file():
            print(f"[错误] 缺少字重文件：{src}")
            return 1

        css = src.read_text(encoding="utf-8")
        blocks = FONT_FACE_RE.findall(css)
        kept = 0

        for block in blocks:
            woff2 = WOFF2_RE.search(block)
            if not woff2:
                continue
            urange = UNICODE_RANGE_RE.search(block)

            lines.append("@font-face {")
            lines.append("  font-family: 'Noto Sans SC';")
            lines.append("  font-style: normal;")
            lines.append("  font-display: swap;")
            lines.append(f"  font-weight: {weight};")
            lines.append(
                f"  src: url('{NODE_MODULES_PREFIX}{woff2.group(1)}') format('woff2');"
            )
            if urange:
                lines.append(f"  unicode-range: {urange.group(1).strip()};")
            lines.append("}")
            kept += 1

        print(f"  {project} 字重 {weight}: {kept} 个分片")
        total += kept

    out_file.parent.mkdir(parents=True, exist_ok=True)
    out_file.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"[完成] {project} -> {out_file}（共 {total} 条 @font-face）")
    return 0


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    code = 0
    for proj in sys.argv[1:]:
        code |= generate(proj)
    return code


if __name__ == "__main__":
    sys.exit(main())
