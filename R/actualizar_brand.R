#' Diagnosticar la identidad visual de documentos existentes
#'
#' Compara la extensión de Quarto de cada documento con la del paquete
#' instalado e informa su estado:
#'
#' - `"actualizado"`: igual a la del paquete.
#' - `"desactualizado"`: distinta; se corrige con [actualizar_brand()].
#' - `"formato anterior"`: creado con la versión 0.x del paquete (tiene
#'   `_brand.yml` pero no la extensión). Hay que migrarlo a mano.
#' - `"ausente"`: no es un documento de MetaDocencia.
#'
#' @param proyectos Carpetas de documentos. Por defecto, la carpeta actual.
#' @param recursivo Si es `TRUE`, busca documentos dentro de las carpetas
#'   indicadas y sus subcarpetas.
#'
#' @return Un `data.frame` con las columnas `proyecto`, `version` y
#'   `estado`, de forma invisible.
#' @export
#' @examples
#' dir <- tempdir()
#' nuevo_documento("nota-ejemplo", tipo = "nota", directorio = dir, abrir = FALSE)
#' diagnosticar_brand(file.path(dir, "nota-ejemplo"))
diagnosticar_brand <- function(proyectos = ".", recursivo = FALSE) {
  proyectos <- resolver_proyectos(proyectos, recursivo)
  huella_paquete <- huella_extension(ruta_extension())

  if (length(proyectos) == 0) {
    cli::cli_alert_info("No se encontraron documentos de MetaDocencia.")
    return(invisible(data.frame(proyecto = character(), version = character(),
                                estado = character())))
  }

  res <- do.call(rbind, lapply(proyectos, function(p) {
    ext <- fs::path(p, "_extensions", nombre_extension())
    estado <- if (fs::dir_exists(ext)) {
      if (identical(huella_extension(ext), huella_paquete)) "actualizado" else "desactualizado"
    } else if (fs::file_exists(fs::path(p, "_brand.yml"))) {
      "formato anterior"
    } else {
      "ausente"
    }
    data.frame(proyecto = as.character(p), version = version_extension(ext),
               estado = estado, stringsAsFactors = FALSE)
  }))

  for (i in seq_len(nrow(res))) {
    txt <- "{.path {res$proyecto[i]}} ({res$estado[i]})"
    switch(res$estado[i],
      "actualizado" = cli::cli_alert_success(txt),
      "desactualizado" = cli::cli_alert_warning(txt),
      "formato anterior" = cli::cli_alert_warning(txt),
      cli::cli_alert_danger(txt)
    )
  }
  invisible(res)
}

#' Actualizar la identidad visual en documentos existentes
#'
#' Reemplaza la extensión de Quarto (`_extensions/metadocencia/`) de cada
#' documento por la versión del paquete instalado. Así, cuando cambian
#' colores, logo, tipografías o plantillas, alcanza con actualizar el
#' paquete y correr esta función. El contenido de los `.qmd` no se toca.
#'
#' @inheritParams diagnosticar_brand
#' @param confirmar Si es `TRUE`, pide confirmación antes de actualizar cada
#'   documento. Por defecto, solo en sesiones interactivas.
#'
#' @return Las rutas de los documentos actualizados, de forma invisible.
#' @export
#' @examples
#' dir <- tempdir()
#' nuevo_documento("nota-ejemplo2", tipo = "nota", directorio = dir, abrir = FALSE)
#' actualizar_brand(file.path(dir, "nota-ejemplo2"), confirmar = FALSE)
actualizar_brand <- function(proyectos = ".", recursivo = FALSE,
                             confirmar = interactive()) {
  diag <- suppressMessages(diagnosticar_brand(proyectos, recursivo))
  actualizados <- character()

  for (i in seq_len(nrow(diag))) {
    p <- diag$proyecto[i]
    estado <- diag$estado[i]
    if (estado == "actualizado") {
      cli::cli_alert_info("{.path {p}}: ya est\u00e1 actualizado.")
      next
    }
    if (estado != "desactualizado") {
      cli::cli_alert_warning("{.path {p}}: {estado}, se omite.")
      next
    }
    if (isTRUE(confirmar)) {
      r <- readline(paste0("\u00bfActualizar '", p, "'? [s/N]: "))
      if (!tolower(trimws(r)) %in% c("s", "si", "s\u00ed", "y", "yes")) {
        cli::cli_alert_warning("Omitido: {.path {p}}")
        next
      }
    }
    copiar_extension(p)
    cli::cli_alert_success("Actualizado: {.path {p}}")
    actualizados <- c(actualizados, p)
  }

  cli::cli_alert_info("{length(actualizados)} documento(s) actualizado(s) a la versi\u00f3n {version_extension(ruta_extension())}.")
  invisible(actualizados)
}

# Expande las carpetas a revisar. Con recursivo = TRUE busca carpetas que
# contengan _extensions/metadocencia/ o un _brand.yml del formato anterior.
resolver_proyectos <- function(proyectos, recursivo) {
  proyectos <- fs::path_expand(proyectos)
  faltan <- proyectos[!fs::dir_exists(proyectos)]
  if (length(faltan) > 0) {
    cli::cli_abort("No existe la carpeta {.path {faltan}}.")
  }
  if (!recursivo) return(fs::path_abs(proyectos))

  encontrados <- unlist(lapply(proyectos, function(raiz) {
    dirs <- fs::dir_ls(raiz, type = "directory", recurse = TRUE, all = FALSE)
    con_ext <- dirs[fs::path_file(dirs) == nombre_extension() &
                      fs::path_file(fs::path_dir(dirs)) == "_extensions"]
    nuevos <- fs::path_dir(fs::path_dir(con_ext))
    brands <- fs::dir_ls(raiz, recurse = TRUE, regexp = "/_brand\\.yml$", all = FALSE)
    brands <- brands[!grepl("/_extensions/", brands)]
    c(as.character(nuevos), as.character(fs::path_dir(brands)))
  }))
  sort(unique(as.character(fs::path_abs(encontrados))))
}
