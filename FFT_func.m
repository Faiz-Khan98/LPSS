%% FFT

function speech_fft = FFT_func(speech_t,speech_length)

speech_fft = fft(speech_t);
speech_fft = abs(speech_fft); 
speech_fft = speech_fft(1:floor(speech_length/2+1));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%