# Tipos de documento disponibles

Lista los tipos de documento que se pueden crear con
[`nuevo_documento()`](https://metadocencia.github.io/metadocencia/reference/nuevo_documento.md)
y el formato de Quarto que usa cada uno.

## Usage

``` r
listar_tipos()
```

## Value

Un `data.frame` con las columnas `tipo`, `formato` y `descripcion`.

## Examples

``` r
listar_tipos()
#>           tipo               formato
#> 1 reporte-html     metadocencia-html
#> 2  reporte-pdf    metadocencia-typst
#> 3 presentacion metadocencia-revealjs
#> 4         nota    metadocencia-typst
#>                                                    descripcion
#> 1 Reporte HTML autocontenido con índice y secciones numeradas.
#> 2      Reporte PDF (Typst) con encabezado y pie institucional.
#> 3                Presentación RevealJS con tema institucional.
#> 4       Nota o carta breve en PDF con Para / De / Fecha / Ref.
```
