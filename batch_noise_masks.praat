# batch_noise_masks.praat
# Jessica Tin
# 17 Aug 2018
#
# Batch script for creating noise masks. Created for TFTA.
# Selects a random clip of noise of duration 1540ms, normalizes clip to 65dB (for
# 0dB SNR), adds a 20ms ramp up and down, and saves the noise clip. Outputs one
# of these noise masks for each recording in the input directory.
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
noiseSound$ = selected$("Sound")
select Sound 'noiseSound$'
noiseDuration = Get total duration

Create Strings as file list... list 'inputDir$'/*.wav
numberOfFiles = Get number of strings

for ifile from 1 to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile

	# clip noise to 1540ms (1500ms + 20ms ramp up and down)
	noiseStart = randomUniform(0, noiseDuration - 1.54)
	noiseEnd = noiseStart + 1.54
	select Sound 'noiseSound$'
	Extract part... noiseStart noiseEnd rectangular 1 yes
	;Write to WAV file... 'outputDir$'/noise_'fileName$'_clipped.wav

	# normalize to 65dB
	Scale intensity... 65.0
	;Write to WAV file... 'outputDir$'/noise_'fileName$'_normalized.wav

	# add 20ms linear amplitude ramp up and down
	# .02s at 44100Hz = 882 cols
	Formula... if (col < 882) then self * (col / 882) else if (col > (ncol - 882)) then self * ((ncol - col) / 882) else self fi fi
	;Write to WAV file... 'outputDir$'/noise_'fileName$'_ramped.wav

	Write to WAV file... 'outputDir$'/noise_'fileName$'
endfor

;select all
;Remove
