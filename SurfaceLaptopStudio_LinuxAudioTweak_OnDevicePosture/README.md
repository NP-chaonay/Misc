** Important Annoucement: This project is still in active however notes that my SLS right speaker is in broken state (treble sound not work but mid-range work), so from now on (18/7/22) I will only do test/tweak by using left speaker. And any testing/tweaking config that tested from only left speaker will be placed in Only1CH folder. I mostly sure that it is hardware problem not firmware/driver.

**Purpose**: The Linux audio on Surface Laptop Studio's Laptop Speaker is working good-quality (as soon as it playing as 48kHz, see below why) just without good software DSP for optimize audio for each device posture when playing to laptop speaker, this will resolve the problem of sound that is not like what to hear on Windows by imitate that SW-DSP. This don't have to alter driver-side, just require much (maybe also including reverse engineering of it) audio engineering which including knowledge on audio digital processing.

**Target**: Imitate SW DSP that process RAW audio to optimize with each 4 device postures: laptop/slate/tablet/lid-closed. So the final audio tweak should not under/over-tuned the target. We not meant to mainly do a bass boost or cystalizing the audio, the main objective is to imitate audio that come from Windows SW DSP as similar as possible. **Noted that I target to imitate Windows audio with audio enhancement** (it may related to device's speaker optimization) **enabled not Dolby Atmos enabled** (it just an surround virtualization with additional EQ, the EQ does not work well and may not related to device speaker optimization, maybe just an additional option that allow user to adjust EQ, since Realtek EQ is not adjustable (or it is hidden))

**Important**:
- I target on imitate Windows audio (mainly accurate on instruction and then accurate on what we hear) with audio enhancment for laptop speaker turned on, but Dolby Atmos is turned off. So you have to do followings on Windows if you want to compare that one:
  - Disable Dolby Atmos: not just turned off in spatial sound, but you have to instal Dolby Access and disable at the settings too.
    - Noted that you have to re-disable if you have do Windows Update, or when there is appearance of notification about "Dolby Atmos is ready to use for".
  - Enable audio enhancement for laptop speaker: Settings > System > Sound (maybe, if no then Audio) > At section Output > Speaker > Audio Enhancement
  - Ensure that no 3rd party audio enhancment enabled including spatial audio, I want only OEM audio enhancment to be enabled except Dolby Atmos
- _"mainly accurate on instruction and then accurate on what we hear"_: I mean that we need to ensure that we using most correct/accurate audio processing instruction, but there may be some exception on this to allow audio to be more like on Windows-side, however if possible and it is good to do, audio processing instuction must be correct/accurate. 
- On Linux, you have to set laptop speaker sample rate to 48kHz (see https://github.com/linux-surface/linux-surface/wiki/Surface-Laptop-Studio#poor-sound-quality-when-playing-on-laptop-speaker-on-441khz-sample-rate), or else you cannot correctly imitate Windows audio cause it has a problem about internal driver. 
- If possible, comparing and testing and tweaking on highest volume as possible (as you feel free to do, if volume is too low too do then it is better to wait for its time)
- Remember that
  - EQ is not everything for our target / so EQ is not enough
  - Doing regular EQ may worse final audio output, especially additive EQ that without properly audio cliping handling or reducing of over-amped audio.

**How you can contribute**
- If you have >=2 of SLS, you can boot one with Windows and one with Linux, in this way, you can compare how it sounds different and do tweaking based on what you listen.
- If you have very-good/studio microphone instead, you can using that to compare instead of above.
- If you have very good knowledge on what I mentioned, I welcome contribution on my repo which consist of audio-tweaking configuration.
- Read Important first.
- Feel free to talk about this through issues or PR or discussion tab of the repo (with category of SLS). Feel free to tell if something is not matched with Windows side

**Tips**

- For PulseEffects: see README of PulseEffects
- You may try using file from old commit in case you think it is better, I may update them, and the newer maybe worse.
- Feel free to open discussion of this repo (with category of SLS) to talk about this
- (extra) To do things like headphone virtualization (it is not HRTF which transform >2ch into virtual-surrounding-sound stereo (or what we called binaural audio)), Dolby Atmos is not work (or work not good enough) for H.V. of stereo-ch digital audio. So at least you could using Crossfeed and Stereo Tools to do this job instead of Dolby Atmos, which works better. For audio effect that converting >2ch into binaural audio that existed in Dolby Atmos, maybe idk about the related audio plugins on Linux. Pls do research for that instead.
**Remarks**
- My song used as reference for settings config: (noted that settings is not adjusted from else referenced song other than this)
  - Pink noise (maybe good for EQ tweaking)
  - https://www.youtube.com/watch?v=kvAfmYNtugQ (Dolby most watched and have audio content that useful for testing)
  - https://www.youtube.com/watch?v=Yo3qc7FIBlQ (EQ test audio)
  - Since EQ can affect much on binaural audio, so also using them as reference
    - https://www.youtube.com/watch?v=IUDTlvagjJA
    - https://www.youtube.com/watch?v=91BUM3WhCfo
    - https://www.youtube.com/watch?v=3txhT2ncNOU
    - https://www.youtube.com/watch?v=u163wC6mP2A
    - https://www.youtube.com/watch?v=BOa0zQBRs_M
- Any method welcomed, even it using (abnormal) RAM/CPU/GPU/Disk, just do on my target, that is it.
- These files except specify here, consider as lazy adjustment. If anyone have better adjustment can do a PR.
- in laptop state, seem like I got EQ in shape of sine curve (normal sine curve that starts at y=0 start by going up and down...)
- On Windows SW DSP, seem to be no audio effects that processing one channel cause affect on another channel, so using crossfeed / stereo wide may not accurate to what Windows SW DSP do.
- These configuration is not stable, so are changed in the future at anytime
- For who very very interesting of reverse engineering bytecode, SLS use EQ volume data from ```(Registry)/HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\<some number on my system is 0002 maybe differ on others>\EQVol\DATBUFFERS\DATBUFFER03_0<0 to 3>```, for more information see README on folder ```OEMData```
