// Variant 4: a square mark without words -- a root pill and coloured
// branches, for favicons and avatars.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(size: 10pt)
#brainroot(title: branch([#h(14pt)], fill: rgb("#1a1a2e")), layout: (kind: "radial", start: 90deg),
  theme: (radius: 50%, thickness: (3pt,), inset: (x: 6pt, y: 6pt)),
  spacing: (root: 22pt, level: 10pt, branch: 6pt),
  branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]),
)
