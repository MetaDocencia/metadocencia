# Catálogo de tipos de documento ------------------------------------------
# Para sumar un tipo: agregar una fila acá y su plantilla en
# inst/extdata/plantillas/. Si la plantilla tiene `format: __FORMATO__`,
# se completa con la columna `formato`.

catalogo_tipos <- function() {
  data.frame(
    tipo = c("reporte-html", "reporte-pdf", "presentacion", "nota"),
    plantilla = c("reporte.qmd", "reporte.qmd", "presentacion.qmd", "nota.qmd"),
    formato = c("metadocencia-html", "metadocencia-typst",
                "metadocencia-revealjs", "metadocencia-typst"),
    descripcion = c(
      "Reporte HTML autocontenido con \u00edndice y secciones numeradas.",
      "Reporte PDF (Typst) con encabezado y pie institucional.",
      "Presentaci\u00f3n RevealJS con tema institucional.",
      "Nota o carta breve en PDF con Para / De / Fecha / Ref."
    ),
    stringsAsFactors = FALSE
  )
}

#' Tipos de documento disponibles
#'
#' Lista los tipos de documento que se pueden crear con
#' [nuevo_documento()] y el formato de Quarto que usa cada uno.
#'
#' @return Un `data.frame` con las columnas `tipo`, `formato` y
#'   `descripcion`.
#' @export
#' @examples
#' listar_tipos()
listar_tipos <- function() {
  catalogo_tipos()[, c("tipo", "formato", "descripcion")]
}
