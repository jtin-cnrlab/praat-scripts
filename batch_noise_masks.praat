# batch_noise_masks.praat
# Jessica Tin
# 28 Aug 2018
#
# Batch script for creating noise masks. Created for TFTA.
# Selects a random clip of noise (left channel) of duration 1900ms, normalizes clip
# to 65dB (for 0dB SNR), adds a 200ms ramp up and down, and saves the noise clip.
# Outputs one of these noise files for each recording in the input directory.
#
# Uses code from: GetDuration.praat, Batch_RMS_Amplitude_Normalize.praat,
# extract_part.praat, Ramp_Up_And_Down.praat

form Batch Noise Masks
	comment Input directory (exclude final '/')
	sentence inputDir ./
	comment Output directory (exclude final '/')
	sentence outputDir ./noise
	comment Noise file
	sentence noise ./noise/PinkNoise.wav
endform

Read from file... 'noise$'
Extract one channel: 1
noiseSound$ = selected$("Sound")
select Sound 'noiseSound$'
noiseDuration = Get total duration

Create Strings as file list... list 'inputDir$'/*.wav
numberOfFiles = Get number of strings

for ifile from 1 to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile

	# clip noise to 1900ms (1500s + 200ms ramp up and down)
	noiseStart = randomUniform(0, noiseDuration - 1.9)
	noiseEnd = noiseStart + 1.9
	select Sound 'noiseSound$'
	Extract part... noiseStart noiseEnd rectangular 1 yes
	;Write to WAV file... 'outputDir$'/noise_'fileName$'_clipped.wav

	# normalize to 65dB
	Scale intensity... 65.0
	;Write to WAV file... 'outputDir$'/noise_'fileName$'_normalized.wav

	# add 200ms linear amplitude ramp up and down
	# .2s at 44100Hz = 8820 cols
	Formula... if (col < 8820) then self * (col / 8820) else if (col > (ncol - 8820)) then self * ((ncol - col) / 8820) else self fi fi
	;Write to WAV file... 'outputDir$'/noise_'fileName$'_ramped.wav

	Write to WAV file... 'outputDir$'/noise_'fileName$'
endfor

;select all
;Remove
