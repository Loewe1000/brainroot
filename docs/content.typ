#import "@schule/schuldocs:0.2.0": show-example, show-module, show-code


= Über dieses Paket

Eine Mindmap, wie sie an der Tafel entsteht: ein Begriff in der Mitte, die
Oberbegriffe rechts und links daneben, dahinter die Beispiele. `brainroot`
setzt so eine Karte aus einer verschachtelten Liste. Jeder Ast bekommt eine
Farbe, die er bis in seine Blätter weitergibt; die Kästen sind in einem
helleren Ton derselben Farbe gefüllt, die Verbindungen laufen als weiche
Kurven.

Das Paket basiert auf *CeTZ*. Die Kästen werden gemessen, deshalb passen
sie sich der Schrift des umgebenden Dokuments an.

= Schnellstart

#show-code[```typ
#import "@preview/brainroot:0.2.0": brainroot, branch
```]

Die einfachste Eingabe ist eine Liste: jeder Punkt wird zu einem Knoten,
eingerückte Punkte zu seinen Kindern.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energiearten])[
      - Bewegungsenergie
        - Kinetische Energie
        - Windenergie
      - Spannenergie
        - Dehnungsenergie
      - Wärmeenergie
        - Feuerenergie
      - Höhenenergie
        - Schwerkraftenergie
        - Gewichtenergie
    ]
  },
  source: ```typ
#brainroot(title: [Energiearten])[
  - Bewegungsenergie
    - Kinetische Energie
    - Windenergie
  - Spannenergie
    - Dehnungsenergie
  - Wärmeenergie
    - Feuerenergie
  - Höhenenergie
    - Schwerkraftenergie
    - Gewichtenergie
]
  ```,
  width: 100%,
)

Drei Zeichen in der Liste tragen Knotenoptionen: ein Typst-Label `<name>`
am Ende gibt dem Knoten seine `id` für Querverbindungen, ein Punkt, der
nur aus `*Fettschrift*` besteht, hebt ihn hervor, einer nur aus
`_Kursivschrift_` wird zur Lücke.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Fotosynthese], links: (connect("licht", "dunkel", label: [ATP]),))[
      - Lichtreaktion <licht>
        - *Fotolyse*
        - _ATP_
      - Dunkelreaktion <dunkel>
        - Calvin-Zyklus
        - _Glucose_
    ]
  },
  source: ```typ
#brainroot(title: [Fotosynthese], links: (connect("licht", "dunkel", label: [ATP]),))[
  - Lichtreaktion <licht>
    - *Fotolyse*
    - _ATP_
  - Dunkelreaktion <dunkel>
    - Calvin-Zyklus
    - _Glucose_
]
  ```,
  width: 100%,
)

Wer einen Ast genauer bestimmen will, schreibt ihn als `branch(label, ..kinder)`.
Ein Kind ist dann entweder Content, also ein Blatt, oder wieder ein
`branch(...)`. Liste und `branch`-Aufrufe dürfen nebeneinander stehen; ohne
`title` gilt das erste Argument als Wurzel.

= Seiten und Farben

Ohne Angabe verteilt `brainroot` die Äste selbst: die ersten gehen nach
rechts, bis die rechte Seite etwa halb so hoch ist wie alle Äste zusammen,
die übrigen nach links. `side: left` oder `side: right` legt einen Ast fest,
`color` gibt ihm eine eigene Farbe statt der nächsten aus der Palette.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: branch([Fotosynthese], fill: green.lighten(50%)), spacing: (max-width: 3cm),
      branch([Lichtreaktion], branch([Fotolyse], [Wasser wird gespalten]), [ATP], side: right),
      branch([Dunkelreaktion], [Calvin-Zyklus], [Glucose], color: purple),
      branch([Voraussetzungen], [Licht], [Wasser], [CO₂], side: left),
    )
  },
  source: ```typ
#brainroot(title: branch([Fotosynthese], fill: green.lighten(50%)), spacing: (max-width: 3cm),
  branch([Lichtreaktion], branch([Fotolyse], [Wasser wird gespalten]), [ATP], side: right),
  branch([Dunkelreaktion], [Calvin-Zyklus], [Glucose], color: purple),
  branch([Voraussetzungen], [Licht], [Wasser], [CO₂], side: left),
)
  ```,
  width: 100%,
)

#let karte = [
  - Bewegungsenergie
    - Kinetische Energie
    - Windenergie
  - Spannenergie
    - Dehnungsenergie
  - Wärmeenergie
    - Feuerenergie
  - Höhenenergie
    - Schwerkraftenergie
    - Gewichtenergie
]

= Knoten

Eine Beschriftung ist Content: Formeln, Bilder und Links gehen wie überall.
Ein `icon` steht links neben der Beschriftung oder mit `icon-at: "top"`
darüber. Die Wurzel ist auch ein `branch`: `title: branch([Energie], icon:
..., fill: ...)`. Je Knoten lassen sich `fill` (eine Farbe oder
`none` für einen Ring), `ink` und `mark: true` für einen hervorgehobenen
Fachbegriff setzen.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: branch([Energie], icon: text(size: 1.6em, emoji.bolt), icon-at: "top"),
      branch([Formel], [$E = 1/2 m v^2$], [$E = m g h$], icon: emoji.abacus),
      branch([Link], link("https://typst.app")[typst.app]),
      branch([Wichtig], branch([Kernbegriff], mark: true), branch([Ring], fill: none), branch([Rot], ink: red)))
  },
  source: ```typ
#brainroot(title: branch([Energie], icon: text(size: 1.6em, emoji.bolt), icon-at: "top"),
  branch([Formel], [$E = 1/2 m v^2$], [$E = m g h$], icon: emoji.abacus),
  branch([Link], link("https://typst.app")[typst.app]),
  branch([Wichtig], branch([Kernbegriff], mark: true), branch([Ring], fill: none), branch([Rot], ink: red)))
  ```,
  width: 100%,
)

== Lückenkarte und Lösung

`blank: true` an einem Ast zeichnet seinen Kasten leer, in voller Größe.
`blanks: "leaves"`, `"branches"` oder `"all"` tut das für eine ganze Klasse
von Knoten. Dieselbe Karte mit `solution: true` füllt die Lücken, mit
`solution-ink` in einer Farbe, die die Antworten hervorhebt. Aufgabe und
Lösung entstehen so aus derselben Quelle.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energiearten], blanks: "leaves", karte)
    v(4pt)
    brainroot(width: 100%, title: [Energiearten], blanks: "leaves", solution: true, solution-ink: red, karte)
  },
  source: ```typ
#brainroot(title: [Energiearten], blanks: "leaves", karte)
#brainroot(title: [Energiearten], blanks: "leaves", solution: true, solution-ink: red, karte)
  ```,
  width: 100%,
)

== Kantenbeschriftung

`edge-label` setzt ein kleines Schild auf die Kante, die zu einem Knoten
führt. Damit werden aus der Mindmap Baumdiagramme der Stochastik oder
Entscheidungsbäume.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Start], layout: "right", theme: "outline", palette: "plain",
      branch([Kopf], branch([Kopf], edge-label: $1/2$), branch([Zahl], edge-label: $1/2$), edge-label: $1/2$),
      branch([Zahl], branch([Kopf], edge-label: $1/2$), branch([Zahl], edge-label: $1/2$), edge-label: $1/2$))
  },
  source: ```typ
#brainroot(title: [Start], layout: "right", theme: "outline", palette: "plain",
  branch([Kopf], branch([Kopf], edge-label: $1/2$), branch([Zahl], edge-label: $1/2$), edge-label: $1/2$),
  branch([Zahl], branch([Kopf], edge-label: $1/2$), branch([Zahl], edge-label: $1/2$), edge-label: $1/2$))
  ```,
  width: 100%,
)

== Querverbindungen, Klammern, Wolken

Eine Mindmap ist ein Baum, die Gedanken darin sind es selten. `id` gibt einem
Knoten einen Namen, `connect(von, nach)` in `links` zieht eine Kurve zwischen
zwei Knoten über die Karte, mit `label`, `arrow`, `dash` und `bend`. Die
Wurzel heißt `"root"`. `summary` setzt eine Klammer mit Beschriftung hinter
die Kinder eines Knotens, `cloud` legt eine Wolke hinter seinen Teilbaum.
Klammern und Wolken gibt es in den Baum-Anordnungen, nicht bei `radial` und
`star`. `arrange: "links"` ordnet die Äste und dreht Kinder um, damit
verbundene Knoten nahe beieinander liegen; hier rückt CO₂ neben Glucose.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Fotosynthese], arrange: "links",
      links: (connect("licht", "dunkel", label: [ATP, NADPH]), connect("co2", "glucose", label: [C], dash: "dotted")),
      branch([Lichtreaktion], [Fotolyse], [ATP], [NADPH], id: "licht", cloud: true),
      branch([Dunkelreaktion], [Calvin-Zyklus], branch([Glucose], id: "glucose"), id: "dunkel", summary: [Produkte]),
      branch([Voraussetzungen], [Licht], [Wasser], branch([CO₂], id: "co2"), summary: [von außen]))
  },
  source: ```typ
#brainroot(title: [Fotosynthese], arrange: "links",
  links: (connect("licht", "dunkel", label: [ATP, NADPH]), connect("co2", "glucose", label: [C], dash: "dotted")),
  branch([Lichtreaktion], [Fotolyse], [ATP], [NADPH], id: "licht", cloud: true),
  branch([Dunkelreaktion], [Calvin-Zyklus], branch([Glucose], id: "glucose"), id: "dunkel", summary: [Produkte]),
  branch([Voraussetzungen], [Licht], [Wasser], branch([CO₂], id: "co2"), summary: [von außen]))
  ```,
  width: 100%,
)

== Punkte und Aufbau

`points` an einem Ast zählt für die Bewertung einer Karte; `brainroot-points`
mit denselben Argumenten summiert sie, `show-points: true` zeigt sie als
Marke am Kasten. `reveal` zeichnet nur die ersten Äste oder die, für die eine
Funktion des Index wahr ist. Das Layout bleibt dabei, so baut sich eine Karte
Ast für Ast auf, in typstage etwa mit
`build(from => brainroot(..., reveal: i => from(i + 2)), steps: 5)`.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energiearten], reveal: 2, show-points: true,
      branch([Bewegungsenergie], branch([Kinetische Energie], points: 1), branch([Windenergie], points: 1)),
      branch([Spannenergie], branch([Dehnungsenergie], points: 2)),
      branch([Wärmeenergie], [Feuerenergie]))
  },
  source: ```typ
#brainroot(title: [Energiearten], reveal: 2, show-points: true,
  branch([Bewegungsenergie], branch([Kinetische Energie], points: 1), branch([Windenergie], points: 1)),
  branch([Spannenergie], branch([Dehnungsenergie], points: 2)),
  branch([Wärmeenergie], [Feuerenergie]))
  ```,
  width: 100%,
)

= Anordnungen

`layout` bestimmt, wie die Äste um die Wurzel liegen. `both` ist die
zweiseitige Karte von oben, `right` und `left` legen alles auf eine Seite.
`down` und `up` setzen einen Baum von oben nach unten oder umgekehrt, wie ein
Organigramm. `radial` ist die klassische Mindmap nach Buzan: der ganze Baum
fächert von der Wurzel aus, jeder Teilbaum bekommt seinen eigenen Sektor.
`star` legt nur die Äste im Kreis um die Wurzel, die Teilbäume wachsen
waagerecht nach außen. `fishbone` ist das Ursache-Wirkungs-Diagramm nach
Ishikawa: die Wurzel als Kopf einer Gräte, die Äste als Rippen abwechselnd
oben und unten, die Blätter entlang der Rippen; zwei Ebenen unter der
Wurzel. `layout` nimmt auch ein Dictionary: `(kind: "down", align-levels:
true)` setzt in den Baum-Anordnungen jede Ebene auf eine Linie, wie in einem
Organigramm; `start` ist der Winkel des ersten Astes bei `radial` und `star`.
Die Abstände stehen in `spacing`, siehe `spacing-defaults`.


#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energiearten], layout: "down", karte)
  },
  source: ```typ
#brainroot(title: [Energiearten], layout: "down", karte)
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energiearten], layout: "radial", karte,
      branch([Druckenergie]), branch([Strahlungsenergie], [Lichtenergie]))
  },
  source: ```typ
#brainroot(title: [Energiearten], layout: "radial", karte,
  branch([Druckenergie]), branch([Strahlungsenergie], [Lichtenergie]))
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energiearten], layout: "star", karte,
      branch([Druckenergie]), branch([Strahlungsenergie], [Lichtenergie]))
  },
  source: ```typ
#brainroot(title: [Energiearten], layout: "star", karte,
  branch([Druckenergie]), branch([Strahlungsenergie], [Lichtenergie]))
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Schlechte Note], layout: "fishbone", theme: "outline",
      branch([Vorbereitung], [zu spät begonnen], [ohne Plan], [kein Üben]),
      branch([Unterricht], [gefehlt], [nicht mitgeschrieben]),
      branch([Prüfung], [Zeit falsch eingeteilt], [Aufgabe falsch gelesen]),
      branch([Umfeld], [Lärm], [Müdigkeit]))
  },
  source: ```typ
#brainroot(title: [Schlechte Note], layout: "fishbone", theme: "outline",
  branch([Vorbereitung], [zu spät begonnen], [ohne Plan], [kein Üben]),
  branch([Unterricht], [gefehlt], [nicht mitgeschrieben]),
  branch([Prüfung], [Zeit falsch eingeteilt], [Aufgabe falsch gelesen]),
  branch([Umfeld], [Lärm], [Müdigkeit]))
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Stoffe], layout: (kind: "down", align-levels: true), theme: "blocks",
      branch([Reinstoffe], branch([Elemente], [Metalle], [Nichtmetalle]), [Verbindungen]),
      branch([Gemische], [homogen], [heterogen]))
  },
  source: ```typ
#brainroot(title: [Stoffe], layout: (kind: "down", align-levels: true), theme: "blocks",
  branch([Reinstoffe], branch([Elemente], [Metalle], [Nichtmetalle]), [Verbindungen]),
  branch([Gemische], [homogen], [heterogen]))
  ```,
  width: 100%,
)

Bei `radial` und `star` steht der erste Ast bei `start` (Standard `60deg`),
die weiteren folgen im Uhrzeigersinn. Bei `radial` teilen sich die Kinder den
Sektor ihres Elternknotens, gewichtet nach der Größe ihrer Teilbäume, und
liegen auf dem Ring ihrer Tiefe; die Ringe beginnen bei `spacing.root` und werden
so weit gedehnt, bis sich keine zwei Kästen überschneiden.

= Paletten

`palette` liefert die Farben der Äste und der Wurzel; die Kästen bekommen die
Astfarbe um `tint` aufgehellt. Zehn Paletten sind eingebaut, alle mit derselben
Karte gezeigt:

#let paletten = (
  poster: [Kräftig bunt, wie Filzstifte an der Tafel. Der Standard.],
  pastel: [Zarte, gedämpfte Töne.],
  grayscale: [Nur Graustufen, für den Schwarzweißdruck.],
  mono: [Ein Blau in wechselnder Helligkeit.],
  plain: [Eine dunkle Tinte für alles, wie mit dem Füller gezeichnet.],
  earth: [Erdtöne: Terrakotta, Ocker, Oliv, Sand.],
  ocean: [Meer: Türkis, Petrol, Seegrün.],
  sunset: [Abendhimmel: Rot, Orange, Rosa, Violett.],
  forest: [Wald: Grün mit etwas Braun.],
  neon: [Grelle, gesättigte Farben.],
)
#for (name, beschreibung) in paletten [
  == #raw(name)
  #beschreibung
  #show-example(
    rendered: {
      import "../lib.typ": *
      set text(size: 8pt)
      brainroot(width: 100%, title: [Energiearten], palette: name, karte)
    },
    source: raw(lang: "typ", block: true, "#brainroot(title: [Energiearten], palette: \"" + name + "\", karte)"),
    width: 100%,
  )
]

Eigene Farben gehen als Array, `palette: (red, blue, green)`, oder mit
Wurzelfarbe als Dictionary, `palette: (colors: (red, blue), root: black)`.
Eine Palette darf auch `ink`, `ink-dark`, `ink-light` und `ink-threshold`
setzen, die Schriftfarben; `base` nimmt eine eingebaute Palette als
Ausgangspunkt: `palette: (base: "ocean", root: black)`. Die Wurzel selbst
färbt `title: branch([...], fill: ...)`.

= Themes

Ein Theme bestimmt, wie Kästen und Kanten aussehen; die Farben kommen
weiterhin aus der Palette. Zehn sind eingebaut:

#for (name, beschreibung) in (
  soft: [Pastellkästen mit runden Ecken, weiche S-Kurven. Die Vorlage von der Tafel.],
  outline: [Weiße Kästen mit farbigem Rahmen, Kurven.],
  blocks: [Vollfarbige eckige Kästen mit weißer Schrift, rechte Winkel: Organigramm-Optik.],
  lines: [Keine Kästen: der Text steht auf seiner farbigen Linie, die Kanten münden hinein. Die klassische Mindmap.],
  sketch: [Dünner Rahmen ohne Füllung, gestrichelte Geraden.],
  bubbles: [Pillen mit Pastellfüllung und geraden Verbindungen.],
  hand: [Wie `soft`, aber handgezeichnet: jede Linie wackelt leicht.],
  scribble: [Gekritzelt: keine Füllung, jede Linie zweimal gezogen.],
  marker: [Filzstift: volle Farbe, breite gerade Striche mit langem Wackeln.],
  pencil: [Bleistift: dünne Linien mit feinem Zittern, rechte Winkel.],
  organic: [Organisch nach Buzan: Äste, die zu den Blättern hin dünner werden, Pillen in Pastell.],
  twigs: [Zweige: weiße Kreise auf der ersten Ebene, kastenlose Blätter an einem gemeinsamen Stamm mit je einem Zweig, wie in Infografiken.],
) [
  == #raw(name)
  #beschreibung
  #show-example(
    rendered: {
      import "../lib.typ": *
      set text(size: 8pt)
      brainroot(width: 100%, title: [Energiearten], theme: name, karte)
    },
    source: raw(lang: "typ", block: true, "#brainroot(title: [Energiearten], theme: \"" + name + "\", karte)"),
    width: 100%,
  )
]

== Formen

Das Theme-Feld `shape` macht aus den Kästen Kreise oder Ellipsen; `size`
gibt je Tiefe einen festen Durchmesser vor, wie bei einem Bubble Tree.
Bei festem Durchmesser schrumpft die Schrift bis auf 60 Prozent, damit der
Text hineinpasst; reicht das nicht, wächst der Kreis. Ohne `size` passen
Kreise zu kurzen Beschriftungen, ein langes Wort macht den Kreis groß. `shade` stuft die Astfarbe je Ebene ab.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energie], layout: "radial", palette: "sunset",
      theme: (fill: "solid", shape: "circle", size: (5em, 4em, 2.8em), edge: "straight",
        thickness: (0.5em, 0.25em), scale: (1.1, 0.9, 0.7), shade: 25%))[
      - Bewegung
        - Wind
        - Fahrt
      - Wärme
        - Feuer
      - Höhe
        - Fall
        - Gewicht
    ]
  },
  source: ```typ
#brainroot(title: [Energie], layout: "radial", palette: "sunset",
  theme: (fill: "solid", shape: "circle", size: (5em, 4em, 2.8em), edge: "straight",
    thickness: (0.5em, 0.25em), scale: (1.1, 0.9, 0.7), shade: 25%))[ ... ]
  ```,
  width: 100%,
)

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Mind Map], theme: (base: "outline", shape: "ellipse"), palette: "ocean", karte)
  },
  source: ```typ
#brainroot(title: [Mind Map], theme: (base: "outline", shape: "ellipse"), palette: "ocean", karte)
  ```,
  width: 100%,
)

== Handgezeichnet

Die Themes `hand`, `scribble`, `marker` und `pencil` wackeln jede Linie nach
dem Muster der TikZ-Dekoration `sketch`: der Pfad wird in kleinen Schritten
abgelaufen, jeder Punkt senkrecht dazu um eine langsam laufende Sinuswelle
versetzt, deren Takt ein Zufallslauf bestimmt. Der Zufall ist reproduzierbar,
dieselbe Karte sieht bei jedem Übersetzen gleich aus. Eine Handschrift wie
"Patrick Hand" oder "Kalam" passt dazu; sie kommt per `set text(font: ...)`
oder über das Theme-Feld `font`.

`wobble` regelt die Stärke: `wobble: 0.5` wackelt halb so stark, `wobble: 2`
doppelt. Das Feld `hand` steuert das Wackeln im Einzelnen: `amplitude` (Ausschlag in pt),
`wavelength` (Wellenlänge in pt), `randomness` (Unregelmäßigkeit, 1 ist ein
reiner Sinus), `segment` (Schrittweite in pt) und `passes` (wie oft jede
Linie gezogen wird). Jedes Theme lässt sich damit handgezeichnet machen:

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt, font: "Patrick Hand")
    brainroot(width: 100%, title: [Energiearten],
      theme: (base: "blocks", hand: (amplitude: 1, wavelength: 60, randomness: 2, segment: 1.5, passes: 1)),
      karte)
  },
  source: ```typ
#set text(font: "Patrick Hand")
#brainroot(title: [Energiearten],
  theme: (base: "blocks", hand: (amplitude: 1, wavelength: 60, randomness: 2, segment: 1.5, passes: 1)),
  karte)
  ```,
  width: 100%,
)

== Ein Theme anpassen

Ein Dictionary überschreibt einzelne Felder; `base` wählt das Ausgangstheme,
sonst gilt `soft`. Ein Theme trägt alles, was das Aussehen betrifft:
Kästen (`shape`, `size`, `fill`, `stroke`, `radius`, `inset`, `underline`,
`font`, `scale`, `bold-depth`, `tint`, `tint-min`, `shade`), Kanten (`edge`,
`thickness`, `dash`, `taper`, `edge-label-fill`), `hand` für das Wackeln,
und `root` und `branches` mit Überschreibungen nur für die Wurzel und die
erste Ebene. `theme-defaults` listet jedes Feld mit seiner Vorgabe; ein
falsch geschriebenes Feld ist ein Fehler, kein stilles Nichts.

#show-example(
  rendered: {
    import "../lib.typ": *
    set text(size: 8pt)
    brainroot(width: 100%, title: [Energiearten], layout: "right",
      theme: (base: "outline", edge: "elbow", radius: 0pt), karte)
  },
  source: ```typ
#brainroot(title: [Energiearten], layout: "right",
  theme: (base: "outline", edge: "elbow", radius: 0pt), karte)
  ```,
  width: 100%,
)

= Die vier Ebenen

Alles, was eine Karte bestimmt, liegt auf einer von vier Ebenen, und jede
hat eine Stelle:

- *Theme* ist das Aussehen von Kästen und Kanten: Form, Füllung, Rahmen,
  Schriftgrößen je Ebene, Linienstärken, Abstufung der Farben, das Wackeln.
  Ein Name oder ein Dictionary, Felder in `theme-defaults`.
- *Palette* ist die Zuordnung der Farben: die der Äste, der Wurzel, der
  Schrift. Ein Name, ein Array von Farben oder ein Dictionary.
- *Layout* ist die Anordnung, `spacing` sind die Abstände: `level` und
  `root` in Wachstumsrichtung, `sibling` und `branch` quer dazu, `max-width`
  für den Umbruch, `brace`, `summary`, `cloud`, `label` (Abstand der
  Kantenschilder von der Kante) und `padding`. Felder in
  `layout-defaults` und `spacing-defaults`.
- *Knoten* sind `branch(...)`, die Wurzel eingeschlossen: Icon, Füllung,
  Schriftfarbe, Hervorhebung, Lücke, Kantenbeschriftung, `id`, Klammer,
  Wolke, Punkte.

Was auf `brainroot` selbst bleibt, sind die Regler je Karte: `wobble`,
`links`, `blanks`, `solution`, `solution-ink`, `show-points`, `reveal`,
`width`, `zoom`, `background` und `alt`. `width` skaliert die fertige Karte
samt Schrift auf eine Breite, als Länge oder als Anteil des umgebenden
Blocks (`width: 100%`); `zoom` ist ein Faktor obendrauf. Beide ändern nur
die Größe, nie das Layout.

Was in einem Dokument immer gleich ist, wird zur Vorgabe:

#show-code[```typ
#let karte = brainroot.with(theme: "hand", palette: "ocean", spacing: (level: 5em))
#karte(title: [Energiearten])[ ... ]
```]

= Barrierefreiheit und Leistung

Die Karte ist eine Abbildung mit Alternativtext: `alt: auto` schreibt den
Baum als Text aus, ein String gilt wie angegeben, `none` lässt ihn weg. So
tragen PDFs mit Tags den Inhalt der Karte auch für Vorleseprogramme.

Eine Karte mit etwa 200 Knoten übersetzt in gut einer halben Sekunde,
handgezeichnet in etwa zwei; das Messen der Kästen und das Wackeln der
Linien sind die beiden Posten. Sehr große Karten werden deshalb nicht
langsam, aber sie werden unübersichtlich, und das ist der Grund, sie zu
teilen.

= Funktionen

#show-module(read("../lib.typ") + "\n" + read("../src/input.typ"), name: "brainroot")

== Vorgaben

Die Felder von Theme, Palette, Layout und Abständen, mit ihren Vorgaben:

#show-module(read("../src/themes.typ") + "\n" + read("../src/palettes.typ") + "\n" + read("../src/options.typ"), name: "brainroot")
