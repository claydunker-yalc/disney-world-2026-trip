# Disney World Trip

A lightweight, static trip page modeled after [`nola-trip`](https://github.com/claydunker-yalc/nola-trip): one HTML itinerary, a photo carousel driven by `photos/manifest.json`, and a resize script for adding optimized photos later.

Live site: https://claydunker-yalc.github.io/disney-world-2026-trip/

## Structure

```text
index.html              # main itinerary page
photos/                 # committed, web-optimized carousel images
photos/manifest.json    # ordered list consumed by the carousel
photos-raw/             # local-only full-resolution originals; ignored by git
scripts/resize-photos.sh
trip-updates.md         # running inbox for details/photos to add as the trip evolves
```

## Update-as-we-go workflow

This repo is meant to be updated incrementally as plans firm up and photos come in.

### Quick details update

1. Add or edit the relevant day card in `index.html`.
2. Commit and push:

   ```bash
   git add index.html README.md trip-updates.md
   git commit -m "Update Disney itinerary details"
   git push
   ```

3. GitHub Pages will redeploy automatically from `main`.
4. Verify the live page: https://claydunker-yalc.github.io/disney-world-2026-trip/

### Photo update

1. Drop original `.jpg` / `.jpeg` photos into `photos-raw/`.
2. Run:

   ```bash
   ./scripts/resize-photos.sh
   ```

3. Commit the optimized photos and manifest:

   ```bash
   git add photos/ photos/manifest.json
   git commit -m "Add Disney trip photos"
   git push
   ```

The carousel reads `photos/manifest.json`, so adding/removing photos should not require editing `index.html`.

## Itinerary editing

Edit the day cards in `index.html`. Each day uses:

```html
<section class="day" data-date="YYYY-MM-DD">
  <div class="day-header">
    <div class="day-title">Day name</div>
    <div class="day-date">Month day</div>
  </div>
  <div class="blocks">
    <div class="block">
      <div class="block-time">Time</div>
      <div class="block-content">
        <h3>Stop title</h3>
        <p>Address, notes, reservation info, etc.</p>
      </div>
    </div>
  </div>
</section>
```

## What to send Donn

When updating from chat, send any mix of:

- dates / park days
- flight or driving details
- resort info
- dining reservations
- Lightning Lane priorities
- showtimes / fireworks plans
- notes like “put this in the ideas section”
- photo files to add to the carousel

Donn can then update `index.html`, process photos, commit, push, and verify the GitHub Pages URL.
