test_that("el brand tiene la identidad de MetaDocencia", {
  b <- leer_brand()
  expect_equal(b$meta$name, "MetaDocencia")
  expect_equal(unname(colores_metadocencia("primary")), "#00506F")
  expect_equal(unname(colores_metadocencia("rojo", "naranja")), c("#C83737", "#F77B20"))
  expect_true(file.exists(file.path(dirname(ruta_brand()),
                                    b$logo$images$horizontal$path)))
})

test_that("leer_brand no depende del locale de la sesi\u00f3n", {
  viejo <- Sys.getlocale("LC_CTYPE")
  on.exit(Sys.setlocale("LC_CTYPE", viejo))
  suppressWarnings(Sys.setlocale("LC_CTYPE", "C"))
  expect_false(is.null(leer_brand()$typography))
})

test_that("paleta_metadocencia respeta el orden de la gu\u00eda", {
  expect_equal(paleta_metadocencia(),
               c("#C83737", "#C86E37", "#00506F", "#F77B20", "#00788F"))
  # El azul-verde aparece solo con 5 colores
  expect_false("#00788F" %in% paleta_metadocencia(4))
  expect_warning(p <- paleta_metadocencia(7), "repetir")
  expect_length(p, 7)
  expect_error(colores_metadocencia("inexistente"), "no est")
})

test_that("tema y escalas de ggplot2 funcionan", {
  skip_if_not_installed("ggplot2")
  g <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = factor(cyl))) +
    ggplot2::geom_point() +
    theme_metadocencia() +
    scale_colour_metadocencia()
  expect_s3_class(g, "ggplot")
  expect_silent(ggplot2::ggplot_build(g))
})
