# Tarea 3 — Álgebra Lineal

Programación lineal por método gráfico. Todo está en `tarea3.ipynb`.

## Archivos

| Archivo | Qué es |
|---|---|
| `tarea3.ipynb` | La tarea resuelta (8 problemas) |
| `requirements.txt` | numpy y matplotlib, con versión fija |
| `Tarea_03_Algebra_Lineal_2026.pdf` | Enunciado original |

## Cómo correrlo

Desde esta carpeta (`tarea03/`):

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
pip install jupyter              # solo para abrir el notebook
jupyter notebook tarea3.ipynb
```

En VS Code no hace falta `jupyter`: basta con `pip install ipykernel` y elegir `.venv`
como kernel con "Select Kernel" arriba a la derecha del notebook.

Para regenerar las gráficas: **Kernel → Restart & Run All**. El notebook ya trae las
figuras guardadas, así que también se ve bien sin ejecutarlo.

## Exportar a PDF

```bash
pip install nbconvert
./exportar_pdf.sh          # genera tarea3.pdf
```

El script convierte el notebook a HTML y lo imprime con Chromium en modo headless
(usa Google Chrome si no hay Chromium). Le inyecta CSS de impresión para que las
líneas largas de código no se corten en el borde de la página.

No uses "Export to PDF" de la extensión Jupyter de VS Code: esa ruta exige `nbconvert`
**y** una instalación de LaTeX (xelatex), y al faltar `nbconvert` VS Code intenta
instalar `jupyter-client<8` y `pyzmq<25`, que no compilan en Python 3.13 / arm64.

## Estructura del notebook

La primera celda de código define `graficar()`, que se usa en los problemas 5 a 8:

```python
graficar(rests, xmax, ymax, verts, titulo)
```

- `rests`: lista de restricciones `(a, b, c, sentido)`, para `ax + by <= c` o `>= c`
- `xmax`, `ymax`: límites de los ejes (los mismos de las cuadrículas del PDF)
- `verts`: lista opcional de vértices `(x, y)` que se marcan como puntos

Dibuja cada recta y sombrea la región factible con un meshgrid de máscaras booleanas,
así que también funciona con regiones no acotadas (problema 8).

Después va un problema por sección, en orden: enunciado, planteamiento, vértices
paso a paso y —en los problemas 5 a 8— la celda que llama a `graficar()`.
