// Variant 2: "brain" above ground, "root" as roots below -- the pun drawn.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Helvetica", size: 13pt)
#brainroot(title: branch([brainroot], fill: rgb("#1a1a2e")), layout: "down", palette: "earth",
  theme: (scale: (1.7, 1, 1), thickness: (2.5pt, 1.5pt), inset: (x: 8pt, y: 4pt)),
  spacing: (level: 12pt, root: 18pt, sibling: 6pt, branch: 8pt),
  branch([idea], [a], [b]), branch([plan], [c]), branch([map], [d], [e]), branch([link], [f]),
)
