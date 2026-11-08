# Rutas y utilidades internas ---------------------------------------------

nombre_extension <- function() "metadocencia"

ruta_extension <- function() {
  ruta <- system.file("extdata", "_extensions", nombre_extension(),
                      package = "metadocencia")
  if (!nzchar(ruta)) {
    cli::cli_abort("No se encontr\u00f3 la extensi\u00f3n de Quarto. Reinstal\u00e1 {.pkg metadocencia}.")
  }
  ruta
}

ruta_plantillas <- function() {
  system.file("extdata", "plantillas", package = "metadocencia")
}

#' Ruta al archivo `_brand.yml` de MetaDocencia
#'
#' Devuelve la ruta al `_brand.yml` que viaja dentro del paquete: la única
#' fuente de verdad de la identidad visual (colores, tipografías y logo).
#'
#' @return Ruta absoluta (texto).
#' @export
#' @examples
#' ruta_brand()
ruta_brand <- function() {
  file.path(ruta_extension(), "brand", "_brand.yml")
}

# Lee un archivo como UTF-8 sin depender del locale de la sesión.
leer_utf8 <- function(ruta) {
  con <- file(ruta, encoding = "UTF-8")
  on.exit(close(con))
  paste(readLines(con, warn = FALSE), collapse = "\n")
}

escribir_utf8 <- function(lineas, ruta) {
  con <- file(ruta, open = "w", encoding = "UTF-8")
  on.exit(close(con))
  writeLines(lineas, con)
}

version_extension <- function(ruta_ext) {
  yml <- file.path(ruta_ext, "_extension.yml")
  if (!file.exists(yml)) return(NA_character_)
  v <- yaml::yaml.load(leer_utf8(yml))$version
  if (is.null(v)) NA_character_ else as.character(v)
}

# Huella de una carpeta: cambia si cambia cualquier archivo de la extensión.
huella_extension <- function(ruta_ext) {
  archivos <- sort(list.files(ruta_ext, recursive = TRUE))
  if (length(archivos) == 0) return(NA_character_)
  hashes <- unname(tools::md5sum(file.path(ruta_ext, archivos)))
  tmp <- tempfile()
  on.exit(unlink(tmp))
  writeLines(paste(archivos, hashes), tmp)
  unname(tools::md5sum(tmp))
}

copiar_extension <- function(destino) {
  dir_ext <- fs::path(destino, "_extensions")
  fs::dir_create(dir_ext)
  objetivo <- fs::path(dir_ext, nombre_extension())
  if (fs::dir_exists(objetivo)) fs::dir_delete(objetivo)
  fs::dir_copy(ruta_extension(), objetivo)
  invisible(objetivo)
}
