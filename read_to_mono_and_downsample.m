function [audio_data, sample_rate] = read_to_mono_and_downsample(FILE_PATH)
    [audio_data, sample_rate] = audioread(FILE_PATH);
    audio_data_dims = size(audio_data);
    if audio_data_dims(2) == 2
        audio_data = audio_data(:, 1) + audio_data(:, 2);
        %add the two channels together
    end

    if sample_rate > 16000
        audio_data = resample(audio_data, 16000, sample_rate); 
        %down sample by 16Hz/Current sample rate to get final sample rate
        %of 16000
    elseif sample_rate < 16000
        error("Sample rate of audio is less than 16KHz");
    end

    sample_rate = 16000;
end
