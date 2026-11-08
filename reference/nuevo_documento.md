# Crear un documento con la identidad de MetaDocencia

Crea una carpeta con la extensión de Quarto de MetaDocencia (formatos e
identidad visual) y un archivo `.qmd` listo para editar. Solo hay que
escribir el contenido: colores, tipografías, logo y diagramación los
aporta la extensión.

## Usage

``` r
nuevo_documento(
  nombre = "documento",
  tipo = c("reporte-html", "reporte-pdf", "presentacion", "nota"),
  directorio = ".",
  abrir = interactive()
)
```

## Arguments

- nombre:

  Nombre del documento. Se usa para la carpeta y para el archivo `.qmd`.
  Solo letras, números, guiones y guiones bajos.

- tipo:

  Tipo de documento. Ver
  [`listar_tipos()`](https://metadocencia.github.io/metadocencia/reference/listar_tipos.md).

- directorio:

  Carpeta donde se crea el documento. Por defecto, la carpeta de trabajo
  actual.

- abrir:

  Si es `TRUE`, abre el `.qmd` en RStudio o Positron.

## Value

La ruta a la carpeta creada, de forma invisible.

## Examples

``` r
dir <- tempdir()
nuevo_documento("informe-anual", tipo = "reporte-html",
                directorio = dir, abrir = FALSE)
#> ✔ Documento creado: /tmp/RtmpBHePJX/informe-anual
#> • Editá informe-anual.qmd.
#> • Renderizá con el botón Render o con `quarto render informe-anual.qmd`.
list.files(file.path(dir, "informe-anual"))
#> [1] "_extensions"       "_quarto.yml"       "informe-anual.qmd"
```
