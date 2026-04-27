#import "typst/bcc-keysigning-style.typ": *

#set document(title: "Key Signing Party - At-Event Rules", author: "James McKeeth, Boise Code Camp")
#set page(
  paper: "us-letter",
  margin: (x: 0.52in, y: 0.42in),
  fill: bcc-paper,
)
#set text(font: ("Segoe UI", "Arial"), size: 8.7pt, fill: bcc-ink, lang: "en")
#set par(leading: 0.48em)
#set enum(indent: 10pt, body-indent: 4pt)
#set list(indent: 9pt, body-indent: 3pt, marker: [--])
#show raw: set text(font: ("Consolas", "Courier New"), size: 7.3pt)

#place(top + right, dx: 0pt, dy: -2pt)[
  #image("images/BoiseCodeCamp-logo.png", width: 1.5in)
]

#grid(
  columns: (1fr, 1.38in),
  column-gutter: 12pt,
  align: (left, top),
  [
    #grid(
      columns: (auto, 1fr),
      column-gutter: 12pt,
      align: (left, horizon),
      [#text(size: 18pt, weight: "bold", fill: bcc-slate)[Key Signing Party]],
      [#align(center)[#pill("At-Event Rules & Guidelines")]],
    )
    #v(4pt)
    #text(weight: "bold", fill: bcc-ok)[Do this here:] Check your own entry first, then verify government photo ID + full fingerprint. #linebreak() Mark your sheet. _Do not sign keys at the event._
  ],
  [],
)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  [
    #text(weight: "bold", fill: bcc-teal-dark)[For each person]
    #enum(
      [Use current state/federal photo ID only.],
      [Check ID against *full* printed name.],
      [Compare the _complete_ fingerprint.],
      [Have them read it aloud.],
      [Mark only clear matches.],
      [*Report* any pressure to accept incomplete matches.]
    )
  ],
  [
    #text(weight: "bold", fill: bcc-warn)[Do not]
    #list(
      [Sign keys here.],
      [Trust short key IDs.],
      [Accept school IDs, badges, or social profiles.],
      [Trust files, USB, QR codes, or keyservers.],
      [Sign for anyone you did not verify.],
      [Sign for anyone you are not comfortable signing.]
    )
  ],
)

#v(3pt)
#text(size: 8pt, weight: "bold", fill: bcc-slate)[*Golden rule*: verify in person, verify *again* _after_ import, then sign.]

#line(length: 100%, stroke: 1pt + gray)
