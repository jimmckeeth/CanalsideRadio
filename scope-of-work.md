# CanalSide Radio Client

Scope of Work

- [x] Android
- [ ] iOS
  - [x] Implemented
  - [ ] Testing

## Core Features

- [x] Live Audio Streaming
- [x] One Play / Pause button
- [x] Pause = stop stream
- [x] Play = reconnect to live broadcast
- [x] No buffering, no resume-from-pause
- [x] Audio continues playing when the app is minimized or the screen is locked
- Stream Source
  - [x] Stream is hosted by Live365
  - [x] Standard listener stream URL (HLS/AAC)
  - [x] App only consumes the stream (no encoder or backend work)
  - [ ] Display current song title / artist if provided by the stream
    - [ ] No metadata in stream
- [x] No playlist history
- [x] No schedules
- [x] Informational display only
- Basic App Sections
  - [x] Listen:
    - [x] live stream + play/pause
  - Contact:
    - [ ] Tap-to-call phone number
      - _no phone number yet_
    - [x] Tap-to-email email address
      - thecanalsideradio@gmail.com
    - [ ] About: static text about the station
      - [ ] Need text to include
    - [ ] Donate: button opens external donation website
      - [ ] Link?
  - Design:
    - [x] Simple, clean UI
    - [x] Station logo
      - [x] colors provided (I pulled the colors from the website since none were provided)
    - [x] No animations or visual effects beyond basic layout

## Explicitly Out of Scope

- Podcasts or on-demand audio
- User accounts or logins
- Push notifications
- Ads or underwriting systems
- Chat, messaging, or forms
- Offline audio
- Program schedules or DJ logic
- Content management system (CMS)
- App Store / Deployment

## App builds prepared for

- Google Play
- Apple App Store (if iOS is included)

No ongoing maintenance included

## Deliverables

- Working mobile app
- Access to GPL source
- Basic notes on
  - Updating stream URL
  - Updating contact info

Guiding Principle

- This is a minimal, launch-ready radio app, not a platform.
- Reliability and simplicity matter more than features.

## TODO

- [x] Include link to GitHub and GPL license in licensing screen
- [x] Add new icon and splash screen
