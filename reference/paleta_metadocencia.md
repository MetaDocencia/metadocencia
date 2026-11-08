# Paleta categórica de MetaDocencia

Colores para gráficos categóricos, en el orden definido por la guía de
estilo: rojo, rojo-naranja, azul, naranja y, solo si hace falta un
quinto color, azul-verde. El orden se define en `_brand.yml`
(`defaults: metadocencia: paleta-categorica`).

## Usage

``` r
paleta_metadocencia(n = NULL, brand = leer_brand())
```

## Arguments

- n:

  Cantidad de colores. Por defecto, los cinco.

- brand:

  Lista devuelta por
  [`leer_brand()`](https://metadocencia.github.io/metadocencia/reference/leer_brand.md).

## Value

Vector de texto con códigos hexadecimales.

## Examples

``` r
paleta_metadocencia()
#> [1] "#C83737" "#C86E37" "#00506F" "#F77B20" "#00788F"
paleta_metadocencia(3)
#> [1] "#C83737" "#C86E37" "#00506F"
```
