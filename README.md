# Seven Knights Database (skdb)

Rails application demo at http://skdb.herokuapp.com

Try: http://skdb.herokuapp.com/compare/shane/lina/rachel/eileene/alice

Bugs? Problems? Use [Issue Trackers](https://github.com/gbudiman/skdb/issues)

## Screenshot

1. Search by tiers, stats, skills, effects, pretty much anything<br />
<img src="public/readme_img/tiers.png" alt="Search Anything" width="256" target="_skdb"/>
<img src="public/readme_img/tabular.png" alt="Search Anything" width="256" target="_skdb"/>
<img src="public/readme_img/search.png" alt="Search Anything" width="256" target="_skdb"/>

2. Compare heroes' skills, stats, and equip recommendations. Stats are dynamic and scaled to heroes' level and augment<br />
<img src="public/readme_img/compare_table.png" alt="Compare Table" width="640" target="_skdb"/>

3. Synergies and duplicates<br />
<img src="public/readme_img/stack_table.png" alt="Stack Table" width="640" target="_skdb"/>

## Limitation
- Scoped to GA release. Includes all 6* heroes and highest-tiered form for non-6* heros
- No hero portraits yet
- Some skill attributes have not been labeled properly (need to use localization instead of hardcoding)
- Need better symbols for attributes. Any designers out there?
- No small-screen (mobile-phone) support yet. Low priority as of now
- No support for IE (probably never will, use it at your own risk)

## Technical Specification
- Support PostgreSQL and MySQL
