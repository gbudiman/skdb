# Seven Knights Database (skdb)

Rails application demo at http://skdb.herokuapp.com

Try: http://skdb.herokuapp.com/compare/shane/lina/rachel/eileene/alice

Bugs? Problems? Use [Issue Trackers](https://github.com/gbudiman/skdb/issues)

## Screenshot

1. Search anything<br />
<img src="public/readme_img/search.png" alt="Search Anything" width="256" target="_skdb"/>
<img src="public/readme_img/tabular.png" alt="Search Anything" width="256" target="_skdb"/>

2. Compare heroes' skills and stats<br />
<img src="public/readme_img/compare_table.png" alt="Compare Table" width="640" target="_skdb"/>

3. Synergies and duplicates<br />
<img src="public/readme_img/stack_table.png" alt="Stack Table" width="640" target="_skdb"/>

## Limitation
- Scoped to GA release, currently only 6* heroes
- No hero portraits yet
- Partial hero stats (SPD included since 0.2.0. The rest will follow pretty soon)
- Some skill attributes have not been labeled properly (need to use localization instead of hardcoding)
- Need better symbols for attributes. Any designers out there?
- No small-screen (mobile-phone) support yet. Low priority as of now
- No support for IE (probably never will, use it at your own risk)

## Technical Specification
- Support PostgreSQL and MySQL
