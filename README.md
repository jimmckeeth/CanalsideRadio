# Radio Streaming App

Based on [radiosai by immadisairaj](https://github.com/immadisairaj/radiosai). It's been simplified and adapted to work for [Canalside Radio](https://www.thecanalsideradio.com/). Curreltny it only has one stream with the multistreaming and offline functions disabled for now.

## Overview

* __Smooth:__ The app is built to keep a smooth user experience. One can change the streams they want to listen to with ease by just sliding the panel up and selecting the new stream.
* __Seamless Listening:__ It is capable of running in the background until the app is removed from the process. Listen to your favourite radio stream with just one click after opening the app (an option to set the favourite stream at the start of the app)
* __Media Control:__ It can handle the audio options from a handset to a headset, from lock screen notifications to earphones button click. It also pauses when another player starts and doesn't interrupt any incoming notifications.
* __Dark Theme:__ The app also comes with dark theme. One can change the theme they want from settings.
* __Split Screen:__ The app is suitable for split screen. Operate this app while doing work in a different app.
* __Schedule:__ Look at the radio schedule of different streams from within the app. One can see and listen to the different media present in the schedule by clicking one them.
* __Search:__ Searching through out the Radio Sai audio is now possible from the app. Once can search by filtering through category or streamed date. Listening to the audio from the search is also possible now in the app.
* __Media Player:__ A new media player which is capable of playing the media seamlessly. Sharing the link to the media, adding/removing from playing queue, shuffling the queue, repeat mode, and other functions are present in the media player. Drawback of the player is the playing queue is cleared when radio is played or when the player is stopped.
* __Free without ads:__ The app is free for all and will remain the same further. No ads are shown in the app. This is thanks to Radio Sai Global Harmony for providing the content without any charge. Like the Sai Organization, we believe in selfless service and do not expect anything in return.
* __Open Source:__ The source code of the app is open-source and will remain the same in future.
* __File Permissions:__ File write permission is requested only to save images . One can deny these permissions from the settings.

## Features

| Feature                            |  Android |   iOS  |
| -------                            | :-------:| :-----:|
| background audio                   | ✔️       | ✔️    |
| headset clicks                     | ✔️       | ✔️    |
| play/pause/seek                    | ✔️       | ✔️    |
| fast forward/rewind                | ✔️       | ✔️    |
| repeat/shuffle mode                | ✔️       | ✔️    |
| skip next/prev                     | ✔️       | ✔️    |
| notifications/control center       | ✔️       | ✔️    |
| light/dark theme                   | ✔️       | ✔️    |
| starting with fav stream           | ✔️       | ✔️    |
| share media links                  | ✔️       | ✔️    |
| splash screen/launch screen        | ✔️       | ✔️    |
| app links                          | ✔️       |        |

## Radio Player Flow

```
Stop State -> Play in app screen (user action) -> Play State
Stop State -> Change Radio Stream (user action) -> Changes Radio Stream -> Stop State
Play State -> Change Radio Stream (user action) -> Stop State -> Changes Radio Stream -> Play State
Play State -> Pause in app screen (user action) -> Stop State

Play State -> Pause in notification (user action) -> Pause State
Play State -> Stop in notification (user action) -> Stop State
```

## Architecture

Most of the main features use bloc architecture using providers and streams. The usage of this architecture helps the app no to completely refresh but just helpful for updating the needed components smoothly.

```bash
lib
├───audio_service   # audio service related handlers
│   └── notifiers
├───bloc            # business logic files related to screens
│   ├───media
│   ├───radio
│   ├───radio_schedule
│   └───settings
├───constants       # constants
├───helper          # helper classes
├───screens         # all screens
│   ├── audio_archive
│   ├───media
│   ├───media_player
│   ├───radio
│   ├───radio_schedule
│   └───settings
│       └───general
└───widgets         # widgets related to screens
    ├───radio
    └───settings
```
_Above is generated using "tree" command inside lib/_

Thanks to the Open Source community for providing such great libraries and framework which was very helpful in building the application.

## License

This project is licensed under the GNU General Public License V2, see the [LICENSE.md](https://github.com/immadisairaj/radiosai/blob/main/LICENSE.md) for more details.
