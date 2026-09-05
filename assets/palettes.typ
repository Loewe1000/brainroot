#import "../lib.typ": *
#set page(width: auto, height: auto, margin: 6pt)
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
    #brainroot(title: [Energy], palette: p, tiny, level-gap: 14pt, root-gap: 28pt, inset: (x: 5pt, y: 3pt))
  ])
)
