#import "../lib.typ": *
#import "_map.typ": small
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Helvetica", size: 6pt)
#let tiny = [
  - Kinetic
    - Motion
    - Wind
  - Elastic
    - Stretching
  - Thermal
    - Fire
  - Potential
    - Gravity
]
#grid(columns: 5, gutter: 10pt,
  ..("soft", "outline", "blocks", "lines", "sketch", "bubbles", "hand", "scribble", "marker", "pencil").map(t => [
    #set text(font: if t in ("hand", "scribble", "marker", "pencil") { "Patrick Hand" } else { "Helvetica" })
    #align(center)[#text(font: "Menlo", size: 7pt, t)]
    #v(2pt)
    #brainroot(title: [Energy], theme: (base: t, inset: (x: 5pt, y: 3pt)), tiny, spacing: (level: 14pt, root: 28pt))
  ])
)
