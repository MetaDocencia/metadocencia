#' Crear un documento con la identidad de MetaDocencia
#'
#' Crea una carpeta con la extensión de Quarto de MetaDocencia (formatos e
#' identidad visual) y un archivo `.qmd` listo para editar. Solo hay que
#' escribir el contenido: colores, tipografías, logo y diagramación los
#' aporta la extensión.
#'
#' @param nombre Nombre del documento. Se usa para la carpeta y para el
#'   archivo `.qmd`. Solo letras, números, guiones y guiones bajos.
#' @param tipo Tipo de documento. Ver [listar_tipos()].
#' @param directorio Carpeta donde se crea el documento. Por defecto, la
#'   carpeta de trabajo actual.
#' @param abrir Si es `TRUE`, abre el `.qmd` en RStudio o Positron.
#'
#' @return La ruta a la carpeta creada, de forma invisible.
#' @export
#' @examples
#' dir <- tempdir()
#' nuevo_documento("informe-anual", tipo = "reporte-html",
#'                 directorio = dir, abrir = FALSE)
#' list.files(file.path(dir, "informe-anual"))
nuevo_documento <- function(nombre = "documento",
                            tipo = c("reporte-html", "reporte-pdf",
                                     "presentacion", "nota"),
                            directorio = ".",
                            abrir = interactive()) {
  catalogo <- catalogo_tipos()
  tipo <- match.arg(tipo, catalogo$tipo)

  if (!is.character(nombre) || length(nombre) != 1 ||
      grepl("[^a-zA-Z0-9_-]", nombre) || !nzchar(nombre)) {
    cli::cli_abort(c(
      "El nombre {.val {nombre}} no es v\u00e1lido.",
      "i" = "Us\u00e1 solo letras, n\u00fameros, guiones ({.code -}) y guiones bajos ({.code _})."
    ))
  }

  destino <- fs::path(directorio, nombre)
  if (fs::dir_exists(destino)) {
    cli::cli_abort(c(
      "Ya existe la carpeta {.path {destino}}.",
      "i" = "Eleg\u00ed otro nombre o borr\u00e1 la carpeta existente."
    ))
  }

  fila <- catalogo[catalogo$tipo == tipo, ]
  fs::dir_create(destino)
  copiar_extension(destino)

  plantilla <- leer_utf8(fs::path(ruta_plantillas(), fila$plantilla))
  plantilla <- gsub("__FORMATO__", fila$formato, plantilla, fixed = TRUE)
  qmd <- fs::path(destino, paste0(nombre, ".qmd"))
  escribir_utf8(plantilla, qmd)

  # _quarto.yml mínimo: marca la carpeta como proyecto de Quarto.
  escribir_utf8(c("project:", "  type: default"), fs::path(destino, "_quarto.yml"))
  escribir_utf8(c("/.quarto/", "*_files/"), fs::path(destino, ".gitignore"))

  cli::cli_alert_success("Documento creado: {.path {destino}}")
  cli::cli_bullets(c(
    "*" = "Edit\u00e1 {.file {nombre}.qmd}.",
    "*" = "Renderiz\u00e1 con el bot\u00f3n Render o con {.code quarto render {nombre}.qmd}."
  ))

  if (isTRUE(abrir) && requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(as.character(qmd))
  }

  invisible(as.character(destino))
}
