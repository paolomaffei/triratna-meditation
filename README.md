Triratna Buddhist Community Meditation App
---
GPL version 3 licensed.

Getting Started
---

Coffeescript + sass w/ live reloading.

```
npm install
bower install
gulp watch
git clone https://github.com/paolomaffei/mobile-meditation.git www/coffee/lib/mobile-meditation
```

In a different terminal window,
```
ionic serve
```

Troubleshooting
---
When adding a new .coffee file, you may have to kill the gulp process and start it again for it to pick up the new coffee file (and therefore compile it into application.js)

New .coffee files should be in subdirectories of www/ so that gulp watch is sure to concatenate module.coffee (which contains module 'starter.controllers' definition) before using that module

When the .apk file generated from `ionic build android` is bigger than 100mb (which it may very well be with the .mp3 files not included in this repo), the android emulator may refuse to load with error INSUFFICIENT STORAGE.

If you get an error on running `gulp watch`, try `npm install -g gulp-cli`.

Gulp sometimes doesn't pick up changes, restart gulp, change something and make sure ionic serve shows `JS changed:   www/js/application.js`