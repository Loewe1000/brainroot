# Changelog

## [0.2.0] — unreleased

### Added

- **Icons and images in nodes.** `branch(..., icon: emoji.bolt)` and
  `brainroot(icon: ..., icon-at: "top")` set an icon, emoji or image beside
  or above the label. Formulas, images and links in labels are documented.
- **Node overrides.** `fill:` (a colour, or `none` for a ring), `ink:` and
  `mark: true` for a highlighted key term.
- **Blank maps with a solution.** `branch(..., blank: true)` or
  `brainroot(blanks: "leaves" | "branches" | "all")` draws gaps at full
  size; `solution: true` fills them in, `solution-ink` colours the answers.
- **Shapes.** Theme fields `shape: "rect" | "circle" | "ellipse"` and
  `size:` (a fixed diameter per depth) for bubble trees and circle maps;
  circle text wraps to keep the disc small.
- **Depth shading.** `shade: 20%` lightens each level towards the leaves,
  a negative value darkens.
- **Edge labels.** `branch(..., edge-label: [1/2])` puts a small label on
  the edge into the node, for decision and probability trees;
  `edge-label-fill` sets its background.
- **Background.** `background:` and `padding:` paint a colour behind the map.
- **Cross-links.** `branch(..., id: "a")` names a node, `brainroot(links:
  (connect("a", "b", label: [...]),))` draws a curve between two nodes over
  the map, with arrow, dash and bend.
- **Summary braces and clouds.** `branch(..., summary: [...])` puts a brace
  with a label beyond a node's children; `cloud: true` or a colour draws a
  soft cloud behind the subtree. Both in the tree layouts, not in `radial`
  and `star`.
- **Points.** `branch(..., points: 2)`, `show-points: true` for a badge on
  the box, `brainroot-points(...)` to add them up.
- **Building up.** `reveal: 3` draws the first three branches, a function
  of the branch index picks freely; the layout stays put, so a map can
  build up branch by branch, in typstage with `build(from => ...)`.
- **Two more themes.** `organic`: edges that thin out towards the leaves
  (`edge: "taper"`, `taper:` factors). `twigs`: circles on the first
  level, bare leaves on a shared spine with a twig each (`edge: "comb"`).
  Themes can override the first level with `branches:`.
- **Fishbone.** `layout: "fishbone"`: the root as the head of a spine,
  branches as ribs alternating above and below, leaves along the ribs.
- **Aligned levels.** `align-levels: true` puts every level on one line
  across all branches, as in an org chart.
- **Alternative text.** The map is a figure with `alt` text, written out
  from the tree by default, for tagged PDFs; `alt:` sets or declines it.


## [0.1.0] — 2026-09-05

First release: two-sided mind maps on CeTZ. Input as a Typst list or with
`branch(...)`, contour layout in both axes, layouts `both`, `right`, `left`,
`down`, `up`, `radial` and `star`, ten themes (four of them hand-drawn after the
TikZ decoration `sketch`, in pure Typst), ten palettes, automatic text
colour by fill luminance.
