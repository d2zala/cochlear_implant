function resulting_sound = cosine_16k_sampling(frequency, duration)
    x_values = 0:(1/16000):duration;
    resulting_sound = cos(2*pi*frequency*x_values);
end
