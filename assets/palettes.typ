#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Helvetica", size: 6pt)
#let tiny = [
  - Kinetic
    - Motion
  - Elastic
    - Stretching
  - Thermal
    - Fire
  - Potential
    - Gravity
]
#grid(columns: 5, gutter: 10pt,
  ..("poster", "pastel", "grayscale", "mono", "plain", "earth", "ocean", "sunset", "forest", "neon").map(p => [
    #align(center)[#text(font: "Menlo", size: 7pt, p)]
    #v(2pt)
    #brainroot(title: [Energy], palette: p, tiny, spacing: (level: 14pt, root: 28pt), theme: (inset: (x: 5pt, y: 3pt)))
  ])
)
