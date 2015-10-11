Triratna Buddhist Community Meditation App
---
GPL version 3 licensed.

Getting Started
---

Coffeescript + sass w/ live reloading.

```
npm install
gulp watch
```

In a different terminal window,
```
ionic serve
```

Known problems
---
When the .apk file generated from 'ionic build android' is bigger than 100mb (which it may very well be with the .mp3 files not included in this repo), the emulator may refuse to load

Troubleshooting
---

If you get an error on running `gulp watch`, try `npm install -g gulp-cli`.