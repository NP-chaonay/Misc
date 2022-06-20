
**Purpose**: The Linux audio on Surface Laptop Studio's Laptop Speaker is working good-quality (as soon as it playing as 48kHz, see below why) just without good software DSP for optimize audio for each device posture when playing to laptop speaker, this will resolve the problem of sound that is not like what to hear on Windows by imitate that SW-DSP. This don't have to alter driver-side, just require much (maybe also including reverse engineering of it) audio engineering which including knowledge on audio digital processing.

**Target**: Imitate SW DSP that process RAW audio to optimize with each 4 device postures: laptop/slate/tablet/lid-closed. So the final audio tweak should not under/over-tuned the target. We not meant to mainly do a bass boost or cystalizing the audio, the main objective is to imitate audio that come from Windows SW DSP as similar as possible.

**How you can contribute**
- If you have >=2 of SLS, you can boot one with Windows and one with Linux, in this way, you can compare how it sounds different and do tweaking based on what you listen.
- If you have very-good/studio microphone instead, you can using that to compare instead of above.
- If you have very good knowledge on what I mentioned, I welcome contribution on my repo which consist of audio-tweaking configuration.

**Remarks**
- These files except specify here, consider as lazy adjustment. If anyone have better adjustment can do a PR.
- in laptop state, seem like I got EQ in shape of sine curve (normal sine curve that starts at y=0 start by going up and down...)
