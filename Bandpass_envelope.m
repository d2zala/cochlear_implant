%takes in AudioSpecs type and returns frequencies and envelope for the
%frequency

function [frequencies, envelopes] = Bandpass_envelope(audio_data)
    Fs = 16000; %all are 16000 samples/second
    
    N   = 20;   % Order
    %Logarithmically Spaced (Greenwood Like)
    %Fc1 = [118 166 232 325 456 638 894 1253 1755 2459 3444 4825 7500];
    
    %Spatially Evenly Spaced Based on Greenwood Function (Exponential)
    minPos = 0.08171808122;
    maxPos = 0.8058976263;
    channels = 24;
    positions = minPos:(maxPos-minPos)/(channels+1):maxPos;
    Fc1 = 165.4 * (10 .^ (2.1*positions) - 0.88);
    
    %Concentrated in Low Frequencies
    %Fc1 = [100 124.9331805 152.398059 182.6517023 233.8883181 272.4164261 386.7320783 575.6798118 1090.510905 1972.839731 3484.994234 4607.305804 6076.557803 8000];
    
    %Frequency Evenly Spaced from 100 to 8000
    %Fc1 = [100 707.6923077 1315.384615 1923.076923 2530.769231 3138.461538 3746.153846 4353.846154 4961.538462 5569.230769 6176.923077 6784.615385 7392.307692 8000];
    
    Hds = dfilt.df2sos.empty; %empty array of the designed filter
    
    frequencies = [];
    for i = 1:channels %iterate through cutoff frequencies to create filter
        h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1(i), Fc1(i+1), Fs);
        Hd = design(h, 'butter');
        Hds(end+1) = Hd;
        frequencies(end+1) = sqrt(Fc1(i)*Fc1(i+1)); %geometric mean of the frequencies
    end

    filtered_sounds = [];
    for i = 1:length(Hds)
        filtered_sounds(i,:) = filter(Hds(i),audio_data);
    end

    rectified_signals = []; %empty array to store rectified signals
    for i = 1:length(Hds)
       rectified_signals(i,:) = abs(filtered_sounds(i,:));
    end

    N  = 2;    % Order
    Fc = 400;  % Cutoff Frequency
    h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
    Hd = design(h, 'butter');
    enveloped_signals = []; %empty array to store enveloped signals
    for i = 1:length(Hds)
      enveloped_signals(i,:) = filter(Hd,rectified_signals(i,:));
    end

    envelopes = enveloped_signals;
end
    
