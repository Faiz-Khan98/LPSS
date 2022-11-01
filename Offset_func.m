%% Offset

function offset_speech_t = Offset_func(speech_t,offset_t,sampling_freq)

offset_n = max((offset_t / 1000) * sampling_freq,1) ;
offset_speech_t = speech_t(offset_n : end);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%