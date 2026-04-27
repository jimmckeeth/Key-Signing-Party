#import "typst/bcc-keysigning-style.typ": *

#set document(title: "Key Signing Party - Day-Of Organizer Checklist", author: "Boise Code Camp")
#set page(
  paper: "us-letter",
  margin: (x: 0.5in, y: 0.42in),
  fill: bcc-paper,
)
#set text(font: ("Segoe UI", "Arial"), size: 8.2pt, fill: bcc-ink, lang: "en")
#set par(leading: 0.45em)
#set list(indent: 9pt, body-indent: 3pt, marker: [--])
#show raw: set text(font: ("Consolas", "Courier New"), size: 7pt)

#let tight-title(body) = {
  v(5pt)
  text(size: 10.8pt, weight: "bold", fill: bcc-slate, body)
  v(1pt)
  line(length: 100%, stroke: 0.8pt + bcc-teal)
  v(3pt)
}

#let mini-check(items) = {
  for item in items {
    grid(
      columns: (10pt, 1fr),
      column-gutter: 4pt,
      align: (left, top),
      text(size: 7pt, fill: bcc-teal-dark)[[ ]],
      item,
    )
    v(2pt)
  }
}

#grid(
  columns: (1fr, auto),
  align: (left, top),
  [
    #text(size: 18pt, weight: "bold", fill: bcc-slate)[Key Signing Party]
    #v(1pt)
    #text(size: 10pt, weight: "bold", fill: bcc-teal-dark)[Day-Of Organizer Checklist]
    #h(6pt)
    #pill("Saturday, May 2, 2026")
  ],
  [#image("images/BoiseCodeCamp-logo.png", width: 0.95in)],
)

#v(5pt)
#line(length: 100%, stroke: 1pt + bcc-rule)
#v(5pt)

#block(
  width: 100%,
  inset: 5pt,
  radius: 3pt,
  stroke: (left: 3pt + bcc-teal-dark, rest: 0.6pt + bcc-rule),
  fill: white,
)[#text(weight: "bold", fill: bcc-teal-dark)[Goal:] Keep the room moving. State/federal photo ID + full fingerprint now; sign later.]

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  [
    #tight-title[Setup + Check-In]
    #mini-check((
      [Packets, extras, roster, pens.],
      [Visible sign: "Government photo ID + fingerprint only. Sign later."],
      [Give each attendee a packet; ask them to check their own name/email/fingerprint first.],
      [If entry is wrong or uncertain, mark do-not-verify. Do not correct it at the event.],
    ))

    #tight-title[Opening Script]
    #block(width: 100%, inset: 5pt, radius: 3pt, fill: rgb("#f0f4f7"), stroke: 0.5pt + bcc-rule)[
      #text(size: 7.3pt)[*First: ask everyone to sign or initial their sheet now.* Then: Check current state or federal photo ID, compare the complete fingerprint against the participant's own trusted copy, and mark your sheet only if both match. School IDs and badges are not enough. Skip anything unclear. Do not sign keys here. Report pressure to skip checks.]
    ]

    #tight-title[Run of Show]
    #table(
      columns: (18%, 82%),
      inset: 3pt,
      stroke: 0.45pt + bcc-rule,
      [0:00], [Rules and sheet explanation.],
      [0:05], [Pair up; verify both directions.],
      [0:08], [Rotate one side or move stations.],
      [Repeat], [Continue until complete.],
      [Close], [Explain final bundle and signing later.],
    )

    #tight-title[Watch For]
    #mini-check((
      [Signing at the event: redirect to post-event signing.],
      [Short key IDs: require the full fingerprint.],
      [School IDs, badges, social profiles: not accepted.],
      [Name/email/fingerprint/key problems: mark do-not-verify.],
      [Crowding or rushing: slow the rotation.],
    ))
  ],
  [

    #tight-title[Close + Follow-Up]
    #mini-check((
      [Tell attendees to keep marked sheets and wait for the final bundle.],
      [Collect do-not-verify notes before sending follow-up files.],
      [Exclude do-not-verify entries from any event-verified claims.],
      [Send final package by Mon, May 4, 11:59 PM MT.],
      [Include warning: verify again before signing.],
    ))
  ],
)
