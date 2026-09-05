// Variant 5: the `lines` theme -- the word on a dark pill, branches as bare
// coloured lines with words on them. Quiet, works small.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Helvetica", size: 13pt)
#brainroot(title: [brainroot], theme: "lines", root-fill: rgb("#1a1a2e"), scale: (1.6, 1, 1),
  level-gap: 16pt, root-gap: 30pt, sibling-gap: 3pt, branch-gap: 8pt, thickness: (2.5pt, 1.5pt),
  inset: (x: 8pt, y: 3pt),
  branch([idea]), branch([map]), branch([link]),
  branch([think]), branch([plan]), branch([grow]),
)
