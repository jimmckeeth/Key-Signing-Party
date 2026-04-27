#let bcc-teal = rgb("#4eb9b4")
#let bcc-teal-dark = rgb("#258985")
#let bcc-slate = rgb("#4f5357")
#let bcc-bluegray = rgb("#9aadba")
#let bcc-ink = rgb("#202326")
#let bcc-muted = rgb("#5c656d")
#let bcc-paper = rgb("#fbfcfd")
#let bcc-rule = rgb("#d8e1e7")
#let bcc-warn = rgb("#b45f06")
#let bcc-ok = rgb("#1f7a4d")

#let pill(label, fill: bcc-teal, color: white) = box(
  inset: (x: 7pt, y: 3pt),
  radius: 3pt,
  fill: fill,
  text(size: 7.6pt, weight: "bold", fill: color, upper(label)),
)

#let callout(title, body, kind: "note") = {
  let color = if kind == "warning" { bcc-warn } else if kind == "success" { bcc-ok } else { bcc-teal-dark }
  block(
    width: 100%,
    inset: 9pt,
    radius: 4pt,
    stroke: (left: 3pt + color, rest: 0.8pt + bcc-rule),
    fill: rgb("#ffffff"),
  )[
    #text(size: 9pt, weight: "bold", fill: color)[#title]
    #v(4pt)
    #body
  ]
}

#let stepbox(number, title, body) = grid(
  columns: (22pt, 1fr),
  column-gutter: 8pt,
  align: (center, top),
  box(
    width: 20pt,
    height: 20pt,
    radius: 10pt,
    fill: bcc-teal,
    align(center + horizon, text(size: 8pt, weight: "bold", fill: white)[#number]),
  ),
  block[
    #text(size: 10.2pt, weight: "bold", fill: bcc-slate)[#title]
    #v(2pt)
    #body
  ],
)

#let checklist(items) = {
  for item in items {
    grid(
      columns: (14pt, 1fr),
      column-gutter: 5pt,
      align: (left, top),
      text(size: 8pt, fill: bcc-teal-dark)[[ ]],
      item,
    )
    v(3pt)
  }
}

#let command(body) = block(
  width: 100%,
  inset: 7pt,
  radius: 3pt,
  fill: rgb("#f0f4f7"),
  stroke: 0.6pt + rgb("#d5dde3"),
  text(font: ("Consolas", "Courier New"), size: 8pt, fill: rgb("#1d2930"), body),
)

#let compact-table(..rows) = table(
  columns: (30%, 70%),
  inset: 5pt,
  stroke: 0.5pt + bcc-rule,
  table.header(
    text(weight: "bold", fill: bcc-slate)[Field],
    text(weight: "bold", fill: bcc-slate)[What to record],
  ),
  ..rows,
)

#let bcc-doc(body, title: "Key Signing Party", subtitle: "", audience: "", docdate: "Boise Code Camp") = {
  set document(title: title, author: "Boise Code Camp")
  set page(
    paper: "us-letter",
    margin: (x: 0.62in, y: 0.62in),
    fill: bcc-paper,
    header: context {
      if counter(page).get().first() > 1 [
        #text(size: 8pt, fill: bcc-muted)[#title]
        #h(1fr)
        #text(size: 8pt, fill: bcc-muted)[#docdate]
      ]
    },
    footer: [
      #line(length: 100%, stroke: 0.5pt + bcc-rule)
      #v(3pt)
      #text(size: 7.5pt, fill: bcc-muted)[Fingerprint verification happens in person. Keyservers and files are distribution tools, not trust anchors.]
      #h(1fr)
      #text(size: 7.5pt, fill: bcc-muted)[Page #context counter(page).display()]
    ],
  )
  set text(font: ("Segoe UI", "Arial"), size: 9.4pt, fill: bcc-ink, lang: "en")
  set par(justify: true, leading: 0.56em)
  set list(indent: 10pt, body-indent: 4pt, marker: ([--], [--]))
  set enum(indent: 11pt, body-indent: 5pt)
  show link: set text(fill: bcc-teal-dark)
  show heading.where(level: 1): it => {
    v(11pt)
    text(size: 15pt, weight: "bold", fill: bcc-slate, it.body)
    v(2pt)
    line(length: 100%, stroke: 1pt + bcc-teal)
    v(5pt)
  }
  show heading.where(level: 2): it => {
    v(7pt)
    text(size: 10.8pt, weight: "bold", fill: bcc-teal-dark, it.body)
    v(2pt)
  }
  show raw: set text(font: ("Consolas", "Courier New"), size: 8pt)

  block(width: 100%, inset: (bottom: 0pt))[
    #grid(
      columns: (1fr, auto),
      align: (left, top),
      [
        #text(size: 23pt, weight: "bold", fill: bcc-slate)[#title]
        #v(3pt)
        #text(size: 13pt, weight: "semibold", fill: bcc-teal-dark)[#subtitle]
        #h(20pt)
        #pill(audience)
      ],
      [
        #align(right)[
          #image("../images/BoiseCodeCamp-logo.png", width: 1.5in)
        ]
      ],
    )
  ]
  body
}
