# Tema de ggplot2 de MetaDocencia

Aplica la guía de estilo a los gráficos: Barlow para títulos, Open Sans
para el resto, grilla horizontal suave y línea base azul. Colores y
tipografías se leen del `_brand.yml`. Si las fuentes no están instaladas
en el sistema, se usa la fuente por defecto sin error.

## Usage

``` r
theme_metadocencia(base_size = 12, base_family = NULL, brand = leer_brand())
```

## Arguments

- base_size:

  Tamaño base del texto, en puntos.

- base_family:

  Fuente del texto. Por defecto, la del `_brand.yml`.

- brand:

  Lista devuelta por
  [`leer_brand()`](https://metadocencia.github.io/metadocencia/reference/leer_brand.md).

## Value

Un tema de ggplot2.

## Examples

``` r
if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)
  ggplot(mpg, aes(displ, hwy, colour = drv)) +
    geom_point() +
    scale_colour_metadocencia() +
    theme_metadocencia()
}
```
