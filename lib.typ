// brainroot -- two-sided mind maps with coloured branches.
//
// The root sits in the middle, the branches spread to the right and left,
// and every branch carries its own colour down to its leaves. The layout is
// a simple "tidy tree": every subtree gets as much room as its children
// need and is centred on its parent.

#import "@preview/cetz:0.4.2"

/// A branch of the mind map. Children may be further `branch(...)` calls or
/// plain content, which then counts as a leaf without children of its own.
///
/// -> dictionary
#let branch(
  /// Label of the node.
  /// -> content | str
  label,
  /// Children: `branch(...)` calls or content (leaves).
  /// -> content | dictionary
  ..kids,
  /// Colour of the branch. Only read on the first level; below it every node
  /// inherits the colour of its parent. `none` takes the next colour from
  /// the palette.
  /// -> color | none
  color: none,
  /// `left` or `right` forces the side in the two-sided layout; `auto` lets
  /// brainroot balance. Only read on the first level.
  /// -> alignment | auto
  side: auto,
  /// An icon, emoji or image set beside the label.
  /// -> content | none
  icon: none,
  /// Where the icon goes: `"left"` of the label or `"top"`, above it.
  /// -> str
  icon-at: "left",
  /// Fill of this node's box; `auto` follows the theme, `none` leaves the
  /// box unfilled with a border in the branch colour (a ring).
  /// -> auto | color | none
  fill: auto,
  /// Text colour of this node; `auto` follows the fill.
  /// -> auto | color
  ink: auto,
  /// Highlights the node: bold text and a strong border in the branch
  /// colour, for key terms.
  /// -> bool
  mark: false,
  /// Draws the box empty, at its full size, unless the map is set with
  /// `solution: true` -- a gap to fill in.
  /// -> bool
  blank: false,
  /// A small label on the edge that leads to this node, for decision trees
  /// and probability trees.
  /// -> content | none
  edge-label: none,
  /// A name for `connect(...)` to address this node by. The root is `"root"`.
  /// -> str | none
  id: none,
  /// A brace beyond this node's children with a label, summarising them.
  /// Not drawn in the `radial` and `star` layouts.
  /// -> content | none
  summary: none,
  /// A soft cloud behind this node's whole subtree: `true` for a light
  /// tint of the branch colour, or a colour. Not drawn in the `radial` and
  /// `star` layouts.
  /// -> bool | color | none
  cloud: none,
) = (
  brainroot-node: true,
  label: label,
  kids: kids.pos(),
  color: color,
  side: side,
  icon: icon,
  icon-at: icon-at,
  fill: fill,
  ink: ink,
  mark: mark,
  blank: blank,
  edge-label: edge-label,
  id: id,
  summary: summary,
  cloud: cloud,
)

/// A connection between two nodes that are not parent and child, drawn over
/// the map as a curve: a cross-link. Give the nodes an `id` and pass the
/// connections to `brainroot(links: (...))`.
///
/// -> dictionary
#let connect(
  /// `id` of the node the curve starts at; `"root"` is the root.
  /// -> str
  from,
  /// `id` of the node the curve ends at.
  /// -> str
  to,
  /// A label at the middle of the curve.
  /// -> content | none
  label: none,
  /// An arrowhead at the end; `"both"` puts one at each end.
  /// -> bool | str
  arrow: true,
  /// Dash pattern of the curve.
  /// -> str
  dash: "dashed",
  /// How far the curve bows out, as a share of the distance; `0%` is a
  /// straight line, negative bends the other way.
  /// -> ratio
  bend: 30%,
  /// Colour of the curve; `auto` is a dark grey.
  /// -> color | auto
  color: auto,
  /// Line width.
  /// -> length
  thickness: 0.09em,
) = (
  brainroot-link: true,
  from: from, to: to, label: label, arrow: arrow, dash: dash,
  bend: bend, color: color, thickness: thickness,
)

// Anything that is not a branch becomes a leaf.
#let _norm(k) = if type(k) == dictionary and k.at("brainroot-node", default: false) { k } else { branch(k) }

// --- Lists as input --------------------------------------------------------
//
// In markup a list is a sequence of `list.item` elements; only when laid
// out do they become a `list`. Both forms are understood here.

#let _is-item(c) = type(c) == content and c.func() in (list.item, enum.item)
#let _is-list(c) = type(c) == content and c.func() in (list, enum)
#let _is-blank(c) = type(c) == content and c.func() in (parbreak, [ ].func())

// Splits the body of a list item into label and nested items: whatever is
// not a list item stays label; every nested item becomes a child.
#let _from-item(item) = {
  let body = item.body
  let parts = if body.func() == [].func() { body.children } else { (body,) }
  let label = ()
  let kids = ()
  for p in parts {
    if _is-item(p) {
      kids.push(_from-item(p))
    } else if _is-list(p) {
      kids += p.children.map(_from-item)
    } else if kids.len() == 0 {
      label.push(p)
    }
  }
  // Whitespace at the edges of the label only gets in the way.
  while label.len() > 0 and _is-blank(label.first()) { label = label.slice(1) }
  while label.len() > 0 and _is-blank(label.last()) { label = label.slice(0, -1) }
  branch(label.join(), ..kids)
}

// If the argument is a list or a sequence of list items, yields its items
// as branches; otherwise the argument itself as a single branch.
#let _expand(arg) = {
  if _is-list(arg) {
    arg.children.map(_from-item)
  } else if _is-item(arg) {
    (_from-item(arg),)
  } else if type(arg) == content and arg.func() == [].func() and arg.children.any(_is-item) and arg.children.all(c => _is-item(c) or _is-list(c) or _is-blank(c)) {
    arg.children.filter(c => not _is-blank(c)).map(_expand).flatten()
  } else {
    (arg,)
  }
}

// --- Palettes --------------------------------------------------------------
//
// Every palette: eight branch colours, handed out in order, and a colour for
// the root. Boxes get the branch colour lightened by `tint`.

/// The built-in palettes: `poster`, `pastel`, `grayscale`, `mono`, `plain`,
/// `earth`, `ocean`, `sunset`, `forest`, `neon`. Each is a dictionary with
/// `colors` (an array, handed out to the branches in order) and `root`.
/// Take one as the starting point for your own.
///
/// -> dictionary
#let palettes = (
  // Bright and bold, like markers on a whiteboard.
  poster: (colors: (rgb("#e8321e"), rgb("#f5a623"), rgb("#f2c230"), rgb("#3fc728"),
                    rgb("#1fc2ee"), rgb("#9b3fd6"), rgb("#f78fc0"), rgb("#2a7de1")),
           root: rgb("#7f9bff")),
  // Soft pastel, muted tones.
  pastel: (colors: (rgb("#e28f8f"), rgb("#e9b97a"), rgb("#d6cf7a"), rgb("#8fc79a"),
                    rgb("#7fb8d4"), rgb("#a99adb"), rgb("#d9a0c8"), rgb("#8fbfb5")),
           root: rgb("#9aa6d6")),
  // Greys only: steps from dark to medium.
  grayscale: (colors: (rgb("#222222"), rgb("#555555"), rgb("#333333"), rgb("#777777"),
                       rgb("#444444"), rgb("#888888"), rgb("#2b2b2b"), rgb("#666666")),
              root: rgb("#111111")),
  // One hue, blue, in varying lightness.
  mono: (colors: (rgb("#0b3d91"), rgb("#2a62c2"), rgb("#1749a8"), rgb("#4d80d6"),
                  rgb("#0f2f6e"), rgb("#6e9be0"), rgb("#1f56b5"), rgb("#3a70cc")),
         root: rgb("#082a66")),
  // Plain: one dark ink for everything, as if drawn with a fountain pen.
  plain: (colors: (rgb("#1a1a1a"),), root: rgb("#1a1a1a")),
  // Earth tones: terracotta, ochre, olive, sand.
  earth: (colors: (rgb("#b5532a"), rgb("#c98b2e"), rgb("#7a7a2f"), rgb("#8c5a3c"),
                   rgb("#a3762b"), rgb("#5d6b3a"), rgb("#c47a54"), rgb("#6b4e35")),
          root: rgb("#4e3a2a")),
  // Sea: turquoise, teal, sea green.
  ocean: (colors: (rgb("#0c7c8c"), rgb("#1ea8b5"), rgb("#155e75"), rgb("#2bb39a"),
                   rgb("#0e4d64"), rgb("#4cc3d2"), rgb("#1b8a7d"), rgb("#3b6fa0")),
          root: rgb("#0b3a4a")),
  // Evening sky: red, orange, pink, violet.
  sunset: (colors: (rgb("#c72c41"), rgb("#ee6f3b"), rgb("#f2a541"), rgb("#d9436b"),
                    rgb("#8e3b8f"), rgb("#f07f6f"), rgb("#b02a5c"), rgb("#e88d3a")),
           root: rgb("#5b1f4a")),
  // Forest: green with a little brown.
  forest: (colors: (rgb("#2d6a4f"), rgb("#40916c"), rgb("#1b4332"), rgb("#74a57f"),
                    rgb("#6b8e23"), rgb("#8a6e3a"), rgb("#52b788"), rgb("#3e5c3a")),
           root: rgb("#1b4332")),
  // Neon: loud, saturated colours.
  neon: (colors: (rgb("#ff2079"), rgb("#00e5ff"), rgb("#aaff00"), rgb("#ffe600"),
                  rgb("#ff6a00"), rgb("#b026ff"), rgb("#00ff9c"), rgb("#ff3cac")),
         root: rgb("#1a1a2e")),
)

#let _palette(p) = {
  if type(p) == str {
    assert(p in palettes, message: "brainroot: unknown palette \"" + p + "\", expected one of " + palettes.keys().join(", "))
    palettes.at(p)
  } else if type(p) == array {
    (colors: p, root: rgb("#7f9bff"))
  } else if type(p) == dictionary {
    (colors: palettes.poster.colors, root: rgb("#7f9bff")) + p
  } else {
    panic("brainroot: palette must be a name, an array of colours or a dictionary (colors, root)")
  }
}

// --- Themes ----------------------------------------------------------------
//
// A theme decides how boxes and edges look; the colours still come from
// the palette. Fields:
//   edge      "curve" | "elbow" | "straight"   routing of the edges
//   fill      "tint" | "solid" | "white" | "none"   fill of the boxes
//   stroke    border width of the boxes (0pt = no border)
//   radius    corner radius (may be relative, 50% = pill)
//   underline true: no box, the text sits on a coloured line and the edges
//             flow into that line
//   dash      dash pattern of the edges ("solid", "dashed", "dotted")
//   font      font of the labels; `none` inherits from the document
//   hand      `none`, or a dictionary for hand-drawn lines:
//               amplitude   excursion of the wobble in pt
//               wavelength  length of one wave in pt
//               randomness  irregularity of the rhythm (1 = pure sine)
//               segment     step along the path in pt
//               passes      how often each line is drawn (2 = "scribbled")
//   shape     "rect" | "circle" | "ellipse"   shape of the boxes
//   size      `none`, or an array of lengths per depth: a fixed diameter
//             (width for ellipses) instead of a size fitted to the text
//   root      overrides for the root only (fill, stroke, radius, shape, size)

/// The built-in themes: `soft`, `outline`, `blocks`, `lines`, `sketch`,
/// `bubbles`, `hand`, `scribble`, `marker`, `pencil`. Each is a dictionary
/// with `edge`, `fill`, `stroke`, `radius`, `underline`, `dash`, `root` and,
/// for the hand-drawn ones, `hand`; see the theme chapter for the fields.
///
/// -> dictionary
#let themes = (
  // Pastel boxes, soft S-curves -- the whiteboard original.
  soft: (edge: "curve", fill: "tint", stroke: 0pt, radius: 8pt, underline: false, dash: "solid",
         root: (fill: "solid")),
  // White boxes with a coloured border, curves.
  outline: (edge: "curve", fill: "white", stroke: 1pt, radius: 6pt, underline: false, dash: "solid",
            root: (fill: "solid", stroke: 0pt)),
  // Solid colour, white text, right angles: org-chart look.
  blocks: (edge: "elbow", fill: "solid", stroke: 0pt, radius: 0pt, underline: false, dash: "solid",
           root: (:)),
  // No boxes: the text sits on its line, the classic mind map.
  lines: (edge: "curve", fill: "none", stroke: 0pt, radius: 0pt, underline: true, dash: "solid",
          root: (fill: "solid", radius: 6pt)),
  // Sketch: dashed straight lines, thin border, no fill.
  sketch: (edge: "straight", fill: "none", stroke: 0.8pt, radius: 3pt, underline: false, dash: "dashed",
           root: (fill: "white", stroke: 1.5pt)),
  // Pills and straight connections.
  bubbles: (edge: "straight", fill: "tint", stroke: 1pt, radius: 50%, underline: false, dash: "solid",
            root: (fill: "solid")),
  // Hand-drawn: like `soft`, but every line wobbles slightly.
  hand: (edge: "curve", fill: "tint", stroke: 1pt, radius: 8pt, underline: false, dash: "solid",
         hand: (amplitude: 0.6, wavelength: 80, randomness: 2, segment: 1.5, passes: 1),
         root: (fill: "solid")),
  // Scribbled: no fill, every line drawn twice.
  scribble: (edge: "curve", fill: "none", stroke: 0.7pt, radius: 6pt, underline: false, dash: "solid",
             hand: (amplitude: 0.9, wavelength: 50, randomness: 2.5, segment: 1.5, passes: 2),
             root: (fill: "white", stroke: 1pt)),
  // Felt-tip: solid colour, wide straight strokes with a long wobble.
  marker: (edge: "straight", fill: "solid", stroke: 0pt, radius: 4pt, underline: false, dash: "solid",
           hand: (amplitude: 1.2, wavelength: 120, randomness: 2, segment: 2, passes: 1),
           root: (:)),
  // Pencil: thin lines with a fine tremor, right angles.
  pencil: (edge: "elbow", fill: "white", stroke: 0.6pt, radius: 2pt, underline: false, dash: "solid",
           hand: (amplitude: 0.35, wavelength: 30, randomness: 3, segment: 1, passes: 1),
           root: (stroke: 1pt)),
)

#let _theme-defaults = (font: none, hand: none, shape: "rect", size: none)

#let _theme(t) = {
  if type(t) == str {
    assert(t in themes, message: "brainroot: unknown theme \"" + t + "\", expected one of " + themes.keys().join(", "))
    _theme-defaults + themes.at(t)
  } else if type(t) == dictionary {
    // A dictionary overrides individual fields of `soft`; `hand` and
    // `root` are merged field by field.
    let base = _theme-defaults + themes.at(t.at("base", default: "soft"))
    let hand = if type(t.at("hand", default: none)) == dictionary {
      (if base.hand == none { (:) } else { base.hand }) + t.hand
    } else { t.at("hand", default: base.hand) }
    base + t + (root: base.root + t.at("root", default: (:)), hand: hand)
  } else {
    panic("brainroot: theme must be a string or a dictionary")
  }
}

// --- Drawing a single node -------------------------------------------------

// Perceived luminance of a colour, 0 dark to 1 light.
#let _luma(c) = {
  let (r, g, b, ..) = rgb(c).components().map(v => v / 100%)
  0.299 * r + 0.587 * g + 0.114 * b
}

// Fill of a box after the theme field `fill`. Tinted fills are lightened
// by `tint` and then further until they are at least `tint-min` light:
// otherwise an almost black ink only yields a medium grey on which text
// reads poorly.
#let _fill(mode, color, opts) = {
  if mode == "solid" { color }
  else if mode == "white" { white }
  else if mode == "tint" {
    let f = color.lighten(opts.tint)
    let n = 0
    while _luma(f) < opts.tint-min and n < 4 { f = f.lighten(30%); n += 1 }
    f
  } else { none }
}

// Text colour for a fill: `ink` applies when set; with `auto` the luminance
// of the fill decides whether dark or light text reads better. Without a
// fill it is the dark one.
#let _ink(fill, opts) = {
  if opts.ink != auto { opts.ink }
  else if fill == none { opts.ink-dark }
  else if _luma(fill) < opts.ink-threshold { opts.ink-light }
  else { opts.ink-dark }
}

// The words of a label, provided it consists of text only; otherwise
// `none`. Needed to know the width of the longest word: a box must not
// shrink below it, or the word sticks out.
#let _words(c) = {
  if type(c) == str { return c.split() }
  if type(c) != content { return none }
  if c.func() == text { return c.text.split() }
  if c.func() == [ ].func() { return () }
  if c.func() == [].func() {
    let out = ()
    for p in c.children {
      let w = _words(p)
      if w == none { return none }
      out += w
    }
    return out
  }
  if c.has("body") { return _words(c.body) }
  none
}

// Everything the theme and the node decide about a box: fill, border,
// radius, shape, fixed size, text colour and weight. Shared by the box
// itself and by the hand-drawn outline, so both agree.
#let _paint(node, depth, color, opts) = {
  let th = opts.theme
  let root = depth == 0
  let spec = if root { th + th.root } else { th }
  let color = if root { opts.root-fill } else { color }
  let fill = if node.fill == auto { _fill(spec.fill, color, opts) } else { node.fill }
  let stroke = if spec.underline and not root { none }
    else if spec.stroke == 0pt { none } else { spec.stroke + color }
  // A ring: no fill asks for a visible border.
  if node.fill == none and stroke == none { stroke = calc.max(spec.stroke, 0.08em) + color }
  if node.mark { stroke = 0.15em + color.darken(35%) }
  let ink = if node.ink != auto { node.ink } else { _ink(fill, opts) }
  let weight = if depth < opts.bold-depth or node.mark { "bold" } else { "regular" }
  let size = if spec.size == none { none } else { spec.size.at(calc.min(depth, spec.size.len() - 1)) }
  (
    fill: fill, stroke: stroke, ink: ink, weight: weight,
    shape: spec.shape, size: size,
    radius: if spec.underline and not root { 0pt } else { spec.radius },
  )
}

// Is this node a gap to fill in? Its own `blank`, or the map-wide rule.
#let _is-blank(node, depth, opts) = {
  (node.blank
    or (opts.blanks == "all" and depth > 0)
    or (opts.blanks == "leaves" and depth > 0 and node.kids.len() == 0)
    or (opts.blanks == "branches" and depth == 1))
}

#let _nodebox(node, depth, color, opts, width: auto) = {
  let th = opts.theme
  let p = _paint(node, depth, color, opts)
  let scale = opts.scale.at(calc.min(depth, opts.scale.len() - 1))
  // Hand-drawn: the box itself stays invisible, `_hand-shape` draws its
  // outline as a wobbly path underneath. Size and padding stay the same so
  // the layout holds.
  let drawn = th.hand == none
  let blank = _is-blank(node, depth, opts)
  let ink = if blank and opts.solution and opts.solution-ink != auto { opts.solution-ink } else { p.ink }
  let label = text(weight: p.weight, size: 1em * scale, fill: ink, node.label)
  let label = if th.font != none { text(font: th.font, label) } else { label }
  // A gap keeps its size: `hide` measures like the text it hides.
  let label = if blank and not opts.solution { hide(label) } else { label }
  let body = if node.icon == none { label }
    else if node.icon-at == "top" { align(center, stack(dir: ttb, spacing: 0.3em, node.icon, label)) }
    else { box(node.icon) + h(0.35em) + label }
  let fill = if drawn { p.fill } else { none }
  let stroke = if drawn { p.stroke } else { none }
  if p.shape == "rect" {
    box(width: width, fill: fill, stroke: stroke, radius: p.radius, inset: opts.inset, body)
  } else if p.size != none {
    // Fixed diameter: the text wraps inside and is centred. If it does not
    // fit, the font shrinks step by step to 60%; if that is still not
    // enough, the shape grows rather than letting the text spill out.
    let d = p.size
    let words = _words(node.label)
    context {
      let d = d.to-absolute()
      let inner-w = if p.shape == "circle" { d * 0.72 } else { d * 0.8 }
      let inner-h = if p.shape == "circle" { d * 0.72 } else { d * 0.62 * 0.8 }
      let s = 1.0
      let fits(s) = {
        let m = measure(box(width: inner-w, align(center, text(size: s * 1em, body))))
        let widest = if words == none { 0pt } else {
          words.map(w => measure(text(weight: p.weight, size: s * 1em * scale, w)).width).fold(0pt, calc.max)
        }
        m.height <= inner-h and widest <= inner-w
      }
      while s > 0.6 and not fits(s) { s -= 0.1 }
      let m = measure(box(width: inner-w, align(center, text(size: s * 1em, body))))
      let grow = calc.max(1.0, m.height / inner-h)
      let inner = box(width: inner-w, align(center, text(size: s * 1em, body)))
      if p.shape == "circle" { circle(radius: d * grow / 2, fill: fill, stroke: stroke, inset: 0pt, align(center + horizon, inner)) }
      else { ellipse(width: d * grow, height: d * 0.62 * grow, fill: fill, stroke: stroke, inset: 0pt, align(center + horizon, inner)) }
    }
  } else {
    let inner = align(center + horizon, box(width: width, align(center, body)))
    if p.shape == "circle" { circle(fill: fill, stroke: stroke, inset: opts.inset, inner) }
    else { ellipse(fill: fill, stroke: stroke, inset: opts.inset, inner) }
  }
}

// CeTZ measures `content` with its own text edges (cap-height, baseline)
// and therefore places the box a few points too high. A block with the
// fixed size measured here takes that decision away from CeTZ: it is
// centred exactly where the edges and the hand-drawn shape expect it.
#let _framed(t, body) = block(width: t.w, height: t.h, body)

// --- Hand-drawn lines ------------------------------------------------------
//
// After the TikZ decoration `sketch` (tex.stackexchange.com/a/445690): a
// path is walked in steps of `segment` pt, every point is offset
// perpendicular to the path by `amplitude * sin(2πt/wavelength)`, where t
// performs a random walk with step `randomness^rand`. `rand` comes from the
// PGF generator (Park-Miller with Schrage's trick), so the same seed gives
// the same wobble as in LaTeX. All computed in Typst: a mind map has only a
// few dozen short paths, which needs no plugin.

#let _rng-next(z) = {
  let t = 69621 * calc.rem(z, 30845) - 23902 * calc.quo(z, 30845)
  if t < 0 { t + 2147483647 } else { t }
}
#let _rng-seed(seed) = {
  let z = calc.rem(seed, 2147483647)
  if z <= 0 { z + 2147483646 } else { z }
}
// Uniform on [-1, 1], quantised to five decimals as in TeX.
#let _rng-rand(z) = (calc.rem(z, 200001) - 100000) / 100000

// Wobbles a polyline (points as (x, y) in pt, plain numbers). Returns the
// new points. `closed` closes at the start point.
#let _wobble(pts, hand, seed, closed: false) = {
  let pts = if closed { pts + (pts.first(),) } else { pts }
  let total = range(1, pts.len()).map(i => {
    let (ax, ay) = pts.at(i - 1)
    let (bx, by) = pts.at(i)
    calc.sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
  }).sum(default: 0.0)
  let z = _rng-seed(seed)
  let t = 0.0
  let out = (pts.first(),)
  let carry = 0.0     // leftover step from the previous segment
  let done = 0.0      // length walked so far
  let off = 0.0
  for i in range(1, pts.len()) {
    let (ax, ay) = pts.at(i - 1)
    let (bx, by) = pts.at(i)
    let (dx, dy) = (bx - ax, by - ay)
    let len = calc.sqrt(dx * dx + dy * dy)
    if len < 1e-9 { continue }
    let (tx, ty) = (dx / len, dy / len)
    let (nx, ny) = (-ty, tx)
    let d = carry
    while d <= len {
      z = _rng-next(z)
      t = calc.rem(t + calc.pow(hand.randomness, _rng-rand(z)), hand.wavelength)
      off = calc.sin(2 * calc.pi * t / hand.wavelength * 1rad) * hand.amplitude
      // Closed paths: the offset fades out before closing, otherwise a notch
      // remains at the start point.
      if closed { off *= calc.min(1, (total - done - d) / (4 * hand.segment)) }
      out.push((ax + tx * d + nx * off, ay + ty * d + ny * off))
      d += hand.segment
    }
    carry = d - len
    done += len
  }
  if closed { out.push(pts.first()) } else {
    let (ax, ay) = pts.at(pts.len() - 2)
    let (bx, by) = pts.last()
    let (dx, dy) = (bx - ax, by - ay)
    let len = calc.max(calc.sqrt(dx * dx + dy * dy), 1e-9)
    out.push((bx - dy / len * off, by + dx / len * off))
  }
  out
}

// A seed from coordinates, so every line wobbles differently while the
// result stays reproducible.
#let _seed(..xs) = {
  let h = 7
  for x in xs.pos() { h = calc.rem(h * 31 + int(calc.round(calc.abs(x) * 10)), 1000003) }
  h + 1
}

#let _pt(l) = if type(l) == length { l.pt() } else { float(l) }

// Cubic Bézier curve as a polyline.
#let _flatten-bezier(p0, c0, c1, p1, n: 24) = range(n + 1).map(i => {
  let t = i / n
  let u = 1 - t
  let (a, b, c, d) = (u * u * u, 3 * u * u * t, 3 * u * t * t, t * t * t)
  (a * p0.at(0) + b * c0.at(0) + c * c1.at(0) + d * p1.at(0),
   a * p0.at(1) + b * c0.at(1) + c * c1.at(1) + d * p1.at(1))
})

// Rounded rectangle around (cx, cy) as a polyline.
#let _rounded-rect(cx, cy, w, h, r, n: 6) = {
  let r = calc.min(r, w / 2, h / 2)
  if r <= 0.01 {
    return ((cx - w / 2, cy - h / 2), (cx + w / 2, cy - h / 2), (cx + w / 2, cy + h / 2), (cx - w / 2, cy + h / 2))
  }
  let corner(x, y, a0) = range(n + 1).map(i => {
    let a = a0 + 90deg * i / n
    (x + r * calc.cos(a), y + r * calc.sin(a))
  })
  let out = corner(cx + w / 2 - r, cy - h / 2 + r, -90deg)
  out += corner(cx + w / 2 - r, cy + h / 2 - r, 0deg)
  out += corner(cx - w / 2 + r, cy + h / 2 - r, 90deg)
  out += corner(cx - w / 2 + r, cy - h / 2 + r, 180deg)
  out
}

// Draws a polyline (numbers in pt) hand-drawn, in `passes` layers.
#let _hand-line(pts, st, hand, seed, closed: false, fill: none) = {
  import cetz.draw: line
  for p in range(hand.passes) {
    let q = _wobble(pts, hand, seed + 977 * p, closed: closed)
    line(..q, close: closed, stroke: st, fill: if p == 0 { fill } else { none })
  }
}

// The outline of a node as a wobbly path, at (cx, cy) given as lengths.
// Ellipse around (cx, cy) as a polyline.
#let _ellipse-pts(cx, cy, rx, ry, n: 48) = range(n).map(i => {
  let a = 360deg * i / n
  (cx + rx * calc.cos(a), cy + ry * calc.sin(a))
})

#let _hand-shape(cx, cy, t, depth, color, opts) = {
  let paint = _paint(t.node, depth, color, opts)
  let (w, h) = (_pt(t.w), _pt(t.h))
  let r = if type(paint.radius) == ratio { calc.min(w, h) * paint.radius / 100% } else { _pt(paint.radius) }
  let pts = if paint.shape == "rect" { _rounded-rect(_pt(cx), _pt(cy), w, h, r) }
    else { _ellipse-pts(_pt(cx), _pt(cy), w / 2, h / 2) }
  let st = if paint.stroke == none { none } else { paint.stroke }
  if st == none and paint.fill == none { return }
  _hand-line(pts, st, opts.theme.hand, _seed(_pt(cx), _pt(cy), w, h), closed: true, fill: paint.fill)
}

// Measures a node. If the label is wider than `max-width` it wraps; a
// bisection then finds the smallest width at which the wrapping does not
// grow further, so the box is no wider than its longest line. The lower
// bound is the longest word; if it cannot be determined the box stays at
// `max-width`. If even the longest word is wider than `max-width`, the
// natural width stays: a cut-off word would be worse than a wide box.
// Must be called inside `context`.
#let _measure-node(node, depth, color, opts) = {
  let th = opts.theme
  let spec = if depth == 0 { th + th.root } else { th }
  let natural = measure(_nodebox(node, depth, color, opts))
  let words = _words(node.label)
  let floor = if words == none { none } else {
    words.map(w => measure(_nodebox(branch(w), depth, color, opts)).width).fold(0pt, calc.max)
  }
  // Circles and ellipses grow with the diagonal of the text, so a long
  // single line makes a huge disc. Try a few narrower wraps and keep the
  // one that gives the smallest shape.
  if spec.shape != "rect" and spec.size == none and floor != none {
    let best = (w: natural.width, h: natural.height, width: auto)
    for f in (0.8, 0.65, 0.5, 0.4, 0.3) {
      let cand = natural.width * f
      if cand < floor { break }
      let m = measure(_nodebox(node, depth, color, opts, width: cand))
      if m.width < best.w { best = (w: m.width, h: m.height, width: cand) }
    }
    return best
  }
  if opts.max-width == none or natural.width <= opts.max-width {
    return (w: natural.width, h: natural.height, width: auto)
  }
  let floor = if floor == none { opts.max-width } else { floor }
  if floor > opts.max-width {
    return (w: natural.width, h: natural.height, width: auto)
  }
  let wrapped = measure(_nodebox(node, depth, color, opts, width: opts.max-width))
  let lo = floor
  let hi = opts.max-width
  for _ in range(7) {
    let mid = (lo + hi) / 2
    let m = measure(_nodebox(node, depth, color, opts, width: mid))
    if m.height <= wrapped.height { hi = mid } else { lo = mid }
  }
  // Measure the box once more at the chosen width: for a shaped node the
  // outer size is not the inner width.
  let m = measure(_nodebox(node, depth, color, opts, width: hi))
  (w: m.width, h: m.height, width: hi)
}

// --- Layout ----------------------------------------------------------------
//
// All layouts work in two axes: the main axis m, along which the tree
// grows, and the cross axis u, along which siblings stand side by side.
// Horizontal layouts (both, right, left, radial) have m = x and u pointing
// down; vertical ones (down, up) have m = y and u = x pointing right.
// `dir` is the sign of the direction of growth on m.

// Size of a box on the two axes.
#let _sizes(m, vertical) = if vertical { (m: m.h, u: m.w) } else { (m: m.w, u: m.h) }

// Annotates a subtree with sizes and places its children. Result:
//   w, h, width   size of the node's own box
//   size-m/-u     the same on the axes
//   kids          the children, each with `du`: offset on u from the centre
//   contour       per depth below this node (lo, hi): how far the subtree
//                 reaches on u before and behind the centre on that level
//                 (lo negative)
//   lo, hi        the same over all levels; size = hi - lo
//   extent        extent of the subtree on m, from its own box on
//
// Siblings are not stacked as blocks but by contour: the next child moves
// up as far as it collides with the previous one on no level. So a leaf
// without children stays close to its neighbour, even if that one has a
// deep subtree.
#let _measure-tree(node, depth, base, opts, vertical) = {
  // `shade` steps the branch colour per level: positive lightens towards
  // the leaves, negative darkens.
  let color = if opts.shade == 0% or depth <= 1 { base }
    else if opts.shade > 0% { base.lighten(opts.shade * (depth - 1)) }
    else { base.darken(-opts.shade * (depth - 1)) }
  let m = _measure-node(node, depth, color, opts)
  let sz = _sizes(m, vertical)
  let kids = node.kids.map(k => _measure-tree(_norm(k), depth + 1, base, opts, vertical))

  let placed = ()
  let merged = ()   // contour of the children placed so far, absolute on u
  for k in kids {
    let u = 0pt
    if placed.len() > 0 {
      u = -1e9 * 1pt
      let d = 0
      while d < merged.len() and d < k.contour.len() {
        let limit = merged.at(d).hi + opts.sibling-gap - k.contour.at(d).lo
        if limit > u { u = limit }
        d += 1
      }
    }
    placed.push(k + (du: u))
    let d = 0
    while d < k.contour.len() {
      let c = (lo: u + k.contour.at(d).lo, hi: u + k.contour.at(d).hi)
      if d < merged.len() {
        merged.at(d) = (lo: calc.min(merged.at(d).lo, c.lo), hi: calc.max(merged.at(d).hi, c.hi))
      } else {
        merged.push(c)
      }
      d += 1
    }
  }

  // Parent centred between first and last child.
  let shift = if placed.len() > 0 { (placed.first().du + placed.last().du) / 2 } else { 0pt }
  placed = placed.map(k => k + (du: k.du - shift))
  merged = merged.map(c => (lo: c.lo - shift, hi: c.hi - shift))

  let contour = ((lo: -sz.u / 2, hi: sz.u / 2),) + merged
  let extent = sz.m + if kids.len() > 0 { opts.level-gap + kids.map(k => k.extent).fold(0pt, calc.max) } else { 0pt }
  // A summary brace sits beyond the children and needs its own room along
  // m: gap, brace, gap, label.
  let summary = none
  if node.summary != none and kids.len() > 0 {
    let lm = measure(text(size: 0.9em, node.summary))
    summary = (w: lm.width, h: lm.height)
    extent += opts.summary-gap * 2 + opts.brace-size + if vertical { lm.height } else { lm.width }
  }
  // A cloud pads the subtree on every side.
  let pad = if node.cloud != none { opts.cloud-pad } else { 0pt }
  let contour = contour.map(c => (lo: c.lo - pad, hi: c.hi + pad))
  let extent = extent + pad
  let lo = contour.map(c => c.lo).fold(0pt, calc.min)
  let hi = contour.map(c => c.hi).fold(0pt, calc.max)
  (
    node: node, depth: depth, color: color, kids: placed,
    w: m.w, h: m.h, width: m.width, size-m: sz.m, size-u: sz.u,
    contour: contour, lo: lo, hi: hi, size: hi - lo, extent: extent,
    summary: summary, pad: pad,
  )
}

// Distributes the first-level branches to right and left. Explicitly set
// sides stay; the others fill the right side first until it holds at least
// half the total height, the rest goes left. The order (top to bottom) is
// kept on both sides.
#let _split(trees, gap, layout) = {
  if layout == "right" { return (right: trees, left: ()) }
  if layout == "left" { return (right: (), left: trees) }
  let total = trees.map(t => t.size).sum(default: 0pt) + gap * calc.max(trees.len() - 1, 0)
  let right = ()
  let left = ()
  let right-h = 0pt
  let fixed-right = trees.filter(t => t.node.side == right).map(t => t.size).sum(default: 0pt)
  for t in trees {
    if t.node.side == right {
      right.push(t)
    } else if t.node.side == left {
      left.push(t)
    } else if right-h + fixed-right + t.size / 2 <= total / 2 {
      right.push(t)
      right-h += t.size + gap
    } else {
      left.push(t)
    }
  }
  (right: right, left: left)
}

// --- Drawing ---------------------------------------------------------------

#let _stroke(depth, color, opts) = (
  paint: color,
  thickness: opts.thickness.at(calc.min(depth, opts.thickness.len() - 1)),
  cap: "round",
  join: "round",
  dash: opts.theme.dash,
)

// From axis coordinates (m, u) to (x, y).
#let _xy(m, u, vertical) = if vertical { (u, m) } else { (m, -u) }

// Draws the edge with the control points in the theme's routing; hand-drawn
// it is first flattened to a polyline and then wobbled.
#let _path(p0, c0, c1, p1, st, opts) = {
  import cetz.draw: bezier, line
  let hand = opts.theme.hand
  if hand == none {
    if opts.theme.edge == "curve" {
      bezier(p0, p1, c0, c1, stroke: st)
    } else if opts.theme.edge == "elbow" {
      line(p0, c0, c1, p1, stroke: st)
    } else {
      line(p0, p1, stroke: st)
    }
  } else {
    let n(p) = (_pt(p.at(0)), _pt(p.at(1)))
    let pts = if opts.theme.edge == "curve" {
      _flatten-bezier(n(p0), n(c0), n(c1), n(p1))
    } else if opts.theme.edge == "elbow" {
      (n(p0), n(c0), n(c1), n(p1))
    } else {
      (n(p0), n(p1))
    }
    _hand-line(pts, st, hand, _seed(..n(p0), ..n(p1)))
  }
}

// An edge from p0 to p1 in the theme's routing; the curve runs parallel to
// the main axis at both ends.
// (`st` instead of `stroke`: cetz.draw exports a function of that name.)
#let _controls(p0, p1, vertical) = {
  let (x0, y0) = p0
  let (x1, y1) = p1
  if vertical {
    let mid = (y0 + y1) / 2
    ((x0, mid), (x1, mid))
  } else {
    let mid = (x0 + x1) / 2
    ((mid, y0), (mid, y1))
  }
}

#let _edge(p0, p1, st, opts, vertical) = {
  let (c0, c1) = _controls(p0, p1, vertical)
  _path(p0, c0, c1, p1, st, opts)
}

// The middle of an edge: the Bézier point at t = 1/2. For an elbow it lands
// on the vertical segment, for a straight line at the midpoint.
#let _mid(p0, c0, c1, p1) = (
  0.125 * p0.at(0) + 0.375 * c0.at(0) + 0.375 * c1.at(0) + 0.125 * p1.at(0),
  0.125 * p0.at(1) + 0.375 * c0.at(1) + 0.375 * c1.at(1) + 0.125 * p1.at(1),
)

// A small label sitting on an edge.
#let _edge-label(at, label, opts) = {
  import cetz.draw: content
  if label == none { return }
  // Edges "bounds": a fraction reaches above and below the line's usual
  // cap height and baseline, and the box has to cover all of it.
  content(at, box(fill: opts.edge-label-fill, inset: 0.25em, radius: 0.2em,
    text(size: 0.85em, fill: opts.ink-dark, top-edge: "bounds", bottom-edge: "bounds", label)))
}

// Draws one node's box centred at (cx, cy), with its underline if the theme
// has one.
#let _draw-node(t, cx, cy, opts) = {
  import cetz.draw: *
  if opts.theme.hand != none { _hand-shape(cx, cy, t, t.depth, t.color, opts) }
  let id = if t.depth == 0 { "root" } else { t.node.id }
  content((cx, cy), _framed(t, _nodebox(t.node, t.depth, t.color, opts, width: t.width)),
    name: if id == none { none } else { "n-" + id })
  if opts.theme.underline and t.depth > 0 {
    // The underline is a line of its own in the width of the edge flowing
    // into it; as a box border it would have a different width and sit
    // offset by half its thickness.
    let st = _stroke(t.depth - 1, t.color, opts) + (cap: "butt")
    let (a, b) = ((cx - t.w / 2, cy - t.h / 2), (cx + t.w / 2, cy - t.h / 2))
    if opts.theme.hand == none { line(a, b, stroke: st) }
    else { _hand-line(((_pt(a.at(0)), _pt(a.at(1))), (_pt(b.at(0)), _pt(b.at(1)))), st, opts.theme.hand, _seed(_pt(a.at(0)), _pt(a.at(1)))) }
  }
}

// Draws a subtree whose box has its inner edge at m and is centred at u.
// With `underline` in a horizontal layout the edges sit on the baseline of
// the text, otherwise at the centre of the box.
// A soft rounded shape behind a subtree.
#let _cloud(t, m, u, dir, opts, vertical) = {
  import cetz.draw: *
  let fill = if t.node.cloud == true { t.color.lighten(85%) } else { t.node.cloud }
  let st = (paint: t.color, thickness: 0.06em, dash: "dashed")
  let a = _xy(m - dir * t.pad, u + t.lo, vertical)
  let b = _xy(m + dir * t.extent, u + t.hi, vertical)
  if opts.theme.hand == none {
    rect(a, b, fill: fill, stroke: st, radius: 0.8em)
  } else {
    let (cx, cy) = ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2)
    let (w, h) = (calc.abs(_pt(b.at(0)) - _pt(a.at(0))), calc.abs(_pt(b.at(1)) - _pt(a.at(1))))
    _hand-line(_rounded-rect(_pt(cx), _pt(cy), w, h, _pt(0.8em.to-absolute())), st, opts.theme.hand,
      _seed(_pt(cx), _pt(cy), w, h), closed: true, fill: fill)
  }
}

// A brace beyond the children of a node, spanning them, with its label.
#let _summary(t, m1, u, dir, opts, vertical) = {
  import cetz.draw: *
  let inner = t.kids.map(k => k.extent).fold(0pt, calc.max)
  let mb = m1 + dir * (inner + opts.summary-gap)
  let lo = t.kids.map(k => k.du + k.lo).fold(0pt, calc.min)
  let hi = t.kids.map(k => k.du + k.hi).fold(0pt, calc.max)
  // The brace's tip points to the left of its direction: run it so the tip
  // faces away from the tree.
  let (p, q) = if dir > 0 { (_xy(mb, u + lo, vertical), _xy(mb, u + hi, vertical)) }
    else { (_xy(mb, u + hi, vertical), _xy(mb, u + lo, vertical)) }
  cetz.decorations.brace(p, q, amplitude: _pt(opts.brace-size.to-absolute()),
    stroke: (paint: t.color, thickness: 0.07em))
  let ml = mb + dir * (opts.brace-size + opts.summary-gap)
  let anchor = if vertical { if dir > 0 { "south" } else { "north" } } else { if dir > 0 { "west" } else { "east" } }
  content(_xy(ml, u + (lo + hi) / 2, vertical), anchor: anchor,
    text(size: 0.9em, fill: t.color.darken(20%), t.node.summary))
}

#let _draw-tree(t, m, u, dir, opts, vertical) = {
  import cetz.draw: *
  let ul = opts.theme.underline and not vertical
  let anchor(tree, cu) = if ul { cu + tree.size-u / 2 } else { cu }
  let m0 = m + dir * t.size-m
  let m1 = m0 + dir * opts.level-gap
  if t.node.cloud != none { _cloud(t, m, u, dir, opts, vertical) }
  if t.summary != none { _summary(t, m1, u, dir, opts, vertical) }
  for k in t.kids {
    let ku = u + k.du
    let p0 = _xy(m0, anchor(t, u), vertical)
    let p1 = _xy(m1, anchor(k, ku), vertical)
    let (c0, c1) = _controls(p0, p1, vertical)
    _path(p0, c0, c1, p1, _stroke(k.depth - 1, k.color, opts), opts)
    _edge-label(_mid(p0, c0, c1, p1), k.node.edge-label, opts)
    _draw-tree(k, m1, ku, dir, opts, vertical)
  }
  // The box after the edges, so it covers their ends.
  let (cx, cy) = _xy(m + dir * t.size-m / 2, u, vertical)
  _draw-node(t, cx, cy, opts)
}

// Edge from the root to a branch: leaves the root towards the branch and
// arrives parallel to the main axis.
#let _root-controls(p1, m-inner, opts, vertical) = {
  if opts.theme.edge != "curve" or vertical {
    // Vertically the S-curve with its inflection at half height is calmest.
    _controls((0pt, 0pt), p1, vertical)
  } else {
    let (x1, y1) = p1
    ((x1 * 0.9, 0pt), (m-inner, y1))
  }
}

#let _root-edge(p1, m-inner, st, opts, vertical, label: none) = {
  let (c0, c1) = _root-controls(p1, m-inner, opts, vertical)
  _path((0pt, 0pt), c0, c1, p1, st, opts)
  _edge-label(_mid((0pt, 0pt), c0, c1, p1), label, opts)
}

// Stacks branches on u, centred around 0, and draws them with their root edge.
#let _draw-stack(side, dir, m-inner, m1, opts, vertical) = {
  let total = side.map(t => t.size).sum(default: 0pt) + opts.branch-gap * calc.max(side.len() - 1, 0)
  let cu = -total / 2
  for t in side {
    let tu = cu - t.lo
    let au = if opts.theme.underline and not vertical { tu + t.size-u / 2 } else { tu }
    _root-edge(_xy(m1, au, vertical), dir * m-inner, _stroke(0, t.color, opts), opts, vertical,
      label: t.node.edge-label)
    _draw-tree(t, m1, tu, dir, opts, vertical)
    cu += t.size + opts.branch-gap
  }
}

// Star: every branch gets an angle, its box sits on a circle around the
// root, its subtree grows horizontally outward. The radius starts at
// `root-gap` and grows until no two subtrees overlap.
#let _draw-star(trees, rm, start, opts) = {
  let n = trees.len()
  if n == 0 { return }
  let angles = range(n).map(i => start - i * 360deg / n)
  let dirs = angles.map(a => if calc.cos(a) >= 0 { 1 } else { -1 })
  // Inner edge of the branch box: to the sides it sits on the circle point;
  // the closer the branch is to vertical, the further the box moves over
  // the point, until it is centred directly above or below it.
  let inner(i, r) = {
    let (a, d, t) = (angles.at(i), dirs.at(i), trees.at(i))
    let f = 1 - calc.min(1, calc.abs(calc.cos(a)) / 0.4)
    (px: r * calc.cos(a) - d * t.w / 2 * f, py: r * calc.sin(a))
  }
  // Rectangle of a subtree at radius r: (x0, x1, y0, y1)
  let rect(i, r) = {
    let (d, t) = (dirs.at(i), trees.at(i))
    let (px, py) = inner(i, r)
    (x0: calc.min(px, px + d * t.extent), x1: calc.max(px, px + d * t.extent),
     y0: py - t.hi, y1: py - t.lo)
  }
  let overlaps(r) = {
    let gap = opts.branch-gap
    let rects = range(n).map(i => rect(i, r))
    // keep the root clear as well
    rects.push((x0: -rm.w / 2 - opts.root-gap / 2, x1: rm.w / 2 + opts.root-gap / 2,
                y0: -rm.h / 2 - gap, y1: rm.h / 2 + gap))
    for i in range(rects.len()) {
      for j in range(i + 1, rects.len()) {
        let (a, b) = (rects.at(i), rects.at(j))
        if a.x0 < b.x1 + gap and b.x0 < a.x1 + gap and a.y0 < b.y1 + gap and b.y0 < a.y1 + gap {
          return true
        }
      }
    }
    false
  }
  let r = calc.max(rm.w, rm.h) / 2 + opts.root-gap
  let steps = 0
  while overlaps(r) and steps < 400 { r += 4pt; steps += 1 }

  for i in range(n) {
    let (a, d, t) = (angles.at(i), dirs.at(i), trees.at(i))
    let (px, py) = inner(i, r)
    let st = _stroke(0, t.color, opts)
    if calc.abs(calc.cos(a)) < 0.2 and opts.theme.edge == "curve" {
      // Branch almost straight above or below the root: the edge arrives at
      // the centre of the box from above or below instead of hooking in
      // from the side.
      let cx = px + d * t.w / 2
      let ty = if py < 0pt { py + t.h / 2 } else { py - t.h / 2 }
      _path((0pt, 0pt), (0pt, ty / 2), (cx, ty / 2), (cx, ty), st, opts)
      _edge-label(_mid((0pt, 0pt), (0pt, ty / 2), (cx, ty / 2), (cx, ty)), t.node.edge-label, opts)
    } else {
      let ay = if opts.theme.underline { py - t.size-u / 2 } else { py }
      _root-edge((px, ay), px - d * opts.root-gap / 2, st, opts, false, label: t.node.edge-label)
    }
    _draw-tree(t, px, -py, d, opts, false)
  }
}

// Radial: the whole tree fans out from the root. Every subtree owns an
// angular sector, proportional to its number of leaves, nested inside its
// parent's sector; a node sits on the ring of its depth at the middle of
// its sector. The rings start at `root-gap` and are spread out together
// until no two boxes overlap. Text stays horizontal.

// Number of leaves below a node, at least 1.
#let _leaves(t) = if t.kids.len() == 0 { 1 } else { t.kids.map(_leaves).sum() }

// The weight of a node's sector: the square root of its leaf count. Plain
// leaf counts hand a wide branch most of the circle and squeeze the bare
// ones together; the root softens that without ignoring size.
#let _weight(t) = calc.sqrt(_leaves(t))

// Assigns angles: every node gets `angle` (centre of its sector) and
// `span` (width of its sector). The children share the parent's sector by
// leaf count, but never more of it than they need: on their ring, the arc
// they take up is their boxes plus gaps, so a branch with two leaves keeps
// them close instead of spreading them over a third of the circle.
// `radii` are the ring radii per depth. Returns the tree with these fields.
#let _sectors(t, angle, span, radii, gap) = {
  let total = t.kids.map(_weight).sum(default: 1)
  let kids = ()
  if t.kids.len() > 0 {
    // Extent of a box across the ray: on a horizontal ray the boxes stack
    // by height, on a vertical one by width.
    let r = radii.at(t.depth + 1)
    let across(k) = calc.abs(k.w * calc.sin(angle)) + calc.abs(k.h * calc.cos(angle))
    let arc = t.kids.map(k => across(k) + gap).sum()
    let needed = 1rad * (arc / r) * 1.15
    let span = calc.min(span, needed)
    let a = angle + span / 2
    for k in t.kids {
      let w = span * _weight(k) / total
      kids.push(_sectors(k, a - w / 2, w, radii, gap))
      a -= w
    }
  }
  t + (angle: angle, span: span, kids: kids)
}

// The largest box extent on each depth: (max w, max h) per level.
#let _level-sizes(t, acc) = {
  while acc.len() <= t.depth { acc.push((w: 0pt, h: 0pt)) }
  acc.at(t.depth) = (w: calc.max(acc.at(t.depth).w, t.w), h: calc.max(acc.at(t.depth).h, t.h))
  for k in t.kids { acc = _level-sizes(k, acc) }
  acc
}

#let _draw-radial(trees, rm, start, opts) = {
  let n = trees.len()
  if n == 0 { return }
  // Ring radii per depth, a tight first guess: the rings are spread out
  // below until nothing overlaps.
  let sizes = _level-sizes((depth: 0, w: rm.w, h: rm.h, kids: trees), ())
  let radii = (0pt,)
  for d in range(1, sizes.len()) {
    let gap = if d == 1 { opts.root-gap } else { opts.level-gap }
    radii.push(radii.at(d - 1) + sizes.at(d - 1).h / 2 + gap + sizes.at(d).h / 2)
  }
  // Sectors of the first level, clockwise from `start`, by leaf count.
  let total = trees.map(_weight).sum()
  let a = start
  let placed = ()
  for t in trees {
    let w = 360deg * _weight(t) / total
    placed.push(_sectors(t, a - w / 2, w, radii, opts.sibling-gap))
    a -= w
  }
  // Positions for a spreading factor f; then all boxes as rectangles.
  let pos(t, f) = (radii.at(t.depth) * f * calc.cos(t.angle), radii.at(t.depth) * f * calc.sin(t.angle))
  let rects(t, f, acc) = {
    let (x, y) = pos(t, f)
    acc.push((x0: x - t.w / 2, x1: x + t.w / 2, y0: y - t.h / 2, y1: y + t.h / 2))
    for k in t.kids { acc = rects(k, f, acc) }
    acc
  }
  let overlaps(f) = {
    let gap = opts.sibling-gap
    let rs = ((x0: -rm.w / 2, x1: rm.w / 2, y0: -rm.h / 2, y1: rm.h / 2),)
    for t in placed { rs = rects(t, f, rs) }
    for i in range(rs.len()) {
      for j in range(i + 1, rs.len()) {
        let (p, q) = (rs.at(i), rs.at(j))
        if p.x0 < q.x1 + gap and q.x0 < p.x1 + gap and p.y0 < q.y1 + gap and q.y0 < p.y1 + gap {
          return true
        }
      }
    }
    false
  }
  let f = 1.0
  let steps = 0
  while overlaps(f) and steps < 60 { f *= 1.05; steps += 1 }

  // Edges first, boxes after, so the boxes cover the line ends.
  let draw(t, parent, pa) = {
    let p = pos(t, f)
    let st = _stroke(t.depth - 1, t.color, opts)
    let (c0, c1) = if opts.theme.edge == "curve" {
      // Leaves the parent along its own ray and arrives along the child's:
      // a gentle bend that keeps the fan readable.
      let (dx, dy) = (p.at(0) - parent.at(0), p.at(1) - parent.at(1))
      let d = calc.sqrt((dx / 1pt) * (dx / 1pt) + (dy / 1pt) * (dy / 1pt)) * 1pt * 0.4
      ((parent.at(0) + d * calc.cos(pa), parent.at(1) + d * calc.sin(pa)),
       (p.at(0) - d * calc.cos(t.angle), p.at(1) - d * calc.sin(t.angle)))
    } else { (parent, p) }
    _path(parent, c0, c1, p, st, opts)
    _edge-label(_mid(parent, c0, c1, p), t.node.edge-label, opts)
    for k in t.kids { draw(k, p, t.angle) }
  }
  for t in placed { draw(t, (0pt, 0pt), t.angle) }
  let boxes(t) = {
    let (x, y) = pos(t, f)
    _draw-node(t, x, y, opts)
    for k in t.kids { boxes(k) }
  }
  for t in placed { boxes(t) }
}

// The box sizes of every node with an id, for the cross-links.
#let _sizes-by-id(t, acc) = {
  if t.node.id != none { acc.insert(t.node.id, (w: t.w, h: t.h)) }
  for k in t.kids { acc = _sizes-by-id(k, acc) }
  acc
}

// Where a line from the centre of a box towards `to` leaves the box.
#let _border(c, to, size) = {
  let (dx, dy) = (to.at(0) - c.at(0), to.at(1) - c.at(1))
  let (hw, hh) = (_pt(size.w) / 2, _pt(size.h) / 2)
  let t = calc.min(if calc.abs(dx) < 1e-6 { 1e9 } else { hw / calc.abs(dx) },
                   if calc.abs(dy) < 1e-6 { 1e9 } else { hh / calc.abs(dy) })
  (c.at(0) + dx * t, c.at(1) + dy * t)
}

// Cross-links, drawn last, over everything: the nodes are addressed by the
// CeTZ names `_draw-node` gave them.
#let _draw-links(links, sizes, opts) = {
  import cetz.draw: *
  for l in links {
    assert(l.from in sizes and l.to in sizes,
      message: "brainroot: connect(" + repr(l.from) + ", " + repr(l.to) + "): no node with that id")
    get-ctx(ctx => {
      let (_, a, b) = cetz.coordinate.resolve(ctx, "n-" + l.from + ".center", "n-" + l.to + ".center")
      let p0 = _border(a, b, sizes.at(l.from))
      let p1 = _border(b, a, sizes.at(l.to))
      let (dx, dy) = (p1.at(0) - p0.at(0), p1.at(1) - p0.at(1))
      let c = ((p0.at(0) + p1.at(0)) / 2 - dy * l.bend / 100%, (p0.at(1) + p1.at(1)) / 2 + dx * l.bend / 100%)
      let color = if l.color == auto { rgb("#555555") } else { l.color }
      let st = (paint: color, thickness: l.thickness, dash: l.dash, cap: "round")
      let mark = if l.arrow == "both" { (start: "stealth", end: "stealth", fill: color) }
        else if l.arrow == true { (end: "stealth", fill: color) } else { none }
      if opts.theme.hand == none {
        bezier(p0, p1, c, stroke: st, mark: mark)
      } else {
        let pts = _flatten-bezier(p0, c, c, p1)
        let q = _wobble(pts, opts.theme.hand, _seed(..p0, ..p1))
        line(..q, stroke: st, mark: mark)
      }
      if l.label != none {
        let mid = (0.25 * p0.at(0) + 0.5 * c.at(0) + 0.25 * p1.at(0), 0.25 * p0.at(1) + 0.5 * c.at(1) + 0.25 * p1.at(1))
        content(mid, box(fill: opts.edge-label-fill, inset: 0.25em, radius: 0.2em,
          text(size: 0.85em, fill: color, top-edge: "bounds", bottom-edge: "bounds", l.label)))
      }
    })
  }
}

/// Draws the mind map. The first-level branches come as positional
/// arguments: `branch(...)` calls, plain content, or a Typst list whose items
/// become branches and whose nested lists become children.
///
/// -> content
#let brainroot(
  /// First-level branches: `branch(...)`, content, or a list. Without
  /// `title`, the first positional argument is the root.
  /// -> content | dictionary
  ..branches,
  /// Label of the root.
  /// -> content | str | none
  title: none,
  /// Name of a theme (`soft`, `outline`, `blocks`, `lines`, `sketch`,
  /// `bubbles`, `hand`, `scribble`, `marker`, `pencil`) or a dictionary that
  /// overrides individual fields of one (`base:` picks the starting theme,
  /// otherwise `soft`).
  /// -> str | dictionary
  theme: "soft",
  /// Arrangement of the branches around the root: `"both"` right and left,
  /// `"right"` or `"left"` one-sided, `"down"` or `"up"` as a tree from the
  /// top or bottom, `"radial"` fanning out from the root in every direction,
  /// `"star"` with the branches on a circle and their subtrees growing
  /// horizontally outward.
  /// -> str
  layout: "both",
  /// `radial` and `star` only: angle of the first branch; the others follow
  /// clockwise.
  /// -> angle
  start: 60deg,
  /// Strength of the wobble in hand-drawn themes, a factor on their
  /// `amplitude`; `0` draws straight, `2` twice as restless.
  /// -> float | ratio
  wobble: 1,
  /// Name of a palette (`poster`, `pastel`, `grayscale`, `mono`, `plain`,
  /// `earth`, `ocean`, `sunset`, `forest`, `neon`), an array of colours, or a
  /// dictionary `(colors: ..., root: ...)`. The colours go in order to
  /// branches without a `color` of their own.
  /// -> str | array | dictionary
  palette: "poster",
  /// Colour of the root; `auto` takes the palette's.
  /// -> color | auto
  root-fill: auto,
  /// How much the branch colour is lightened for the boxes.
  /// -> ratio
  tint: 60%,
  /// Minimum luminance (0 to 1) of tinted fills; dark palette colours are
  /// lightened further to reach it.
  /// -> float
  tint-min: 0.8,
  /// Text colour; `auto` picks per box between `ink-dark` and `ink-light` by
  /// the luminance of its fill.
  /// -> color | auto
  ink: auto,
  /// Text on light fills.
  /// -> color
  ink-dark: black,
  /// Text on dark fills.
  /// -> color
  ink-light: white,
  /// Luminance (0 to 1) below which `ink-light` applies.
  /// -> float
  ink-threshold: 0.55,
  /// Font size relative to the surroundings, per level (root, branches,
  /// leaves, ...); the last value holds for all deeper levels.
  /// -> array
  scale: (1.3, 1.1, 1.0),
  /// Levels (from the root) set in bold.
  /// -> int
  bold-depth: 2,
  /// Line width per level of connection (root→branch, branch→leaf, ...); the
  /// last value holds for all deeper levels.
  /// -> array
  thickness: (0.27em, 0.14em),
  /// Distance between parent and child box along the direction of growth.
  /// -> length
  level-gap: 3.5em,
  /// Distance between root and branches; with `radial` and `star` the
  /// radius of the first ring.
  /// -> length
  root-gap: 6em,
  /// Distance between siblings across the direction of growth.
  /// -> length
  sibling-gap: 0.7em,
  /// Distance between the first-level branches.
  /// -> length
  branch-gap: 2em,
  /// Labels wider than this wrap; `none` never wraps.
  /// -> length | none
  max-width: 14em,
  /// Padding of the boxes. All lengths may be given in `em`; the defaults
  /// are, so a map follows the font size around it.
  /// -> dictionary | length
  inset: (x: 0.9em, y: 0.55em),
  /// `auto` draws the map at its natural size; a length or a ratio of the
  /// surrounding block scales the whole map, text included, to that width.
  /// -> auto | length | ratio
  width: auto,
  /// A factor on the whole map, applied on top of `width`; `zoom: 50%`
  /// halves it.
  /// -> ratio | float
  zoom: 100%,
  /// An icon, emoji or image beside the root's label.
  /// -> content | none
  icon: none,
  /// Where the root's icon goes: `"left"` or `"top"`.
  /// -> str
  icon-at: "left",
  /// A colour behind the whole map; `none` leaves the page as it is.
  /// -> color | none
  background: none,
  /// Space between the map and the edge of its background.
  /// -> length
  padding: 1em,
  /// Steps the branch colour per level below the first: `20%` lightens each
  /// level by a fifth towards the leaves, `-20%` darkens. `0%` keeps one
  /// colour per branch.
  /// -> ratio
  shade: 0%,
  /// Draws whole classes of nodes as gaps: `"leaves"`, `"branches"` (the
  /// first level) or `"all"`; `none` only honours each node's own `blank`.
  /// -> none | str
  blanks: none,
  /// `true` fills the gaps in: the solution of a map with blanks.
  /// -> bool
  solution: false,
  /// Text colour for filled-in gaps, so the solution stands out; `auto`
  /// uses the normal text colour.
  /// -> auto | color
  solution-ink: auto,
  /// Background of the small labels on edges.
  /// -> color | none
  edge-label-fill: white,
  /// Cross-links between nodes, each a `connect(...)`.
  /// -> array
  links: (),
  /// Height of a summary brace.
  /// -> length
  brace-size: 0.6em,
  /// Space on either side of a summary brace.
  /// -> length
  summary-gap: 0.5em,
  /// Space between a cloud and the boxes inside it.
  /// -> length
  cloud-pad: 0.6em,
) = context {
  // Lengths in em follow the surrounding font size, so a map in a footnote
  // and a map on a poster keep their proportions. Resolve them once here.
  let abs(l) = if type(l) == length { l.to-absolute() } else { l }
  let level-gap = abs(level-gap)
  let root-gap = abs(root-gap)
  let sibling-gap = abs(sibling-gap)
  let branch-gap = abs(branch-gap)
  let max-width = abs(max-width)
  let thickness = thickness.map(abs)
  let inset = if type(inset) == dictionary { inset.pairs().map(((k, v)) => (k, abs(v))).to-dict() } else { abs(inset) }
  let layouts = ("both", "right", "left", "down", "up", "radial", "star")
  assert(layout in layouts, message: "brainroot: layout must be one of " + layouts.join(", "))
  let vertical = layout in ("down", "up")
  let theme = _theme(theme)
  if theme.hand != none {
    theme.hand.amplitude *= wobble
  }
  let palette = _palette(palette)
  let root-fill = if root-fill == auto { palette.root } else { root-fill }
  let opts = (
    theme: theme, root-fill: root-fill, tint: tint, tint-min: tint-min,
    ink: ink, ink-dark: ink-dark, ink-light: ink-light, ink-threshold: ink-threshold,
    scale: scale, bold-depth: bold-depth, thickness: thickness,
    level-gap: level-gap, root-gap: root-gap, sibling-gap: sibling-gap, branch-gap: branch-gap,
    max-width: max-width, inset: inset,
    shade: shade, blanks: blanks, solution: solution, solution-ink: solution-ink,
    edge-label-fill: edge-label-fill,
    brace-size: abs(brace-size), summary-gap: abs(summary-gap), cloud-pad: abs(cloud-pad),
  )
  let args = branches.pos()
  let root = title
  if root == none {
    assert(args.len() > 0, message: "brainroot: root missing (title: ... or first argument)")
    root = args.first()
    args = args.slice(1)
  }
  let root-node = branch(root, icon: icon, icon-at: icon-at)
  let rm = _measure-node(root-node, 0, black, opts)

  let trees = args.map(_expand).flatten().enumerate().map(((i, b)) => {
    let b = _norm(b)
    let c = if b.color != none { b.color } else { palette.colors.at(calc.rem(i, palette.colors.len())) }
    _measure-tree(b, 1, c, opts, vertical)
  })

  let canvas = cetz.canvas(length: 1pt, {
    import cetz.draw: *
    if layout == "radial" {
      _draw-radial(trees, rm, start, opts)
    } else if layout == "star" {
      _draw-star(trees, rm, start, opts)
    } else if vertical {
      let dir = if layout == "down" { -1 } else { 1 }
      _draw-stack(trees, dir, rm.h / 2, dir * (rm.h / 2 + root-gap), opts, true)
    } else {
      let sides = _split(trees, branch-gap, layout)
      for (dir, side) in ((1, sides.right), (-1, sides.left)) {
        _draw-stack(side, dir, rm.w / 2, dir * (rm.w / 2 + root-gap), opts, false)
      }
    }
    // The root last, so it lies on top of the lines.
    _draw-node(rm + (node: root-node, depth: 0, color: black, width: rm.width), 0pt, 0pt, opts)
    // Cross-links over everything.
    if links.len() > 0 {
      let sizes = (root: (w: rm.w, h: rm.h))
      for t in trees { sizes = _sizes-by-id(t, sizes) }
      _draw-links(links.filter(l => type(l) == dictionary and l.at("brainroot-link", default: false)), sizes, opts)
    }
  })

  let canvas = if background == none { canvas } else {
    block(fill: background, inset: abs(padding), radius: 0.6em, canvas)
  }
  if width == auto and zoom == 100% { return canvas }
  // Scale the finished drawing as a whole, text included, so `width` and
  // `zoom` never change the layout, only its size on the page.
  std.layout(size => context {
    let natural = measure(canvas).width
    let target = if width == auto { natural } else if type(width) == ratio { size.width * width } else { width.to-absolute() }
    let f = target / natural * zoom
    std.scale(f, reflow: true, canvas)
  })
}
