# brainroot: Was noch geht

Bericht aus vier Recherchen (Mindmap-Werkzeuge, verwandte Diagrammtypen,
Typst-Ökosystem und Schulbedarf, visuelle Stile aus den drei Vorlagenbildern),
Stand 5. September 2026, brainroot 0.1.0.

## Kurzfassung

brainroot deckt die Mindmap im engeren Sinn ab: ein Baum aus einer Liste,
sieben Anordnungen, zehn Themes, zehn Paletten, handgezeichneter Modus. Was
alle verglichenen Werkzeuge darüber hinaus haben und was den Schulalltag
betrifft, lässt sich in vier Gruppen fassen:

1. **Knotenformen und Bilder.** Kreise, Ellipsen, Bilder und Icons im Knoten,
   Knotengröße nach Tiefe. Das sind die drei Vorlagenbilder.
2. **Verbindungen jenseits des Baums.** Querverbindungen mit Beschriftung,
   Klammern über Geschwister, Wolken um Teilbäume. Damit werden aus Mindmaps
   Concept Maps.
3. **Unterricht.** Lückenkarten mit Lösung, Punkte je Knoten, schrittweises
   Aufdecken in typstage, Hervorhebung von Fachbegriffen.
4. **Nachbardiagramme.** Klassifikationsbäume, Entscheidungsbäume,
   Organigramme, Fishbone, Klammerkarten. Vieles geht schon, manches braucht
   eine Anordnung oder Kantenbeschriftung.

## 1. Was Mindmap-Werkzeuge zusätzlich können

| Werkzeug | Bemerkenswert |
| --- | --- |
| XMind | Skelette auf denselben Daten: Fishbone, Matrix, Zeitstrahl, Logikdiagramm, Klammerkarte, Baumtabelle, Organigramm. Marker, Notizen, Beziehungen (Querverbindungen mit Beschriftung). |
| Freeplane | Wolken um Teilbäume, Zusammenfassungsklammern über Geschwister, freie Pfeilverbindungen mit Label, Icon-Stapel, Einklappen. |
| Coggle, MindMeister, Miro | Querverbindungen, Bilder und Icons im Knoten, Notizen, Hyperlinks. |
| Markmap | Markdown-Inhalte im Knoten: Fett, Code, Formeln, Links, Checkboxen. Einklappen bis Tiefe n. |
| Mermaid | Formmarker in der Syntax: `((Kreis))`, `(gerundet)`, `[eckig]`, `{{Sechseck}}`, `))Wolke((`, `)Bang(`. Icons per `::icon()`, Klassen per `:::`. |
| PlantUML | Seite per Präfix, kastenlose Knoten per `_`, Farbe inline `[#Orange]`. |
| TikZ mindmap | Kreisknoten je Ebene, organische, sich verjüngende Äste, Farbe läuft vom Ast in die Nachkommen. |

Quellen: xmind.com/blog/diverse-types-of-mind-maps, freemind.sourceforge.io/wiki (Edge, Arrow_link), mermaid.js.org/syntax/mindmap.html, plantuml.com/mindmap-diagram, tikz.dev/library-mindmaps, github.com/dundalek/markmap.

## 2. Visuelle Stile aus den Vorlagenbildern

Die drei Bilder brauchen, in absteigender Häufigkeit:

- **Kreisknoten** mit fester Größe je Tiefe (Bubble Tree) oder an den Text angepasst (Design-Thinking-Bild). Heute sind Kästen immer Rechtecke mit Radius. Ein Theme-Feld `shape: "circle" | "ellipse" | "rect"` und ein `size`-Array je Tiefe für feste Durchmesser.
- **Ring statt Füllung** für einzelne Blätter, also Füllung je Knoten überschreibbar, nicht nur je Theme.
- **Farbverlauf nach Tiefe** innerhalb eines Astes, dunkel an der Wurzel, hell an den Blättern. Heute nur eine Aufhellung für alle Kästen.
- **Icon oder Bild im Knoten**, etwa der Wassertropfen über dem Titel. Mit einem `icon:`-Feld an `branch()` und im Titel ein kleiner Inhaltsaufbau.
- **Kastenloser Text an Zweigen** (Wasserkreislauf-Bild): Blätter hängen als Text an kurzen Stichen, die aus einem gemeinsamen Stamm abzweigen. Das ist eine eigene Kantenführung (`edge: "comb"`), die den Stammpunkt je Elternknoten kennt.
- **Organisch verjüngte Äste** nach Buzan und TikZ: dick am Elternknoten, dünn am Kind, als gefüllte Fläche statt als Linie.
- **Hintergrundfarbe** hinter der ganzen Karte.

## 3. Verbindungen jenseits des Baums

Alle Werkzeuge außer den reinen Text-Syntaxen haben Querverbindungen. Für
brainroot heißt das:

- Knoten brauchen eine **Adresse**. Vorschlag: `branch(..., id: "foto")`, in Listen ein Marker wie `Fotolyse <foto>`.
- `links: (link("foto", "atp", label: [liefert], arrow: true, dash: "dashed"),)` zeichnet eine Kurve über die Kästen hinweg. sprig macht es genau so.
- **Klammern** über mehrere Geschwister mit Beschriftung (Freeplane-Zusammenfassung, XMind-Klammerkarte) und **Wolken** um Teilbäume sind mit den vorhandenen Koordinaten aus dem Layout gut machbar.

Damit lassen sich Concept Maps mit beschrifteten Kanten setzen, solange die
Grundstruktur ein Baum bleibt. Ein echter Graph mit mehreren Eltern braucht
ein anderes Layout und gehört nicht in dieses Paket.

## 4. Unterricht

Das Schule-Ökosystem hat einen Lösungsmechanismus (`loesungen: "keine" |
"sofort" | "folgend" | "seite"`), Punkte und Erwartungshorizont. Eine Mindmap
sollte sich dort einklinken statt etwas Eigenes zu erfinden:

- **Lückenkarte**: `branch([Fotolyse], blank: true)` zeichnet den Kasten leer, in der Lösung gefüllt. Varianten: nur Blätter leer, Zufallsauswahl, Kasten mit Unterstrich zum Eintragen.
- **Punkte je Knoten** für die Bewertung von Schülerkarten, summierbar wie in `aufgaben`.
- **Schrittweises Aufdecken** in typstage: Äste als Schritte anmelden, so dass eine Karte sich beim Vortrag Ast für Ast aufbaut.
- **Hervorhebung** einzelner Fachbegriffe unabhängig von der Astfarbe.
- **Formeln und Bilder** in Knoten gehen vermutlich schon, weil Knoten Content sind. Prüfen und im Handbuch zeigen.
- **Barrierefreiheit**: Alternativtext für die Karte, mit Typst 0.14 PDF-Tags.
- **Leistung**: Bei sehr großen Karten wird das Messen im `context` spürbar. Messen und im Handbuch eine Größenordnung nennen.

## 5. Nachbardiagramme

| Diagramm | Passt | Fehlt | Nutzen Schule |
| --- | --- | --- | --- |
| Klassifikationsbaum, Taxonomie (Stoffe, Reinstoffe, Gemische) | ja, `down` | nur Beispiele | hoch |
| Cluster, Wortigel, Spinnendiagramm | ja, `radial` einstufig | Doku | hoch |
| Organigramm | fast, `blocks` und `elbow` | Ränge auf gleicher Höhe über alle Äste | mittel |
| Entscheidungsbaum, Baumdiagramm (Stochastik) | Struktur ja | Kantenbeschriftung (ja/nein, Wahrscheinlichkeit), Rautenform | hoch |
| Syntaxbaum | fast, `down` | Blätter auf einer Grundlinie | mittel |
| Fishbone (Ishikawa) | nein | eigene Anordnung: Rückgrat mit schrägen Rippen | mittel |
| Klammerkarte (brace map) | Struktur ja | Klammer als Kantenstil | mittel |
| Sitemap, Baumkarte | ja | nichts | niedrig |
| Concept Map, Argument Map | nur mit Querverbindungen | Kantenbeschriftung, Adressen | hoch |
| Dendrogramm, Sunburst, Doppelblase, Flussdiagramme, Placemat, KWL | nein | anderes Modell | eigene Pakete |

## ToDos, nach Nutzen je Aufwand

Stand: alle 18 sind in 0.2.0 umgesetzt; die Listen-Syntax kennt die Knotenoptionen noch nicht.

Aufwand: S bis zu einem Nachmittag, M ein bis zwei Tage, L mehr.

1. **Icon und Bild im Knoten** (`icon:` an `branch`, im Titel Content). S.
2. **Formeln, Bilder, Links in Knoten prüfen und dokumentieren.** S.
3. **Hintergrundfarbe** der Karte. S.
4. **Hervorhebung** einzelner Knoten (`mark: true` oder eigene Farbe je Knoten, Füllung überschreibbar). S.
5. **Lückenkarte mit Lösung** über den Lösungsmechanismus des Ökosystems (`blank:`). M.
6. **Kreis- und Ellipsenform** als Theme-Feld `shape`, mit fester Größe je Tiefe für Bubble Trees. M.
7. **Farbverlauf nach Tiefe** innerhalb eines Astes. S bis M.
8. **Kantenbeschriftung** an Baumkanten, Grundlage für Entscheidungs- und Baumdiagramme. M.
9. **Querverbindungen** mit Adressen, Label und Pfeil. L.
10. **Klammern über Geschwister und Wolken um Teilbäume.** M.
11. **Punkte je Knoten** für Bewertungen. S.
12. **Schrittweises Aufdecken** mit typstage. M.
13. **Organisch verjüngte Äste** als gefüllte Flächen. M bis L.
14. **Kammzweige** für kastenlose Blätter wie im Wasserkreislauf-Bild. L.
15. **Fishbone-Anordnung.** M.
16. **Ränge ausrichten** für Organigramme (`align-levels: true`). M.
17. **Alternativtext** für die Karte. S.
18. **Leistungsmessung** bei großen Karten, Grenze im Handbuch. S.

Nicht vorgesehen: Sunburst und Dendrogramm (Datenvisualisierung), Flussdiagramme und Doppelblase (kein Baum), Einklappen (ohne HTML-Interaktivität nur als Stub sinnvoll).

## Vorschlag für 0.2.0

Die Punkte 1 bis 8: sie decken die drei Vorlagenbilder bis auf die
Kammzweige ab, bringen die Lückenkarte für den Unterricht und legen mit der
Kantenbeschriftung den Grund für Baumdiagramme in der Stochastik.
Querverbindungen und Klammern wären der Kern von 0.3.0, dazu Fishbone und
die Ausrichtung der Ränge.
