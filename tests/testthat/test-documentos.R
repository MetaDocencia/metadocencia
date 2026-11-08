test_that("nuevo_documento crea carpeta, extensi\u00f3n y .qmd", {
  dir <- carpeta_temporal()
  destino <- suppressMessages(
    nuevo_documento("informe", tipo = "reporte-pdf", directorio = dir, abrir = FALSE)
  )
  qmd <- file.path(destino, "informe.qmd")
  expect_true(file.exists(qmd))
  expect_true(file.exists(file.path(destino, "_quarto.yml")))
  ext <- file.path(destino, "_extensions", "metadocencia")
  expect_true(file.exists(file.path(ext, "_extension.yml")))
  expect_true(file.exists(file.path(ext, "brand", "_brand.yml")))
  # El marcador de formato se reemplaza
  texto <- readLines(qmd, encoding = "UTF-8")
  expect_true(any(grepl("format: metadocencia-typst", texto, fixed = TRUE)))
  expect_false(any(grepl("__FORMATO__", texto, fixed = TRUE)))
})

test_that("cada tipo del cat\u00e1logo se puede crear", {
  dir <- carpeta_temporal()
  for (t in listar_tipos()$tipo) {
    destino <- suppressMessages(nuevo_documento(t, tipo = t, directorio = dir, abrir = FALSE))
    expect_true(file.exists(file.path(destino, paste0(t, ".qmd"))))
  }
})

test_that("nuevo_documento valida nombre, tipo y carpeta existente", {
  dir <- carpeta_temporal()
  expect_error(nuevo_documento("con espacios", directorio = dir, abrir = FALSE), "no es v")
  expect_error(nuevo_documento("x", tipo = "poster", directorio = dir, abrir = FALSE))
  suppressMessages(nuevo_documento("doble", directorio = dir, abrir = FALSE))
  expect_error(nuevo_documento("doble", directorio = dir, abrir = FALSE), "Ya existe")
})

test_that("diagnosticar_brand distingue los cuatro estados", {
  dir <- carpeta_temporal()
  suppressMessages({
    nuevo_documento("al-dia", directorio = dir, abrir = FALSE)
    nuevo_documento("viejo", tipo = "nota", directorio = dir, abrir = FALSE)
  })
  writeLines("// modificado", file.path(dir, "viejo", "_extensions", "metadocencia",
                                       "html", "estilos.scss"))
  dir.create(file.path(dir, "anterior"))
  writeLines("color: {}", file.path(dir, "anterior", "_brand.yml"))
  dir.create(file.path(dir, "otra-cosa"))

  d <- suppressMessages(diagnosticar_brand(
    file.path(dir, c("al-dia", "viejo", "anterior", "otra-cosa"))
  ))
  expect_equal(d$estado, c("actualizado", "desactualizado", "formato anterior", "ausente"))

  rec <- suppressMessages(diagnosticar_brand(dir, recursivo = TRUE))
  expect_setequal(basename(rec$proyecto), c("al-dia", "viejo", "anterior"))
})

test_that("actualizar_brand solo reemplaza lo desactualizado", {
  dir <- carpeta_temporal()
  suppressMessages({
    nuevo_documento("a", directorio = dir, abrir = FALSE)
    nuevo_documento("b", directorio = dir, abrir = FALSE)
  })
  scss <- file.path(dir, "b", "_extensions", "metadocencia", "html", "estilos.scss")
  writeLines("// modificado", scss)

  act <- suppressMessages(actualizar_brand(dir, recursivo = TRUE, confirmar = FALSE))
  expect_equal(basename(act), "b")
  expect_false(identical(readLines(scss), "// modificado"))

  d <- suppressMessages(diagnosticar_brand(dir, recursivo = TRUE))
  expect_true(all(d$estado == "actualizado"))
})
