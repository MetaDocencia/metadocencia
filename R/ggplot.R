#' Tema de ggplot2 de MetaDocencia
#'
#' Aplica la guía de estilo a los gráficos: Barlow para títulos, Open Sans
#' para el resto, grilla horizontal suave y línea base azul. Colores y
#' tipografías se leen del `_brand.yml`. Si las fuentes no están instaladas
#' en el sistema, se usa la fuente por defecto sin error.
#'
#' @param base_size Tamaño base del texto, en puntos.
#' @param base_family Fuente del texto. Por defecto, la del `_brand.yml`.
#' @param brand Lista devuelta por [leer_brand()].
#' @return Un tema de ggplot2.
#' @export
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'   ggplot(mpg, aes(displ, hwy, colour = drv)) +
#'     geom_point() +
#'     scale_colour_metadocencia() +
#'     theme_metadocencia()
#' }
theme_metadocencia <- function(base_size = 12, base_family = NULL,
                               brand = leer_brand()) {
  requerir_ggplot2()
  col <- function(x) unname(resolver_color(x, brand))
  azul <- col("azul")
  gris_texto <- col("gris-texto")
  gris_linea <- col("gris-linea")

  cuerpo <- fuente_si_existe(base_family %||% brand$typography$base$family)
  titulos <- fuente_si_existe(brand$typography$headings$family)
  el <- ggplot2::element_text

  ggplot2::theme_minimal(base_size = base_size, base_family = cuerpo) +
    ggplot2::theme(
      text = el(family = cuerpo, colour = gris_texto),
      plot.title = el(family = titulos, face = "bold", size = ggplot2::rel(1.4),
                      colour = gris_texto, margin = ggplot2::margin(b = 4)),
      plot.subtitle = el(family = titulos, colour = azul,
                         margin = ggplot2::margin(b = 12)),
      plot.caption = el(size = ggplot2::rel(.75), colour = "#888888", hjust = 1,
                        margin = ggplot2::margin(t = 8)),
      plot.title.position = "plot",
      axis.title = el(family = titulos, face = "bold", size = ggplot2::rel(.95),
                      colour = azul),
      axis.title.x = el(margin = ggplot2::margin(t = 8)),
      axis.title.y = el(margin = ggplot2::margin(r = 8)),
      axis.text = el(size = ggplot2::rel(.85), colour = gris_texto),
      axis.ticks = ggplot2::element_line(colour = gris_linea, linewidth = .3),
      axis.line.x = ggplot2::element_line(colour = azul, linewidth = .6),
      panel.grid.major.y = ggplot2::element_line(colour = gris_linea, linewidth = .4),
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA),
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),
      legend.title = el(family = titulos, face = "bold", size = ggplot2::rel(.9)),
      legend.text = el(size = ggplot2::rel(.85)),
      legend.position = "bottom",
      strip.text = el(family = titulos, face = "bold", size = ggplot2::rel(.9),
                      colour = "white"),
      strip.background = ggplot2::element_rect(fill = azul, colour = NA),
      plot.margin = ggplot2::margin(16, 16, 12, 16)
    )
}

#' Escalas de color de MetaDocencia para ggplot2
#'
#' Escalas discretas con [paleta_metadocencia()]: rojo, rojo-naranja, azul,
#' naranja y, si hace falta, azul-verde.
#'
#' @param ... Argumentos para [ggplot2::discrete_scale()].
#' @return Una escala de ggplot2.
#' @export
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'   ggplot(mpg, aes(class, fill = drv)) +
#'     geom_bar() +
#'     scale_fill_metadocencia()
#' }
scale_color_metadocencia <- function(...) escala_discreta("colour", ...)

#' @rdname scale_color_metadocencia
#' @export
scale_colour_metadocencia <- scale_color_metadocencia

#' @rdname scale_color_metadocencia
#' @export
scale_fill_metadocencia <- function(...) escala_discreta("fill", ...)

escala_discreta <- function(estetica, ...) {
  requerir_ggplot2()
  paleta <- function(n) paleta_metadocencia(n)
  # ggplot2 < 3.5 exige `scale_name`; desde 3.5 está obsoleto.
  if (utils::packageVersion("ggplot2") < "3.5.0") {
    ggplot2::discrete_scale(estetica, scale_name = "metadocencia",
                            palette = paleta, ...)
  } else {
    ggplot2::discrete_scale(estetica, palette = paleta, ...)
  }
}

requerir_ggplot2 <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    cli::cli_abort("Esta funci\u00f3n necesita {.pkg ggplot2}: {.code install.packages(\"ggplot2\")}")
  }
}

fuente_si_existe <- function(familia) {
  if (is.null(familia) || !requireNamespace("systemfonts", quietly = TRUE)) return("")
  if (familia %in% systemfonts::system_fonts()$family) familia else ""
}

`%||%` <- function(x, y) if (is.null(x)) y else x
