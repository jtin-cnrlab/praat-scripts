# batch_noise_masks.praat
# Jessica Tin
# 25 Jul 2018
#
# Batch script for creating noise masks. Created for TFTA.
# Reads in a recording, selects a random clip of noise 400ms longer than the
# recording, normalizes clip to 65dB, adds a 20ms ramp up and down, and saves
# the noise clip.
#
# Uses code from: GetDuration.praat, Batch_RMS_Amplitude_Normalize.praat,
# extract_part.praat, Ramp_Up_And_Down.praat

form Batch Noise Masks
	comment Input directory (exclude final '/')
	sentence inputDir ./
	comment Output directory (exclude final '/')
	sentence outputDir ./generalization
	comment Noise file
	sentence noise ./PinkNoise.wav
endform

Read from file... 'noise$'
noiseSound$ = selected$("Sound")
select Sound 'noiseSound$'
noiseDuration = Get total duration

Create Strings as file list... list 'inputDir$'/*.wav
numberOfFiles = Get number of strings

for ifile from 1 to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile

	# clip noise to length of sound + 0.4 (for 200ms padding at beginning and end)
	Read from file... 'inputDir$'/'fileName$'
	sound$ = selected$("Sound")
	select Sound 'sound$'
	wordDuration = Get total duration
	noiseStart = randomUniform(0, noiseDuration - 0.2 - wordDuration)
	noiseEnd = noiseStart + wordDuration + 0.4
	select Sound 'noiseSound$'
	Extract part... noiseStart noiseEnd rectangular 1 yes
	;Write to WAV file... 'outputDir$'/noise_'sound$'_clipped.wav

	# normalize to 65dB
	Scale intensity... 65.0
	;Write to WAV file... 'outputDir$'/noise_'sound$'_normalized.wav

	# add 20ms linear amplitude ramp up and down
	# .02s at 44100Hz = 882 cols
	Formula... if (col < 882) then self * (col / 882) else if (col > (ncol - 882)) then self * ((ncol - col) / 882) else self fi fi
	;Write to WAV file... 'outputDir$'/noise_'sound$'_ramped.wav

	Write to WAV file... 'outputDir$'/noise_'sound$'.wav
endfor

;select all
;Remove
