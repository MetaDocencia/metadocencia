# Escalas de color de MetaDocencia para ggplot2

Escalas discretas con
[`paleta_metadocencia()`](https://metadocencia.github.io/metadocencia/reference/paleta_metadocencia.md):
rojo, rojo-naranja, azul, naranja y, si hace falta, azul-verde.

## Usage

``` r
scale_color_metadocencia(...)

scale_colour_metadocencia(...)

scale_fill_metadocencia(...)
```

## Arguments

- ...:

  Argumentos para
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Value

Una escala de ggplot2.

## Examples

``` r
if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)
  ggplot(mpg, aes(class, fill = drv)) +
    geom_bar() +
    scale_fill_metadocencia()
}
```
