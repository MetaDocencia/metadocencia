-- ::: {.destacado} ... ::: -> bloque resaltado con el color del brand.
-- En HTML y RevealJS lo resuelve el CSS (.destacado); en Typst se traduce
-- a la función `destacado()` definida en typst/typst-template.typ.

function Div(el)
  if not el.classes:includes("destacado") then
    return nil
  end
  if quarto.doc.is_format("typst") then
    local bloques = pandoc.List({
      pandoc.RawBlock("typst",
        "#destacado(color: brand-color.at(\"naranja\", default: rgb(\"#F77B20\")))[")
    })
    bloques:extend(el.content)
    bloques:insert(pandoc.RawBlock("typst", "]"))
    return bloques
  end
  return nil
end
