# Leer la identidad visual de MetaDocencia

Lee el `_brand.yml` del paquete (o uno indicado) y devuelve su contenido
como lista.

## Usage

``` r
leer_brand(ruta = ruta_brand())
```

## Arguments

- ruta:

  Ruta a un `_brand.yml`. Por defecto, el del paquete.

## Value

Una lista con la estructura de brand.yml.

## Examples

``` r
names(leer_brand()$color$palette)
#>  [1] "azul"         "rojo"         "naranja"      "rojo-naranja" "azul-verde"  
#>  [6] "gris-texto"   "gris-suave"   "gris-linea"   "negro"        "blanco"      
#> [11] "link"         "azul-80"      "azul-60"      "azul-40"      "azul-20"     
#> [16] "rojo-80"      "rojo-60"      "rojo-40"      "rojo-20"      "naranja-80"  
#> [21] "naranja-60"   "naranja-40"   "naranja-20"  
```
