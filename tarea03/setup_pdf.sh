#!/bin/bash
# Deja lista la exportacion a PDF de VS Code (File > Export > PDF).
# Requisitos previos (una sola vez, piden contrasena):
#   brew install pandoc
#   brew install --cask basictex
set -e
cd "$(dirname "$0")"
export PATH="/Library/TeX/texbin:$PATH"

.venv/bin/pip install -q nbconvert

# Paquetes LaTeX que BasicTeX no trae y nbconvert si necesita. En modo usuario
# (~/Library/texmf) para no pedir sudo.
tlmgr init-usertree 2>/dev/null || true
tlmgr --usermode install adjustbox collectbox enumitem environ pdfcol rsfs \
  soul tcolorbox titling trimspaces ucs

# pandoc >= 3 emite \def\LTcaptype{none} en las tablas sin caption y el paquete
# caption falla con "No counter 'none' defined". Se arregla con una plantilla
# propia que agrega ese contador.
T=.venv/share/jupyter/nbconvert/templates/tarea
mkdir -p "$T" .venv/etc/jupyter

cat > "$T/conf.json" <<'JSON'
{
  "base_template": "latex",
  "mimetypes": {"text/latex": true, "application/pdf": true}
}
JSON

cat > "$T/index.tex.j2" <<'J2'
((* extends 'latex/index.tex.j2' *))

((* block definitions *))
((( super() )))
\newcounter{none}
((* endblock definitions *))
J2

cat > .venv/etc/jupyter/jupyter_nbconvert_config.py <<'PY'
c = get_config()  # noqa
c.LatexExporter.template_name = "tarea"
c.PDFExporter.template_name = "tarea"
PY

echo "Listo. Reinicia VS Code y usa File > Export > PDF."
