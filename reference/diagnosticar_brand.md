# Diagnosticar la identidad visual de documentos existentes

Compara la extensión de Quarto de cada documento con la del paquete
instalado e informa su estado:

## Usage

``` r
diagnosticar_brand(proyectos = ".", recursivo = FALSE)
```

## Arguments

- proyectos:

  Carpetas de documentos. Por defecto, la carpeta actual.

- recursivo:

  Si es `TRUE`, busca documentos dentro de las carpetas indicadas y sus
  subcarpetas.

## Value

Un `data.frame` con las columnas `proyecto`, `version` y `estado`, de
forma invisible.

## Details

- `"actualizado"`: igual a la del paquete.

- `"desactualizado"`: distinta; se corrige con
  [`actualizar_brand()`](https://metadocencia.github.io/metadocencia/reference/actualizar_brand.md).

- `"formato anterior"`: creado con la versión 0.x del paquete (tiene
  `_brand.yml` pero no la extensión). Hay que migrarlo a mano.

- `"ausente"`: no es un documento de MetaDocencia.

## Examples

``` r
dir <- tempdir()
nuevo_documento("nota-ejemplo", tipo = "nota", directorio = dir, abrir = FALSE)
#> ✔ Documento creado: /tmp/RtmpBHePJX/nota-ejemplo
#> • Editá nota-ejemplo.qmd.
#> • Renderizá con el botón Render o con `quarto render nota-ejemplo.qmd`.
diagnosticar_brand(file.path(dir, "nota-ejemplo"))
#> ✔ /tmp/RtmpBHePJX/nota-ejemplo (actualizado)
```
