#' Leer la identidad visual de MetaDocencia
#'
#' Lee el `_brand.yml` del paquete (o uno indicado) y devuelve su contenido
#' como lista.
#'
#' @param ruta Ruta a un `_brand.yml`. Por defecto, el del paquete.
#' @return Una lista con la estructura de brand.yml.
#' @export
#' @examples
#' names(leer_brand()$color$palette)
leer_brand <- function(ruta = ruta_brand()) {
  if (!file.exists(ruta)) {
    cli::cli_abort("No existe el archivo {.path {ruta}}.")
  }
  yaml::yaml.load(leer_utf8(ruta))
}

#' Colores de MetaDocencia
#'
#' Devuelve colores del `_brand.yml` como vector con nombre. Acepta nombres
#' de la paleta (`"azul"`, `"rojo-40"`) y roles (`"primary"`).
#'
#' @param ... Nombres de colores. Sin argumentos, devuelve la paleta
#'   completa.
#' @param brand Lista devuelta por [leer_brand()].
#' @return Vector de texto con códigos hexadecimales.
#' @export
#' @examples
#' colores_metadocencia("azul", "rojo", "naranja")
#' colores_metadocencia("primary")
colores_metadocencia <- function(..., brand = leer_brand()) {
  pedidos <- c(...)
  if (length(pedidos) == 0) return(unlist(brand$color$palette))
  vapply(pedidos, resolver_color, character(1), brand = brand)
}

resolver_color <- function(nombre, brand, profundidad = 0) {
  if (profundidad > 5) cli::cli_abort("Referencia circular entre colores del brand.")
  if (grepl("^#", nombre)) return(nombre)
  paleta <- brand$color$palette
  if (!is.null(paleta[[nombre]])) {
    return(resolver_color(paleta[[nombre]], brand, profundidad + 1))
  }
  rol <- brand$color[[nombre]]
  if (is.character(rol)) return(resolver_color(rol, brand, profundidad + 1))
  cli::cli_abort("El color {.val {nombre}} no est\u00e1 definido en el {.file _brand.yml}.")
}

#' Paleta categórica de MetaDocencia
#'
#' Colores para gráficos categóricos, en el orden definido por la guía de
#' estilo: rojo, rojo-naranja, azul, naranja y, solo si hace falta un quinto
#' color, azul-verde. El orden se define en `_brand.yml`
#' (`defaults: metadocencia: paleta-categorica`).
#'
#' @param n Cantidad de colores. Por defecto, los cinco.
#' @param brand Lista devuelta por [leer_brand()].
#' @return Vector de texto con códigos hexadecimales.
#' @export
#' @examples
#' paleta_metadocencia()
#' paleta_metadocencia(3)
paleta_metadocencia <- function(n = NULL, brand = leer_brand()) {
  orden <- unlist(brand$defaults$metadocencia$`paleta-categorica`)
  base <- unname(vapply(orden, resolver_color, character(1), brand = brand))
  if (is.null(n)) return(base)
  if (n > length(base)) {
    cli::cli_warn(c(
      "La paleta de MetaDocencia tiene {length(base)} colores y se pidieron {n}.",
      "i" = "Los colores se van a repetir."
    ))
  }
  rep_len(base, n)
}
