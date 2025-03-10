#  My Process

## Using AudioKit to make a simple synth
I started this whole process by creating a really simple synth with a couple of notes. Using AudioKit, I used raw frequencies to create a basic interface of 5 notes and a slider that played all frequencies. The raw frequencies were drawn from an Oscillator() object from inside AudioKit

I tried to make my own keyboard interface but it was seriously really ugly so it's all in the folder Synth (not used) in case you want to look at it but it sucks. AudioKit has a built-in keyboard called AKKeyboard but I was not able to get it to work so this is me making my own.

I ended up going back to a simple button format. This worked when I created 3 different types of scales, pentatonic, major, and minor. These were all still using raw frequency values and using math (thanks GPT) to convert them all into scales across 3 octaves.

I ran into issues when I incorporated recording and playback. Musical time works really differently from regular code and human time. there was a big delay in playback and it was because I was manually creating time stamps at the same time that the note was being played. At this point I realized it was necessary to use **MIDI NOTES** instead of raw frequency values. AudioKit has a LOT of built-in MIDI features, which helps to keep everything in time with each other. It also allows the user to manipulate the time with BPM and time signature (ex: 4/4, 3/4, 7/5)

I decided to switch gears. Instead of learning the MIDI protocol, I focused on JSON storage. Whenever I play a melody, I'm always annoyed because I don't remember which notes I played if I want to recreate it. So that's what we're gonna make. 

Thank you:
- Luisa Pereira's Code of Music Class -> really helped me understand how MIDI notes and musical timing works
- John Henry for showing me how to get started with AudioKit and import CookbookCommon
