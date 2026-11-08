# Colores de MetaDocencia

Devuelve colores del `_brand.yml` como vector con nombre. Acepta nombres
de la paleta (`"azul"`, `"rojo-40"`) y roles (`"primary"`).

## Usage

``` r
colores_metadocencia(..., brand = leer_brand())
```

## Arguments

- ...:

  Nombres de colores. Sin argumentos, devuelve la paleta completa.

- brand:

  Lista devuelta por
  [`leer_brand()`](https://metadocencia.github.io/metadocencia/reference/leer_brand.md).

## Value

Vector de texto con códigos hexadecimales.

## Examples

``` r
colores_metadocencia("azul", "rojo", "naranja")
#>      azul      rojo   naranja 
#> "#00506F" "#C83737" "#F77B20" 
colores_metadocencia("primary")
#>   primary 
#> "#00506F" 
```
