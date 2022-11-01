%% Segment

function speech_segment = Segment_func(speech_t, segment_t, sampling_freq)

segment_n = (segment_t / 1000) * sampling_freq ;
segment_n = min(segment_n, length(speech_t));
speech_segment = speech_t(1 : segment_n);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%