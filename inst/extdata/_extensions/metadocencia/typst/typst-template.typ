// Plantilla PDF (Typst) de MetaDocencia.
// Misma firma que la función `article` de Quarto 1.9, más parámetros
// propios (marcados con "metadocencia:"). Jerarquía según la guía de estilo:
// H1 Barlow 37pt gris + línea azul · H2 Barlow 19pt rojo · H3 Barlow 16pt azul.

#let article(
  // metadocencia: identidad (diccionarios que Quarto arma desde _brand.yml)
  colores: (:),
  logo: none,
  institucion: none,
  // metadocencia: variantes
  tipo: "reporte",       // "reporte" | "nota"
  destinatario: none,    // solo para tipo "nota"
  referencia: none,      // solo para tipo "nota"
  // parámetros estándar de Quarto
  title: none,
  subtitle: none,
  authors: none,
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  lang: "es",
  region: "AR",
  font: none,
  fontsize: 12pt,
  title-size: 2.2em,
  subtitle-size: 1.3em,
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  // ---- Colores de la guía (con valores de respaldo) ----------------------
  let c(nombre, respaldo) = colores.at(nombre, default: rgb(respaldo))
  let azul = c("azul", "#00506F")
  let rojo = c("rojo", "#C83737")
  let naranja = c("naranja", "#F77B20")
  let gris-texto = c("gris-texto", "#404040")
  let gris-suave = c("gris-suave", "#F5F8FA")
  let gris-linea = c("gris-linea", "#DDDDDD")
  let titulos = if heading-family != none { heading-family } else { ("Barlow",) }

  set document(title: title, keywords: keywords)
  set document(
    author: authors.map(author => content-to-string(author.name)).join(", ", last: " y "),
  ) if authors != none and authors != ()

  set par(justify: true, leading: linestretch * 0.65em)
  set text(lang: lang, region: region, size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none
  show raw.where(block: false): it => box(
    fill: gris-suave, inset: (x: 3pt), outset: (y: 2pt), radius: 2pt,
    text(fill: azul, it),
  )
  set heading(numbering: sectionnumbering)

  show link: set text(fill: rgb(content-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb(content-to-string(citecolor))) if citecolor != none

  // ---- Encabezado y pie (como el header.tex anterior) --------------------
  set page(
    header: {
      set text(size: 0.8em, fill: gris-texto, font: titulos)
      grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        if logo != none { image(logo.path, height: 0.9cm, alt: logo.at("alt", default: none)) },
        institucion,
      )
      v(-0.35em)
      line(length: 100%, stroke: 1.5pt + azul)
    },
    footer: context {
      set text(size: 0.8em, fill: gris-texto)
      line(length: 100%, stroke: 0.4pt + naranja)
      v(-0.4em)
      grid(
        columns: (1fr, auto, 1fr),
        align: (left, center, right),
        [],
        counter(page).display(),
        if date != none { date },
      )
    },
  )

  // ---- Títulos -------------------------------------------------------------
  // Quarto sube un nivel los títulos en Typst: `##` del .qmd llega como
  // nivel 1. Así el PDF coincide con el HTML: el título del documento hace
  // de H1 de la guía, `##` es rojo y `###` es azul.
  show heading: set text(font: titulos)
  show heading.where(level: 1): it => block(above: 1.5em, below: 0.8em,
    text(size: 19pt, weight: 700, fill: rojo, it))
  show heading.where(level: 2): it => block(above: 1.2em, below: 0.6em,
    text(size: 16pt, weight: 400, fill: azul, it))
  show heading.where(level: 3): it => block(above: 1em, below: 0.5em,
    text(size: 13pt, weight: 700, fill: gris-texto, it))
  // Índice: título como el H1 de la guía (gris, con línea azul)
  show outline: set heading(numbering: none)
  show outline.entry.where(level: 1): set text(weight: 700)

  // ---- Tablas --------------------------------------------------------------
  set table(
    inset: 6pt,
    stroke: 0.5pt + gris-linea,
    fill: (x, y) => if y == 0 { azul } else if calc.even(y) { gris-suave },
  )
  show table.cell.where(y: 0): set text(fill: white, weight: 700, font: titulos)

  // ---- Bloque de título ---------------------------------------------------
  if tipo == "nota" {
    block(width: 100%, inset: (bottom: 0.8em), stroke: (bottom: 1.5pt + azul))[
      #text(size: 1.8em, weight: 700, fill: gris-texto, font: titulos)[
        #if title != none { title } else { [Nota] }
      ]
      #v(0.3em)
      #set text(size: 0.92em)
      #grid(
        columns: (auto, 1fr),
        column-gutter: 1em,
        row-gutter: 0.55em,
        ..(
          if destinatario != none { ([*Para:*], destinatario) } else { () },
          if authors != none and authors != () {
            ([*De:*], authors.map(a => a.name).join(", "))
          } else { () },
          if date != none { ([*Fecha:*], date) } else { () },
          if referencia != none { ([*Ref.:*], referencia) } else { () },
        ).flatten()
      )
    ]
    v(1em)
  } else {
    block(width: 100%, below: 1.8em,
      stroke: (left: 5pt + naranja), inset: (left: 1.1em, y: 0.4em))[
      #set par(justify: false, leading: 0.45em)
      #if title != none {
        // H1 de la guía de estilo: Barlow bold gris
        text(size: 30pt, weight: 700, fill: gris-texto, font: titulos)[#title]
      }
      #if thanks != none { footnote(thanks, numbering: "*") }
      #if subtitle != none {
        v(0.2em)
        text(size: subtitle-size, fill: azul, font: titulos)[#subtitle]
      }
      #if authors != none and authors != () {
        v(0.6em)
        set text(size: 0.92em)
        authors.map(a => {
          strong(a.name)
          if a.affiliation != [] { [ · #a.affiliation] }
        }).join(linebreak())
      }
    ]

    if abstract != none {
      block(width: 100%, fill: gris-suave, inset: 1em, below: 1.5em,
        stroke: (left: 3pt + azul))[
        #text(weight: 700, fill: azul, font: titulos)[#abstract-title] \
        #abstract
      ]
    }
  }

  if toc and tipo != "nota" {
    block(below: 2em)[
      #outline(title: toc_title, depth: toc_depth, indent: toc_indent)
    ]
  }

  if cols == 1 { doc } else { columns(cols, doc) }
}

// ::: {.destacado} en el .qmd (lo traduce destacado.lua)
#let destacado(body, color: rgb("#F77B20")) = block(
  width: 100%,
  inset: (x: 1em, y: 0.8em),
  fill: rgb("#F5F8FA"),
  stroke: (left: 4pt + color),
  body,
)
