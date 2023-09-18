soundFile = 'friday-about-sunshine-sweater-seven.wav';
[y,fs]= audioread(soundFile);

Fs = 16000; % Sampling Frequency
N = 20; % Order
Fc1 = [118 166 232 325 456 638 894 1253 1755 2459 3444 4825 7500]; % First Cutoff Frequency
Hds = dfilt.df2sos.empty; %empty array of the designed filter

for i = 1:12 %iterate through cutoff frequencies to create filter
    h = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1(i), Fc1(i+1), Fs);
    Hd = design(h, 'butter');
    Hds(end+1) = Hd;
end

filtered_sounds = [];
for i = 1:length(Hds)
    filtered_sounds(i,:) = filter(Hds(i),y);
end

figure;
plot(filtered_sounds(1,:));% plotting the lowest channel
figure;
plot(filtered_sounds(12,:));% plotting the highest channel

%Signal Rectification
rectified_signals = []; %empty array to store rectified signals
for i = 1:length(Hds)
    rectified_signals(i,:) = abs(filtered_sounds(i,:));
end

%Envelope Filter Design
Fs = 16000; % Sampling Frequency
N = 2; % Order
Fc = 400; % Cutoff Frequency
h = fdesign.lowpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter');
enveloped_signals = []; %empty array to store enveloped signals
for i = 1:length(Hds)
    enveloped_signals(i,:) = filter(Hd,rectified_signals(i,:));
end

figure;
plot(enveloped_signals(1,:));% plotting the lowest channel
figure;
plot(enveloped_signals(12,:));% plotting the highest channel