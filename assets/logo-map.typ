// Variant 1: the word as the root of a small map, three branches each side.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Helvetica", size: 14pt)
#brainroot(title: [brainroot], root-fill: rgb("#1a1a2e"), scale: (1.6, 1, 1),
  level-gap: 18pt, root-gap: 34pt, sibling-gap: 5pt, branch-gap: 10pt, thickness: (2.5pt, 1.5pt),
  inset: (x: 8pt, y: 4pt), radius: 6pt,
  branch([idea], [spark]), branch([plan]), branch([map], [path]),
  branch([think], [note]), branch([link]), branch([grow], [leaf]),
)
