// Variant 3: hand-drawn, handwriting font, whiteboard colours.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Patrick Hand", size: 16pt)
#brainroot(title: [brainroot], theme: "hand", root-fill: rgb("#1a1a2e"), scale: (1.6, 1, 1),
  level-gap: 18pt, root-gap: 34pt, sibling-gap: 5pt, branch-gap: 10pt, thickness: (2.5pt, 1.5pt),
  inset: (x: 8pt, y: 5pt),
  branch([idea], [spark]), branch([plan]), branch([map], [path]),
  branch([think], [note]), branch([link]), branch([grow], [leaf]),
)
