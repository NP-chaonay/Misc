
**Purpose**: The Linux audio on Surface Laptop Studio's Laptop Speaker is working good-quality (as soon as it playing as 48kHz, see below why) just without good software DSP for optimize audio for each device posture when playing to laptop speaker, this will resolve the problem of sound that is not like what to hear on Windows by imitate that SW-DSP. This don't have to alter driver-side, just require much (maybe also including reverse engineering of it) audio engineering which including knowledge on audio digital processing.

**Target**: Imitate SW DSP that process RAW audio to optimize with each 4 device postures: laptop/slate/tablet/lid-closed. So the final audio tweak should not under/over-tuned the target. We not meant to mainly do a bass boost or cystalizing the audio, the main objective is to imitate audio that come from Windows SW DSP as similar as possible. **Noted that I target to imitate Windows audio with audio enhancement** (it may related to device's speaker optimization) **enabled not Dolby Atmos enabled** (it just an surround virtualization with additional EQ, the EQ does not work well and may not related to device speaker optimization, maybe just an additional option that allow user to adjust EQ, since Realtek EQ is not adjustable (or it is hidden))

**Important**:
- I target imitate Windows audio with audio enhancment for laptop speaker turned on, but Dolby Atmos is turned off. So you have to do followings on Windows if you want to compare that one:
  - Disable Dolby Atmos: not just turned off in spatial sound, but you have to instal Dolby Access and disable at the settings too.
  - Enable audio enhancement for laptop speaker: Settings > System > Sound (maybe, if no then Audio) > At section Output > Speaker > Audio Enhancement
  - Ensure that no 3rd party audio enhancment enabled, I want only OEM audio enhancment to be enabled except Dolby Atmos
- On Linux, you have to set laptop speaker sample rate to 48kHz (see https://github.com/linux-surface/linux-surface/wiki/Surface-Laptop-Studio#poor-sound-quality-when-playing-on-laptop-speaker-on-441khz-sample-rate), or else you cannot correctly imitate Windows audio cause it has a problem about internal driver. 

**How you can contribute**
- If you have >=2 of SLS, you can boot one with Windows and one with Linux, in this way, you can compare how it sounds different and do tweaking based on what you listen.
- If you have very-good/studio microphone instead, you can using that to compare instead of above.
- If you have very good knowledge on what I mentioned, I welcome contribution on my repo which consist of audio-tweaking configuration.
- Read Important first.

**Remarks**
- These files except specify here, consider as lazy adjustment. If anyone have better adjustment can do a PR.
- in laptop state, seem like I got EQ in shape of sine curve (normal sine curve that starts at y=0 start by going up and down...)
