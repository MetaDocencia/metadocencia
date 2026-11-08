# Actualizar la identidad visual en documentos existentes

Reemplaza la extensión de Quarto (`_extensions/metadocencia/`) de cada
documento por la versión del paquete instalado. Así, cuando cambian
colores, logo, tipografías o plantillas, alcanza con actualizar el
paquete y correr esta función. El contenido de los `.qmd` no se toca.

## Usage

``` r
actualizar_brand(proyectos = ".", recursivo = FALSE, confirmar = interactive())
```

## Arguments

- proyectos:

  Carpetas de documentos. Por defecto, la carpeta actual.

- recursivo:

  Si es `TRUE`, busca documentos dentro de las carpetas indicadas y sus
  subcarpetas.

- confirmar:

  Si es `TRUE`, pide confirmación antes de actualizar cada documento.
  Por defecto, solo en sesiones interactivas.

## Value

Las rutas de los documentos actualizados, de forma invisible.

## Examples

``` r
dir <- tempdir()
nuevo_documento("nota-ejemplo2", tipo = "nota", directorio = dir, abrir = FALSE)
#> ✔ Documento creado: /tmp/RtmpBHePJX/nota-ejemplo2
#> • Editá nota-ejemplo2.qmd.
#> • Renderizá con el botón Render o con `quarto render nota-ejemplo2.qmd`.
actualizar_brand(file.path(dir, "nota-ejemplo2"), confirmar = FALSE)
#> ℹ /tmp/RtmpBHePJX/nota-ejemplo2: ya está actualizado.
#> ℹ 0 documento(s) actualizado(s) a la versión 1.0.0.
```
