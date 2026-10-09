from pathlib import Path
from html import escape
out=Path('/home/robot/data201project/data/normalized')
a=[]
a.append('''<svg xmlns="http://www.w3.org/2000/svg" width="1920" height="1080" viewBox="0 0 1920 1080"><style>text{font-family:Arial,Helvetica,sans-serif;fill:#263e53}.edge{fill:none;stroke:#005daa;stroke-width:2.5}.entity{fill:#eaf3f9;stroke:#005daa;stroke-width:3}.attribute{fill:white;stroke:#005daa;stroke-width:2}.relationship{fill:#fff8e4;stroke:#bc870d;stroke-width:2.5}</style><rect width="1920" height="1080" fill="white"/><path d="M1330 0h590v410l-170-100-90 80-130-150-130 80-110-170z M1580 0l110 170 100-90 130 140V0z M1780 390l140 80v310l-130-95-100 60-115-130z" fill="#f8f9fa"/><text x="80" y="103" font-size="52" font-weight="bold" style="fill:#005daa">Initial ER Model: Flight Reliability</text><rect x="80" y="128" width="180" height="9" fill="#e5ad23"/><text x="80" y="177" font-size="25" style="fill:#566b7d">Chen notation: entities, attributes, keys, relationships, and 1:N cardinalities</text>''')
def line(points,double=False):
    if double:
        # Parallel horizontal/vertical segments for required participation.
        a.append(f'<polyline points="{points}" class="edge" transform="translate(0,-4)"/>')
        a.append(f'<polyline points="{points}" class="edge" transform="translate(0,4)"/>')
    else:a.append(f'<polyline points="{points}" class="edge"/>')
def text(x,y,s,size=22,bold=False):
    a.append(f'<text x="{x}" y="{y}" text-anchor="middle" dominant-baseline="middle" font-size="{size}"'+(' font-weight="bold"' if bold else '')+f'>{escape(s)}</text>')
def entity(x,y,name,w=240):
    a.append(f'<rect x="{x-w/2}" y="{y-35}" width="{w}" height="70" class="entity"/>');text(x,y,name,27,True)
def attr(x,y,name,key=False,w=190):
    a.append(f'<ellipse cx="{x}" cy="{y}" rx="{w/2}" ry="29" class="attribute"/>')
    a.append(f'<text x="{x}" y="{y}" text-anchor="middle" dominant-baseline="middle" font-size="22"'+(' text-decoration="underline" font-weight="bold"' if key else '')+f'>{escape(name)}</text>')
def diamond(x,y,name,w=160,h=86):
    a.append(f'<polygon points="{x-w/2},{y} {x},{y-h/2} {x+w/2},{y} {x},{y+h/2}" class="relationship"/>');text(x,y,name,21,True)
# Attribute connectors, below all symbols.
for p in ['270,295 185,242','270,295 430,242','900,295 900,242','1590,295 1460,242','1590,295 1730,242',
          '815,365 700,430','790,365 570,510','800,365 650,580','985,365 1100,430','1010,365 1230,510','1000,365 1150,580',
          '780,760 650,710','780,790 650,840','1710,750 1790,690','1710,790 1790,870']:line(p)
# Airline -> Flight and CalendarDate -> Flight.
line('390,330 500,330');line('660,330 780,330',True)
line('1020,330 1170,330',True);line('1330,330 1470,330')
# Flight -> Route. Vertical parallel lines show total participation of Flight.
line('896,365 896,607');line('904,365 904,607');line('900,693 900,735')
# Route has two relationships to the same Airport, with different roles.
line('1020,750 1080,700 1170,700',True);line('1350,700 1410,700 1470,750')
line('1020,790 1080,840 1170,840',True);line('1350,840 1410,840 1470,790')
# Symbols.
entity(270,330,'Airline');entity(900,330,'Flight');entity(1590,330,'CalendarDate');entity(900,770,'Route');entity(1590,770,'Airport')
diamond(580,330,'Operates');diamond(1250,330,'Occurs on');diamond(900,650,'Follows');diamond(1260,700,'Origin of',180);diamond(1260,840,'Destination of',180)
# Cardinalities are close to their entity ends.
for x,y,s in [(430,310,'1'),(735,310,'N'),(1060,310,'N'),(1418,310,'1'),(925,400,'N'),(925,716,'1'),(1085,675,'N'),(1410,675,'1'),(1085,870,'N'),(1410,870,'1')]:text(x,y,s,25,True)
# Attributes. Key attributes are underlined.
attr(185,213,'AirlineID',True);attr(430,213,'CarrierCode')
attr(900,213,'FlightID',True)
attr(1460,213,'FlightDate',True);attr(1730,213,'DayOfWeek')
attr(700,459,'FlightNumber',w=205);attr(570,539,'DepDelay');attr(650,609,'Cancelled')
attr(1100,459,'TailNumber');attr(1230,539,'ArrDelay');attr(1150,609,'Diverted')
attr(650,710,'Distance');attr(650,840,'RouteID',True)
attr(1790,661,'AirportID',True);attr(1790,899,'AirportCode')
# Notes and legend.
a.append('<text x="80" y="929" font-size="22">All five entities are strong: each has its own key. No weak entity is required by this schema.</text>')
a.append('<text x="80" y="960" font-size="19" style="fill:#566b7d">Selected Flight attributes are shown. The following relational schema slide lists all flight-operation attributes.</text>')
# Compact notation legend.
a.append('<rect x="80" y="985" width="38" height="22" class="entity"/><text x="130" y="1003" font-size="18">Strong entity</text><rect x="295" y="985" width="38" height="22" class="entity"/><rect x="300" y="990" width="28" height="12" fill="none" stroke="#005daa"/><text x="345" y="1003" font-size="18">Weak entity (none)</text><ellipse cx="587" cy="996" rx="26" ry="12" class="attribute"/><text x="625" y="1003" font-size="18">Attribute; underlined = key</text><polygon points="927,996 950,983 973,996 950,1009" class="relationship"/><text x="988" y="1003" font-size="18">Relationship</text><path d="M1165 991h50M1165 1000h50" class="edge"/><text x="1228" y="1003" font-size="18">Total participation</text><text x="1510" y="1003" font-size="18">1:N = one to many</text>')
a.append('<line x1="65" y1="1030" x2="1855" y2="1030" stroke="#005daa" stroke-width="2"/><text x="80" y="1063" font-size="20" style="fill:#005daa">9</text><text x="140" y="1063" font-size="20" style="fill:#005daa">DATA 201 | Group 5</text><text x="1650" y="1060" font-size="32" font-weight="bold" style="fill:#123f9c">SJSU</text><text x="1755" y="1047" font-size="13" style="fill:#123f9c">SAN JOSÉ STATE</text><text x="1755" y="1066" font-size="13" style="fill:#123f9c">UNIVERSITY</text></svg>')
(out/'Initial_Chen_ER_Diagram.svg').write_text('\n'.join(a))
