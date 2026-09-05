// Variant 2: "brain" above ground, "root" as roots below -- the pun drawn.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Helvetica", size: 13pt)
#brainroot(title: [brainroot], layout: "down", palette: "earth", root-fill: rgb("#1a1a2e"),
  scale: (1.7, 1, 1), level-gap: 12pt, root-gap: 18pt, sibling-gap: 6pt, branch-gap: 8pt,
  thickness: (2.5pt, 1.5pt), inset: (x: 8pt, y: 4pt),
  branch([idea], [a], [b]), branch([plan], [c]), branch([map], [d], [e]), branch([link], [f]),
)
