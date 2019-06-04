% combine_wavs.m
% Jessica Tin
% 28 Aug 2018
%
% Combines noise clips and word recordings. Centers word within noise.
% Created for TFTA.

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

    pad = floor((size(noise, 1) - size(word, 1))/2);
    padded_word = padarray(word, pad);

    % if word array length was odd, the padding is 1 short
    if size(padded_word, 1) ~= size(noise, 1)
        padded_word = padarray(padded_word, 1, 'post');
    end

    word_noise = noise + padded_word;

    audiowrite(strcat(transcription_dir, transcription_prefix, word_wav), word_noise, Fs);
end
