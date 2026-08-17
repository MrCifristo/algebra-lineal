#!/bin/bash
# Exporta tarea3.ipynb a PDF sin necesitar LaTeX: nbconvert -> HTML -> Chromium headless.
set -e
cd "$(dirname "$0")"

PY=.venv/bin/python
HTML=$(mktemp -t tarea3).html
CHROME="/Applications/Chromium.app/Contents/MacOS/Chromium"
[ -x "$CHROME" ] || CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

$PY -m nbconvert --to html --embed-images tarea3.ipynb --output "$HTML"

# CSS de impresion: que el codigo largo no se corte por el borde derecho
$PY - "$HTML" <<'EOF'
import sys
p = sys.argv[1]
css = """<style>
@page { size: letter; margin: 1.4cm; }
pre, code, .highlight pre { white-space: pre-wrap !important; word-break: break-word; }
.jp-InputArea-editor, .jp-OutputArea-output { overflow: visible !important; }
mjx-container { font-size: 0.95em; }
mjx-container[display="true"] { overflow-x: hidden !important; }
.jp-RenderedHTMLCommon table { font-size: 0.85em; width: 100%; }
.jp-OutputArea-output img { max-width: 100%; height: auto; }
.jp-Cell { break-inside: avoid; }
</style></head>"""
s = open(p, encoding="utf-8").read().replace("</head>", css, 1)
open(p, "w", encoding="utf-8").write(s)
EOF

"$CHROME" --headless --disable-gpu --no-sandbox \
  --virtual-time-budget=20000 --run-all-compositor-stages-before-draw \
  --no-pdf-header-footer --print-to-pdf="$PWD/tarea3.pdf" "file://$HTML" 2>/dev/null

rm -f "$HTML"
echo "Listo: tarea3.pdf"
