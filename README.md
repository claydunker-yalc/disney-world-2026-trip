# Disney World Trip

A lightweight, static trip page modeled after [`nola-trip`](https://github.com/claydunker-yalc/nola-trip): one HTML itinerary, a photo carousel driven by `photos/manifest.json`, and a resize script for adding optimized photos later.

## Structure

```text
index.html              # main itinerary page
photos/                 # committed, web-optimized carousel images
photos/manifest.json    # ordered list consumed by the carousel
photos-raw/             # local-only full-resolution originals; ignored by git
scripts/resize-photos.sh
```

## Adding photos

1. Drop original `.jpg` / `.jpeg` photos into `photos-raw/`.
2. Run:

   ```bash
   ./scripts/resize-photos.sh
   ```

3. Commit the generated files in `photos/` and updated `photos/manifest.json`.

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
