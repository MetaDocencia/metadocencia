# metadocencia 1.0.0

Reestructuración completa del paquete.

## Cambios principales

* La identidad visual y los formatos ahora viven en una **extensión de
  Quarto** (`_extensions/metadocencia/`). En los `.qmd` se usa
  `format: metadocencia-html`, `metadocencia-typst` o
  `metadocencia-revealjs`.
* `_brand.yml` es la **única** fuente de verdad: los estilos de HTML, PDF y
  diapositivas, y las funciones de ggplot2, leen los colores de ahí. En la
  versión 0.x había cuatro copias del brand, que ya habían quedado distintas
  entre sí.
* `actualizar_brand()` reemplaza la extensión completa (brand, estilos,
  plantillas y logo), no solo `_brand.yml`.
* El PDF se genera con **Typst** en lugar de XeLaTeX. No hace falta tener
  LaTeX instalado.
* Las fuentes (Barlow, Open Sans y JetBrains Mono, licencia OFL) viajan con
  el paquete: los documentos se ven igual sin conexión y sin instalar nada.
* El logo pasa a ser un PNG con fondo transparente.

## Novedades

* Nuevo tipo de documento `"nota"`.
* Bloque `::: {.destacado}` que funciona igual en los tres formatos.
* `diagnosticar_brand()` detecta documentos creados con la versión 0.x
  (estado `"formato anterior"`) y acepta `recursivo = TRUE`.
* Nuevas funciones `listar_tipos()`, `leer_brand()`, `ruta_brand()` y
  `colores_metadocencia()`.

## Cambios que pueden romper código existente

* `paleta_metadocencia` ahora es una función: usar `paleta_metadocencia()`
  en lugar de `paleta_metadocencia`.
* `nuevo_documento()` ya no abre el documento en una sesión nueva de
  RStudio: abre el `.qmd` en la sesión actual.
* Los documentos creados con la versión 0.x no se actualizan solos: hay que
  crear uno nuevo y copiar el contenido.
