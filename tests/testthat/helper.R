# Carpeta temporal que se borra al terminar cada test
carpeta_temporal <- function(env = parent.frame()) {
  d <- tempfile("md-test-")
  dir.create(d)
  do.call(on.exit, list(substitute(unlink(d, recursive = TRUE), list(d = d)),
                        add = TRUE), envir = env)
  d
}
