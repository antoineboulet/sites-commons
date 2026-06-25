-- ─── hint.lua ────────────────────────────────────────────────────────────────
-- Transforme un div .indication en bloc <details>/<summary> HTML.
-- On construit la structure via l'AST Pandoc plutôt qu'en écrivant du HTML
-- brut, pour que les filtres suivants (margin-html-figure.lua, etc.)
-- voient encore le contenu.
-- ─────────────────────────────────────────────────────────────────────────────

function Div(el)
  if not el.classes:includes("indication") then return nil end

  local titre = el.attributes["titre"] or "Indication"

  -- <summary> construit comme un Para inline
  local summary = pandoc.Div(
    { pandoc.Para({ pandoc.Emph({ pandoc.Str(titre) }) }) },
    pandoc.Attr("", {}, {})
  )

  -- Bloc <details> : summary + contenu original
  local details = pandoc.Div(
    { summary, pandoc.Div(el.content) },
    pandoc.Attr("", {}, {})
  )

  -- On pose les balises HTML via RawBlock uniquement pour l'enveloppe,
  -- pas pour le contenu — les filtres suivants voient toujours el.content
  if quarto and quarto.doc.is_format("html") then
    return {
      pandoc.RawBlock("html", "<details><summary><em>" .. titre .. "</em></summary>"),
      pandoc.Div(el.content),
      pandoc.RawBlock("html", "</details>")
    }
  end

  -- Format non-HTML (PDF, etc.) : on garde le contenu brut sans l'enveloppe
  return el.content
end