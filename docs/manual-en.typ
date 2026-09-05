// The English manual, website and PDF in one run:
//
//   typst compile manual-en.typ build --format bundle --features bundle,html --root ../../..
//
// A second entry point rather than a switch inside `docs.typ`: `docs()` is a
// show rule and emits exactly two documents, so one file cannot carry both
// languages. The content sits in `content-en.typ`; the German manual is
// `docs.typ` with `content.typ`.

#import "@schule/schuldocs:0.3.0": *

#set text(lang: "en")

#show: docs.with(
  lang: "en",
  toml: toml("../typst.toml"),
  // The logo instead of the name in the header, as SVG: Typst turns the
  // text into paths on export, so it hangs on no font. The web header is
  // one line and takes it small; the PDF title page has the room for it.
  logo: context image("../assets/logo.svg", alt: "brainroot",
    height: if target() == "html" { 1.7em } else { 4.5em }),
  html-name: "en.html",
  pdf-name: "brainroot-en.pdf",
  abstract: [The `brainroot` package draws mind maps from nested lists: coloured branches down to the leaves, seven layouts from two-sided to radial, twelve themes with a hand-drawn mode, maps with gaps and their solution. The layout is automatic.],
  links: (
    (name: "GitHub", url: "https://github.com/Loewe1000/brainroot"),
    (name: "Deutsch", url: "index.html"),
  ),
  notices: ([Part of the Schule Typst ecosystem],),
)

#include "content-en.typ"
