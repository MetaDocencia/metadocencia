
<!-- README.md se genera desde README.Rmd. Editá este archivo. -->

# metadocencia <img src="inst/extdata/_extensions/metadocencia/brand/logo.png" align="right" height="60"/>

Reportes, notas y presentaciones con la identidad visual de
[MetaDocencia](https://www.metadocencia.org), hechos con
[Quarto](https://quarto.org) y R.

## Instalación

``` r
# install.packages("pak")
pak::pak("metadocencia/metadocencia")
```

Requiere Quarto ≥ 1.9. El PDF se genera con Typst, que viene con Quarto:
no hace falta instalar LaTeX.

## Uso

``` r
library(metadocencia)
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

``` r
nuevo_documento("informe-anual", tipo = "reporte-html")
nuevo_documento("informe-anual-pdf", tipo = "reporte-pdf")
nuevo_documento("charla-congreso", tipo = "presentacion")
nuevo_documento("nota-convenio", tipo = "nota")
```

Cada documento es una carpeta así:

    informe-anual/
    ├── informe-anual.qmd            # lo único que se edita
    ├── _quarto.yml
    └── _extensions/metadocencia/    # formatos e identidad (no tocar)

### Gráficos

``` r
library(ggplot2)
theme_set(theme_metadocencia())

ggplot(mpg, aes(displ, hwy, colour = drv)) +
  geom_point() +
  scale_colour_metadocencia()
```

``` r
paleta_metadocencia()
#> [1] "#C83737" "#C86E37" "#00506F" "#F77B20" "#00788F"
```

### Bloque destacado

Funciona igual en HTML, PDF y diapositivas:

``` markdown
::: {.destacado}
**Mensaje clave.** La conclusión que no se puede perder.
:::
```

### Cuando cambia la identidad

``` r
diagnosticar_brand("~/documentos", recursivo = TRUE)   # qué está desactualizado
actualizar_brand("~/documentos", recursivo = TRUE)     # actualizar
```

Solo se reemplaza `_extensions/metadocencia/`; el contenido de los
`.qmd` no se toca.

## Cómo se modifica

Todo está en `inst/extdata/_extensions/metadocencia/`:

| Quiero cambiar… | Archivo |
|----|----|
| Colores | `brand/_brand.yml` → `color` |
| Logo | `brand/logo.png` |
| Tipografías | `brand/fuentes/`, `brand/_brand.yml` y `fuentes.html` |
| Orden de colores de gráficos | `brand/_brand.yml` → `defaults` |
| Diseño del PDF | `typst/typst-template.typ` |
| Diseño del HTML / diapositivas | `html/estilos.scss`, `revealjs/estilos.scss` |
| Opciones por defecto | `_extension.yml` |

Después de cualquier cambio, subí `version` en `_extension.yml` y en
`DESCRIPTION`.

## Licencias

Código: MIT. Fuentes: SIL Open Font License 1.1 (ver
`brand/fuentes/LICENCIA-*.txt`).
