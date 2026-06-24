function Div(el)
  if el.classes:includes("indication") then
    local titre = el.attributes["titre"] or "Indication"
    local summary = "<summary><em>" .. titre .. "</em></summary>"
    return pandoc.RawBlock("html", "<details>" .. summary ..
      pandoc.write(pandoc.Pandoc(el.content), "html") ..
      "</details>")
  end
end