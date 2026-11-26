# GIS and Maps
tier: 2 | sources: OpenStreetMap licence and tile usage policy, PostGIS documentation, EPSG and GeoJSON (RFC 7946) conventions | updated: 2026-11-26

## Triggers
- Maps, markers, routes, geocoding, delivery or tracking features, spatial queries, GPS data.
- Not for a plain contact-page map embed with no user data.
## Responsibilities
- Architecture: pick the data source, tile source and geocoder. Build: spatial schema, map UI, imports. Verify: coordinate and quota tests. Handoff: attribution, quota and privacy notes.
## Role-specific rules
1. Know the coordinate system. Store and exchange WGS 84 (EPSG:4326) as longitude, latitude (GeoJSON order). Web tiles use EPSG:3857; convert only for display.
2. Once you query by distance or area, use spatial types with a spatial index, not two float columns. Measure distance in meters, not degrees.
3. OpenStreetMap data is ODbL: show "OpenStreetMap contributors" attribution, and share-alike applies to derived databases (uncertain on edge cases).
4. The public OSM tile server is not for production traffic. Use a tile provider with a free tier, or self-host vector tiles. A provider account or key is G3.
5. Geocoders have quotas and storage terms. Cache results only where the terms allow, and stay inside the free tier (uncertain: check each provider).
6. Location is personal data. Collect the lowest precision that works, ask consent, set a retention time, and never show one user's exact position to another (SKILL.md 6.5).
7. Restrict browser map keys by domain. Never ship server-only keys to the browser.
## Default tool options
- Display: MapLibre GL JS (open source), or Leaflet for simple maps.
- Data: PostGIS, OpenStreetMap extracts (Geofabrik), GeoJSON files for small sets.
- Geocoding: self-hosted Nominatim, or a provider with a free tier; follow its usage policy.
## Checklist
- [ ] CRS written down for each dataset
- [ ] Spatial index exists; a distance query tested on sample data
- [ ] Attribution visible on the map
- [ ] Location retention and consent written down
## Common mistakes
- Swapping latitude and longitude → GeoJSON is lon, lat; test with a known point.
- Calling the geocoder on every page view → batch and cache within the terms.
- Treating degrees as distance → use geography types or project the data.
- Tracking location in the background without a reason → collect only on user action.
## Definition of done
Test points land in the right place, spatial queries use the index (EXPLAIN), attribution shows, and quota and privacy notes are in the runbook.
## Per-stack notes
- PostGIS: `ST_DWithin` on `geography` for radius search, with a GiST index. MySQL has spatial types but fewer functions (uncertain).
- React or Vue: wrap MapLibre in one component and remove the map on unmount.
