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


## [0.1.0] — 2026-09-05

First release: two-sided mind maps on CeTZ. Input as a Typst list or with
`branch(...)`, contour layout in both axes, layouts `both`, `right`, `left`,
`down`, `up`, `radial` and `star`, ten themes (four of them hand-drawn after the
TikZ decoration `sketch`, in pure Typst), ten palettes, automatic text
colour by fill luminance.
