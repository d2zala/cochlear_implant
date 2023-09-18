%read audio file to mono, sampled at 16000 Hz
[audio_data, sample_rate] = read_to_mono_and_downsample("Audio/Test-files/control/5-words-female/conclude-about-easy-sunshine-christmas.wav");
%[audio_data, sample_rate] = read_to_mono_and_downsample("Canon in D Major.mp3");


%apply the filters and envelope detection
[frequencies, envelopes] = Bandpass_envelope(audio_data);

final_sound = zeros(1,length(envelopes));
for i=1:length(frequencies)
    cosine_vals = cosine_16k_sampling(frequencies(i), length(envelopes(i,:))/16000);
    final_sound = final_sound + (cosine_vals(1:length(envelopes)) .* envelopes(i,:));
end

soundsc(final_sound, 16000);

audiowrite("cochlear_implant_output.wav", final_sound, 16000);