// Variant 4: a square mark without words -- a root pill and coloured
// branches, for favicons and avatars.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(size: 10pt)
#brainroot(title: [#h(14pt)], root-fill: rgb("#1a1a2e"), layout: "radial", start: 90deg,
  root-gap: 22pt, level-gap: 10pt, branch-gap: 6pt, thickness: (3pt,), inset: (x: 6pt, y: 6pt),
  theme: (radius: 50%),
  branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]), branch([#h(6pt)]),
)
