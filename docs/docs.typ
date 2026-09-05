#import "@schule/schuldocs:0.3.0": *

#set text(lang: "de")

#show: docs.with(
  toml: toml("../typst.toml"),
  // The logo instead of the name in the header, as SVG: Typst turns the
  // text into paths on export, so it hangs on no font. The web header is
  // one line and takes it small; the PDF title page has the room for it.
  logo: context image("../assets/logo.svg", alt: "brainroot",
    height: if target() == "html" { 1.7em } else { 4.5em }),
  abstract: [Das `brainroot`-Paket zeichnet Mindmaps aus verschachtelten Listen: farbige Äste bis in die Blätter, sieben Anordnungen von zweiseitig bis radial, zwölf Themes mit handgezeichnetem Modus, Lückenkarten mit Lösung. Das Layout entsteht automatisch.],
  links: (
    (name: "GitHub", url: "https://github.com/Loewe1000/brainroot"),
    (name: "English", url: "en.html"),
  ),
  notices: ([Entwickelt für das Schule-Typst-Ökosystem],),
)

#include "content.typ"
