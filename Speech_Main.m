%% Linear Predictive Speech Synthesizer
% _EEEM030 Assignment 1_

%% Function List
%
% * Offset_func.m
% * Segment_func.m
% * FFT_func.m
% * LPC_func.m
% * Cepstrum_func.m
% * Synthesis_func.m

%% Constants

%close all; clear all ;clc;
speech = 'hod_f'; % file name
[original_speech_t,sampling_freq]=audioread(strcat(speech,'.wav'));
speech_t = original_speech_t;
segment_t = 100; % time segment in ms
offset_t = 20; %  offset in ms
lpc_order = 30; % no. of LPC coefficients
annotation_str = ""; % annotation strings 
formants_i = 3; % display first 3 formant frequencies
cepstrum_threshold = 0.05; % cutoff threshold for cepstrum
quefrency_threshold = 50; % cutoff threshold for quefrency
synthesised_speech_t = 1000; % synthesised speech length in ms
w_number = 5; % number of windows for spectrogram
w_overlap = 2; % overlap in ms
synthesised_w_number = 5; % number of windows for spectrogram
synthesised_w_overlap = 2; % overlap in ms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing

%%
% *Offset & Segment*
speech_t = Offset_func(speech_t,offset_t,sampling_freq);
speech_t = Segment_func(speech_t,segment_t,sampling_freq);

figure(1) % plot speech segment
hold on
plot(speech_t,'Color',[0 0.4470 0.7410])
t = title(speech,'Interpreter','none');
ax = gca;
ax.TitleHorizontalAlignment = 'left';
t.Color = [0.6350 0.0780 0.1840];
xlabel('Samples(n)')
ylabel('Amplitude-Speech(n)')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Model Estimation

%%
% *FFT*
speech_fft = FFT_func(speech_t,length(speech_t));

figure (2) % plot frequency response for speech signal and LPC filter
hold on
freq_scale = sampling_freq*(0:(length(speech_t)/2))/length(speech_t);
orig_freq_plot = plot(freq_scale,20*log10(abs(speech_fft)),'Color',[0 0.4470 0.7410]);
orig_freq_plot.LineWidth = 0.5;
t = title({'PSD of'; speech},'Interpreter','none');
ax = gca;
ax.TitleHorizontalAlignment = 'left';
t.Color = [0.6350 0.0780 0.1840];
xlabel('Frequenzy (Hz)')
ylabel('Magnitude (dB)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% *LPC & Freq Response*
[lpc_coeff, freq_res_values_db, freq_res_freqs, peaks_freqs, peaks] = LPC_func(speech_t,lpc_order,freq_scale,sampling_freq);

lpc_freq_plot = plot(freq_res_freqs, freq_res_values_db);
lpc_freq_plot.LineWidth = 2;
lpc_freq_plot.Color = [0.9290 0.6940 0.1250]; 


peaks_plot = plot(peaks_freqs, peaks, 'o','Color',[0.6350 0.0780 0.1840]); %Display first 3 formant frequencies
for i = 1:formants_i 
    text(peaks_freqs(i),peaks(i),{strcat('F',num2str(i))},'VerticalAlignment','bottom','FontSize',10);
    str = (strcat('F',num2str(i),' = ',num2str(round(peaks_freqs(i),2)),' Hz'));
    annotation_str = cat(2,annotation_str,str);
end
annotation_str(cellfun('isempty',annotation_str)) = []; % remove empty cells from annotation_str
a = annotation('textbox','String',annotation_str,'EdgeColor','none','Color',[0.6350 0.0780 0.1840]);
a.Position = [0.13,0.155,0.1,0.1]; %annotation position
peaks_plot.MarkerSize = 5;
peaks_plot.LineWidth = 2;

grid
lgd = legend('Original Speech', 'Spectral Envelope', 'Formant Frequencies');
legend('boxoff');
lgd.Title.String = strcat('Order = ',num2str(lpc_order)) ;
t = title(strcat(' Frequency Response ','(', speech,' Segment) = ',num2str(segment_t),'ms'));
t.Color = [0.6350 0.0780 0.1840];
ax = gca;
ax.TitleHorizontalAlignment = 'left';
hold off

figure(3) % plot pole zero plot
zplane(1,lpc_coeff);
t = title('Pole-Zero Plot');
t.Color = [0.6350 0.0780 0.1840];
ax = gca;
ax.TitleHorizontalAlignment = 'left';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% *Cepstrum & Fundamental Frequency*
fundamental_freq = Cepstrum_func(speech,speech_t, cepstrum_threshold, quefrency_threshold, sampling_freq);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Synthesis

%%
% *Impulse Train & Synthesis*
synthesised_speech = Synthesis_func(lpc_coeff, fundamental_freq, sampling_freq, synthesised_speech_t);

figure(6) % plot original and synthesised vowel segments
hold on
synthesised_speech_plot = synthesised_speech(10:1000);
speech_plot = speech_t(10:1000);
t = tiledlayout(2,1);
xlabel(t,'Samples(n)')

ax1 = nexttile; % Top (plot of Original Vowel Segment) 
plot(ax1,speech_plot,'Color',[0 0.4470 0.7410])
ylabel(ax1,'Amplitude-Speech(n)')
t1 = title(ax1,'Original Vowel Segment');
t1.Color = [0.6350 0.0780 0.1840];
ax1.TitleHorizontalAlignment = 'left';

ax2 = nexttile; % Bottom (plot of Synthesised Vowel Segment)
plot(ax2,synthesised_speech_plot,'Color',[0 0.4470 0.7410])
ylabel(ax2,'Amplitude-SynthSpeech(n)')
t2 = title(ax2,'Synthesised Vowel Segment');
t2.Color = [0.6350 0.0780 0.1840];
ax2.TitleHorizontalAlignment = 'left';
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% *Spectrogram*
figure(7) % plot spectrogram of original and synthesised vowel segments
tiledlayout(1,2)

sample_overlap = round((w_overlap / 1000) * sampling_freq); % Original Vowel Spectrogram
window_size = round((length(speech_t) + (w_number) * sample_overlap)/(w_number));
ax1 = nexttile;
spectrogram(speech_t,window_size,sample_overlap, [], sampling_freq,'yaxis');
t1 = title(ax1,'Original Vowel Segment');
t1.Color = [0.6350 0.0780 0.1840];
ax1.TitleHorizontalAlignment = 'left';
ylabel(ax1,'Frequency (kHz)')
colormap turbo

sample_overlap = round((synthesised_w_overlap / 1000) * sampling_freq); % Synthesised Vowel Spectrogram
window_size = round((length(synthesised_speech) + (synthesised_w_number) * sample_overlap)/(synthesised_w_number));
ax2 = nexttile;
spectrogram(synthesised_speech,window_size,sample_overlap, [], sampling_freq,'yaxis');
t2 = title(ax2,'Synthesised Vowel Segment');
t2.Color = [0.6350 0.0780 0.1840];
ax2.TitleHorizontalAlignment = 'left';
ylabel(ax2,'Frequency (kHz)')
colormap turbo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% *Audio Play & Write*

ap1 = audioplayer(synthesised_speech,sampling_freq,16); 
ap2 = audioplayer(original_speech_t,sampling_freq,16); 
play(ap2);
pause(2);
play(ap1);
%audiowrite(strcat('synthesised_',speech,'_',num2str(segment_t),'_',num2str(lpc_order),'.wav'),synthesised_speech,sampling_freq);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%