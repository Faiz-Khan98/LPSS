%% LPC & Frequency Response

function [lpc_coeff, freq_res_values_db, freq_res_freqs, peaks_freqs, peaks] = LPC_func(speech_t,lpc_order,freq_scale,sampling_freq)

lpc_coeff = lpc(speech_t,lpc_order);
[freq_res_values, freq_res_freqs] = freqz(1 , lpc_coeff , length(freq_scale), sampling_freq);
freq_res_values_db = 20*log10(abs(freq_res_values));
peaks = islocalmax(freq_res_values_db);
peaks_freqs = freq_res_freqs(peaks);
peaks = freq_res_values_db(peaks);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%