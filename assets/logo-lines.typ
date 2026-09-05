// Variant 5: the `lines` theme -- the word on a dark pill, branches as bare
// coloured lines with words on them. Quiet, works small.
#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 4pt)
#set text(font: "Helvetica", size: 13pt)
#brainroot(title: branch([brainroot], fill: rgb("#1a1a2e")),
  theme: (base: "lines", scale: (1.6, 1, 1), thickness: (2.5pt, 1.5pt), inset: (x: 8pt, y: 3pt)),
  spacing: (level: 16pt, root: 30pt, sibling: 3pt, branch: 8pt),
  branch([idea]), branch([map]), branch([link]),
  branch([think]), branch([plan]), branch([grow]),
)
