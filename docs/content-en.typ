#import "@schule/schuldocs:0.2.0": show-example, show-module, show-code


= About this package

A mind map the way it grows on a whiteboard: one term in the middle, the
headings to its right and left, the examples behind them. `brainroot` sets
such a map from a nested list. Every branch gets a colour it passes down to
its leaves; the boxes are filled with a lighter shade of that colour, the
connections run as soft curves.

The package builds on *CeTZ*. Boxes are measured, so they follow the font of
the surrounding document.

= Quick start

#show-code[```typ
#import "@preview/brainroot:0.2.0": brainroot, branch
```]

The simplest input is a list: every item becomes a node, indented items its
children.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Forms of energy])[
      - Kinetic energy
        - Motion
        - Wind
      - Elastic energy
        - Stretching
      - Thermal energy
        - Fire
      - Potential energy
        - Gravity
        - Weight
    ]
  },
  source: ```typ
#brainroot(title: [Forms of energy])[
  - Kinetic energy
    - Motion
    - Wind
  - Elastic energy
    - Stretching
  - Thermal energy
    - Fire
  - Potential energy
    - Gravity
    - Weight
]
  ```,
  width: 100%,
)

Three marks in the list carry node options: a Typst label `<name>` at the
end gives the node its `id` for cross-links, an item that is nothing but
`*bold*` highlights it, one that is nothing but `_emphasised_` becomes a gap.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Photosynthesis], links: (connect("light", "dark", label: [ATP]),))[
      - Light reaction <light>
        - *Photolysis*
        - _ATP_
      - Dark reaction <dark>
        - Calvin cycle
        - _Glucose_
    ]
  },
  source: ```typ
#brainroot(title: [Photosynthesis], links: (connect("light", "dark", label: [ATP]),))[
  - Light reaction <light>
    - *Photolysis*
    - _ATP_
  - Dark reaction <dark>
    - Calvin cycle
    - _Glucose_
]
  ```,
  width: 100%,
)

To describe a branch in more detail, write it as `branch(label, ..children)`.
A child is then either content, a leaf, or another `branch(...)`. A list and
`branch` calls may stand side by side; without `title` the first argument is
the root.

= Sides and colours

Left alone, `brainroot` distributes the branches itself: the first ones go
right until the right side is about half as tall as all branches together,
the rest go left. `side: left` or `side: right` pins a branch, `color` gives
it its own colour instead of the next one from the palette.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: branch([Photosynthesis], fill: green.lighten(50%)), spacing: (max-width: 3cm),
      branch([Light reaction], branch([Photolysis], [Water is split]), [ATP], side: right),
      branch([Dark reaction], [Calvin cycle], [Glucose], color: purple),
      branch([Requirements], [Light], [Water], [CO₂], side: left),
    )
  },
  source: ```typ
#brainroot(title: branch([Photosynthesis], fill: green.lighten(50%)), spacing: (max-width: 3cm),
  branch([Light reaction], branch([Photolysis], [Water is split]), [ATP], side: right),
  branch([Dark reaction], [Calvin cycle], [Glucose], color: purple),
  branch([Requirements], [Light], [Water], [CO₂], side: left),
)
  ```,
  width: 100%,
)

#let map = [
  - Kinetic energy
    - Motion
    - Wind
  - Elastic energy
    - Stretching
  - Thermal energy
    - Fire
  - Potential energy
    - Gravity
    - Weight
]

= Nodes

A label is content: formulas, images and links work as they do anywhere. An
`icon` sits left of the label or, with `icon-at: "top"`, above it. The root
is a `branch` too: `title: branch([Energy], icon: ..., fill: ...)`. Per node you can set `fill` (a colour, or `none` for a ring),
`ink`, and `mark: true` for a highlighted key term.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: branch([Energy], icon: text(size: 1.6em, emoji.bolt), icon-at: "top"),
      branch([Formula], [$E = 1/2 m v^2$], [$E = m g h$], icon: emoji.abacus),
      branch([Link], link("https://typst.app")[typst.app]),
      branch([Important], branch([Key term], mark: true), branch([Ring], fill: none), branch([Red], ink: red)))
  },
  source: ```typ
#brainroot(title: branch([Energy], icon: text(size: 1.6em, emoji.bolt), icon-at: "top"),
  branch([Formula], [$E = 1/2 m v^2$], [$E = m g h$], icon: emoji.abacus),
  branch([Link], link("https://typst.app")[typst.app]),
  branch([Important], branch([Key term], mark: true), branch([Ring], fill: none), branch([Red], ink: red)))
  ```,
  width: 100%,
)

== Gaps and the solution

`blank: true` on a branch draws its box empty, at full size. `blanks:
"leaves"`, `"branches"` or `"all"` does that for a whole class of nodes. The
same map with `solution: true` fills the gaps in, with `solution-ink` in a
colour that makes the answers stand out. Task and solution come from one
source.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Forms of energy], blanks: "leaves", map)
    v(4pt)
    brainroot(width: 100%, title: [Forms of energy], blanks: "leaves", solution: true, solution-ink: red, map)
  },
  source: ```typ
#brainroot(title: [Forms of energy], blanks: "leaves", map)
#brainroot(title: [Forms of energy], blanks: "leaves", solution: true, solution-ink: red, map)
  ```,
  width: 100%,
)

== Edge labels

`edge-label` puts a small label on the edge that leads to a node. That turns
the mind map into a probability tree or a decision tree. `equal: true` on a
branch makes its children the same size, `"width"` or `"height"` in one
direction; on the root it applies to the first level.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: branch([Start], equal: true), layout: "right", theme: "outline", palette: "plain",
      branch([Heads], branch([Heads], edge-label: $1/2$), branch([Tails], edge-label: $1/2$), edge-label: $1/2$, equal: true),
      branch([Tails], branch([Heads], edge-label: $1/2$), branch([Tails], edge-label: $1/2$), edge-label: $1/2$, equal: true))
  },
  source: ```typ
#brainroot(title: branch([Start], equal: true), layout: "right", theme: "outline", palette: "plain",
  branch([Heads], branch([Heads], edge-label: $1/2$), branch([Tails], edge-label: $1/2$), edge-label: $1/2$, equal: true),
  branch([Tails], branch([Heads], edge-label: $1/2$), branch([Tails], edge-label: $1/2$), edge-label: $1/2$, equal: true))
  ```,
  width: 100%,
)

== Cross-links, braces, clouds

A mind map is a tree; the ideas in it rarely are. `id` names a node,
`connect(from, to)` in `links` draws a curve between two nodes over the map,
with `label`, `arrow`, `dash` and `bend`. The root is called `"root"`.
`summary` puts a labelled brace beyond a node's children, `cloud` lays a
cloud behind its subtree. Braces and clouds exist in the tree layouts, not
in `radial` and `star`. `arrange: "links"` orders the branches and turns
children around so that linked nodes come close together; here CO₂ moves
next to glucose.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Photosynthesis], arrange: "links",
      links: (connect("light", "dark", label: [ATP, NADPH]), connect("co2", "glucose", label: [C], dash: "dotted")),
      branch([Light reaction], [Photolysis], [ATP], [NADPH], id: "light", cloud: true),
      branch([Dark reaction], [Calvin cycle], branch([Glucose], id: "glucose"), id: "dark", summary: [products]),
      branch([Requirements], [Light], [Water], branch([CO₂], id: "co2"), summary: [from outside]))
  },
  source: ```typ
#brainroot(title: [Photosynthesis], arrange: "links",
  links: (connect("light", "dark", label: [ATP, NADPH]), connect("co2", "glucose", label: [C], dash: "dotted")),
  branch([Light reaction], [Photolysis], [ATP], [NADPH], id: "light", cloud: true),
  branch([Dark reaction], [Calvin cycle], branch([Glucose], id: "glucose"), id: "dark", summary: [products]),
  branch([Requirements], [Light], [Water], branch([CO₂], id: "co2"), summary: [from outside]))
  ```,
  width: 100%,
)

== Points and building up

`points` on a branch counts for grading a map; `brainroot-points` with the
same arguments adds them up, `show-points: true` shows them as a badge on
the box. `reveal` draws only the first branches, or those for which a
function of the index is true. The layout stays put, so a map builds up
branch by branch, in typstage with
`build(from => brainroot(..., reveal: i => from(i + 2)), steps: 5)`.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Forms of energy], reveal: 2, show-points: true,
      branch([Kinetic energy], branch([Motion], points: 1), branch([Wind], points: 1)),
      branch([Elastic energy], branch([Stretching], points: 2)),
      branch([Thermal energy], [Fire]))
  },
  source: ```typ
#brainroot(title: [Forms of energy], reveal: 2, show-points: true,
  branch([Kinetic energy], branch([Motion], points: 1), branch([Wind], points: 1)),
  branch([Elastic energy], branch([Stretching], points: 2)),
  branch([Thermal energy], [Fire]))
  ```,
  width: 100%,
)

= Layouts

`layout` decides how the branches sit around the root. `both` is the
two-sided map from above, `right` and `left` put everything on one side.
`down` and `up` set a tree from top to bottom or the other way round, like an
org chart. `radial` is the classic Buzan mind map: the whole tree fans out
from the root, every subtree in a sector of its own. `star` only puts the
branches on a circle around the root, their subtrees grow horizontally
outward. `fishbone` is the Ishikawa cause-and-effect diagram: the root as
the head of a spine, the branches as ribs alternating above and below, the
leaves along the ribs; two levels below the root. `layout` also takes a
dictionary: `(kind: "down", align-levels: true)` puts every level on one
line in the tree layouts, as in an org chart; `start` is the angle of the
first branch in `radial` and `star`. Distances live in `spacing`, see
`spacing-defaults`.


#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Forms of energy], layout: "down", map)
  },
  source: ```typ
#brainroot(title: [Forms of energy], layout: "down", map)
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Forms of energy], layout: "radial", map,
      branch([Pressure]), branch([Radiation], [Light]))
  },
  source: ```typ
#brainroot(title: [Forms of energy], layout: "radial", map,
  branch([Pressure]), branch([Radiation], [Light]))
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Forms of energy], layout: "star", map,
      branch([Pressure]), branch([Radiation], [Light]))
  },
  source: ```typ
#brainroot(title: [Forms of energy], layout: "star", map,
  branch([Pressure]), branch([Radiation], [Light]))
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Bad grade], layout: "fishbone", theme: "outline",
      branch([Preparation], [started late], [no plan], [no practice]),
      branch([Lessons], [absent], [no notes]),
      branch([Exam], [time misjudged], [task misread]),
      branch([Setting], [noise], [tiredness]))
  },
  source: ```typ
#brainroot(title: [Bad grade], layout: "fishbone", theme: "outline",
  branch([Preparation], [started late], [no plan], [no practice]),
  branch([Lessons], [absent], [no notes]),
  branch([Exam], [time misjudged], [task misread]),
  branch([Setting], [noise], [tiredness]))
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Substances], layout: (kind: "down", align-levels: true), theme: "blocks",
      branch([Pure substances], branch([Elements], [Metals], [Non-metals]), [Compounds]),
      branch([Mixtures], [homogeneous], [heterogeneous]))
  },
  source: ```typ
#brainroot(title: [Substances], layout: (kind: "down", align-levels: true), theme: "blocks",
  branch([Pure substances], branch([Elements], [Metals], [Non-metals]), [Compounds]),
  branch([Mixtures], [homogeneous], [heterogeneous]))
  ```,
  width: 100%,
)

With `radial` and `star` the first branch sits at `start` (default `60deg`),
the others follow clockwise. With `radial` the children share their parent's
sector, weighted by the size of their subtrees, and sit on the ring of their
depth; the rings begin at `spacing.root` and are stretched until no two boxes
overlap.

= Palettes

`palette` provides the colours of the branches and the root; the boxes get
the branch colour lightened by `tint`. Ten palettes are built in, all shown
with the same map:

#let palettes = (
  poster: [Bright and bold, like markers on a whiteboard. The default.],
  pastel: [Soft, muted tones.],
  grayscale: [Greys only, for black-and-white printing.],
  mono: [One blue in varying lightness.],
  plain: [One dark ink for everything, as if drawn with a fountain pen.],
  earth: [Earth tones: terracotta, ochre, olive, sand.],
  ocean: [Sea: turquoise, teal, sea green.],
  sunset: [Evening sky: red, orange, pink, violet.],
  forest: [Forest: green with a little brown.],
  neon: [Loud, saturated colours.],
)
#for (name, description) in palettes [
  == #raw(name)
  #description
  #show-example(
    rendered: {
      import "../lib.typ": *
      set text(size: 8pt)
      brainroot(width: 100%, title: [Forms of energy], palette: name, map)
    },
    source: raw(lang: "typ", block: true, "#brainroot(title: [Forms of energy], palette: \"" + name + "\", map)"),
    width: 100%,
  )
]

Your own colours go in as an array, `palette: (red, blue, green)`, or with a
root colour as a dictionary, `palette: (colors: (red, blue), root: black)`.
A palette may also set `ink`, `ink-dark`, `ink-light` and `ink-threshold`,
the text colours; `base` takes a built-in palette as the starting point:
`palette: (base: "ocean", root: black)`. The root itself is coloured by
`title: branch([...], fill: ...)`.

= Themes

A theme decides how boxes and edges look; the colours still come from the
palette. Ten are built in:

#for (name, description) in (
  soft: [Pastel boxes with rounded corners, soft S-curves. The whiteboard original.],
  outline: [White boxes with a coloured border, curves.],
  blocks: [Solid square boxes with white text, right angles: org-chart look.],
  lines: [No boxes: the text sits on its coloured line and the edges flow into it. The classic mind map.],
  sketch: [Thin border without fill, dashed straight lines.],
  bubbles: [Pills with pastel fill and straight connections.],
  hand: [Like `soft`, but hand-drawn: every line wobbles slightly.],
  scribble: [Scribbled: no fill, every line drawn twice.],
  marker: [Felt-tip: solid colour, wide straight strokes with a long wobble.],
  pencil: [Pencil: thin lines with a fine tremor, right angles.],
  organic: [Organic after Buzan: branches that thin out towards the leaves, pastel pills.],
  twigs: [Twigs: white circles on the first level, bare leaves on a shared spine with a twig each, the infographic look.],
) [
  == #raw(name)
  #description
  #show-example(
    rendered: {
      import "../lib.typ": *
      set text(size: 8pt)
      brainroot(width: 100%, title: [Forms of energy], theme: name, map)
    },
    source: raw(lang: "typ", block: true, "#brainroot(title: [Forms of energy], theme: \"" + name + "\", map)"),
    width: 100%,
  )
]

== Shapes

The theme field `shape` turns the boxes into circles or ellipses; `size`
gives a fixed diameter per depth, as in a bubble tree. With a fixed diameter the
font shrinks to 60% so the text fits; if that is not enough the disc grows.
Without `size`, circles suit short labels, a long word makes a large disc. `shade` steps the branch colour per
level.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energy], layout: "radial", palette: "sunset",
      theme: (fill: "solid", shape: "circle", size: (5em, 4em, 2.8em), edge: "straight",
        thickness: (0.5em, 0.25em), scale: (1.1, 0.9, 0.7), shade: 25%))[
      - Motion
        - Wind
        - Travel
      - Heat
        - Fire
      - Height
        - Fall
        - Weight
    ]
  },
  source: ```typ
#brainroot(title: [Energy], layout: "radial", palette: "sunset",
  theme: (fill: "solid", shape: "circle", size: (5em, 4em, 2.8em), edge: "straight",
    thickness: (0.5em, 0.25em), scale: (1.1, 0.9, 0.7), shade: 25%))[ ... ]
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Mind Map], theme: (base: "outline", shape: "ellipse"), palette: "ocean", map)
  },
  source: ```typ
#brainroot(title: [Mind Map], theme: (base: "outline", shape: "ellipse"), palette: "ocean", map)
  ```,
  width: 100%,
)

== Hand-drawn

The themes `hand`, `scribble`, `marker` and `pencil` wobble every line after
the pattern of the TikZ decoration `sketch`: the path is walked in small
steps, every point is offset perpendicular to it by a slowly running sine
wave whose rhythm is set by a random walk. The randomness is reproducible,
the same map looks the same on every compile. A handwriting font such as
"Patrick Hand" or "Kalam" suits it; set it with `set text(font: ...)` or the
theme field `font`.

`wobble` sets the strength: `wobble: 0.5` wobbles half as much, `wobble: 2`
twice. The field `hand` controls the wobble in detail: `amplitude`
(excursion in pt), `wavelength` (in pt), `randomness` (irregularity, 1 is a
pure sine), `segment` (step in pt) and `passes` (how often each line is
drawn). Any theme can be made hand-drawn with it:

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt, font: "Patrick Hand")
    brainroot(width: 100%, title: [Forms of energy],
      theme: (base: "blocks", hand: (amplitude: 1, wavelength: 60, randomness: 2, segment: 1.5, passes: 1)),
      map)
  },
  source: ```typ
#set text(font: "Patrick Hand")
#brainroot(title: [Forms of energy],
  theme: (base: "blocks", hand: (amplitude: 1, wavelength: 60, randomness: 2, segment: 1.5, passes: 1)),
  map)
  ```,
  width: 100%,
)

== Adapting a theme

A dictionary overrides individual fields; `base` picks the starting theme,
otherwise `soft`. A theme carries everything about the look: boxes
(`shape`, `size`, `fill`, `stroke`, `radius`, `inset`, `underline`, `font`,
`scale`, `bold-depth`, `tint`, `tint-min`, `shade`), edges (`edge`,
`thickness`, `dash`, `taper`, `edge-label-fill`), `hand` for the wobble,
and `root` and `branches` with overrides for the root and the first level
only. `theme-defaults` lists every field with its default; a misspelt field
is an error, not a silent nothing.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Forms of energy], layout: "right",
      theme: (base: "outline", edge: "elbow", radius: 0pt), map)
  },
  source: ```typ
#brainroot(title: [Forms of energy], layout: "right",
  theme: (base: "outline", edge: "elbow", radius: 0pt), map)
  ```,
  width: 100%,
)

= The four levels

Everything that shapes a map sits on one of four levels, and each has its
place:

- *Theme* is the look of boxes and edges: shape, fill, border, font sizes
  per level, line widths, colour steps, the wobble. A name or a dictionary,
  fields in `theme-defaults`.
- *Palette* assigns the colours: of the branches, the root, the text. A
  name, an array of colours or a dictionary.
- *Layout* is the arrangement, `spacing` the distances: `level` and
  `root` along the direction of growth, `sibling` and `branch` across,
  `max-width` for wrapping, `brace`, `summary`, `cloud`, `label` (how far an
  edge label sits off its edge) and `padding`.
  Fields in `layout-defaults` and `spacing-defaults`.
- *Nodes* are `branch(...)`, the root included: icon, fill, ink,
  highlight, gap, edge label, `id`, brace, cloud, points.

What stays on `brainroot` itself are the knobs per map: `wobble`, `links`,
`blanks`, `solution`, `solution-ink`, `show-points`, `reveal`, `width`,
`zoom`, `background` and `alt`. `width` scales the finished map, text
included, to a width given as a length or as a share of the surrounding
block (`width: 100%`); `zoom` is a factor on top. Both change only the
size, never the layout.

Whatever is the same throughout a document becomes a preset:

#show-code[```typ
#let map = brainroot.with(theme: "hand", palette: "ocean", spacing: (level: 5em))
#map(title: [Forms of energy])[ ... ]
```]

= Accessibility and performance

The map is a figure with alternative text: `alt: auto` writes the tree out
as text, a string is used as given, `none` leaves it out. Tagged PDFs thus
carry the content of the map for screen readers too.

A map of about 200 nodes compiles in a little over half a second,
hand-drawn in about two; measuring the boxes and wobbling the lines are
the two costs. Very large maps do not get slow, then, but they get hard to
read, and that is the reason to split them.

= Functions

#show-module(read("../lib.typ") + "\n" + read("../src/input.typ"), name: "brainroot")

== Defaults

The fields of theme, palette, layout and spacing, with their defaults:

#show-module(read("../src/themes.typ") + "\n" + read("../src/palettes.typ") + "\n" + read("../src/options.typ"), name: "brainroot")
