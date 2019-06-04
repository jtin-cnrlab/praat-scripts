% combine_wavs.m
% Jessica Tin
% 27 Aug 2018
%
% Combines noise clips and word recordings for TFTA.

cd /PerrachioneLab/projects/TFTA/Stimuli/'Final transcription clips 65 dB'/
word_files = dir('*.wav');
noise_dir = 'noise/';
noise_prefix = 'noise_';
transcription_dir = 'transcription/';
transcription_prefix = 'transcription_';

for i = 1:length(word_files)
    word_wav = word_files(i).name
    %word_name = extractBefore(word_wav, '.wav')
    [word, Fs] = audioread(word_wav);
    [noise, Fs] = audioread(strcat(noise_dir, noise_prefix, word_wav));

    %audiowrite(strcat(transcription_dir, 'stereo_', word_wav), noise, Fs);

    mono_noise = sum(noise, 2) / 2;
    %audiowrite(strcat(transcription_dir, 'mono_', word_wav), mono_noise, Fs);

    pad = floor((size(noise, 1) - size(word, 1))/2);
    padded_word = padarray(word, pad);

    % if noise array length was odd, the padding is 1 short
    if size(padded_word, 1) ~= size(mono_noise, 1)
        padded_word = padarray(padded_word, 1, 'post');
    end

    word_noise = mono_noise + padded_word;

    audiowrite(strcat(transcription_dir, transcription_prefix, word_wav), word_noise, Fs);
end
