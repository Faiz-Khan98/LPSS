%% Cepstrum & Fundamental frequency

function fundamental_freq = Cepstrum_func(speech,speech_t,cepstrum_mag_threshold,quefrency_threshold,sampling_freq)

cepstrum = rceps(speech_t);
cep_quefrency =(1:length(speech_t));
cepstrum = cepstrum(1:round(length(speech_t) / 2));
cep_quefrency = cep_quefrency(1:round(length(speech_t) / 2));

figure(4) % plot cepstrum & pitch period
cepstrum_plot = plot(cep_quefrency,cepstrum,'Color',[0 0.4470 0.7410]);
cepstrum_plot.LineWidth = 0.5;
grid
xlabel('Quefrency')
ylabel('Real Cepstrum(x[n])')
xlim([0 length(speech_t) / 2])
t = title(strcat('Speech Cepstrum ','(',speech,')'),'Interpreter','none');
t.Color = [0.6350 0.0780 0.1840];
ax = gca;
ax.TitleHorizontalAlignment = 'left';
hold on

cep_que_thresh = quefrency_threshold < cep_quefrency; % Cut below quefrency threshold
cep_quefrency = cep_quefrency(cep_que_thresh);
cepstrum = cepstrum(cep_que_thresh);

cep_mag = islocalmax(cepstrum); % Find local maxima
cep_quefrency = cep_quefrency(cep_mag);
cepstrum = cepstrum(cep_mag);

cepstrum(cepstrum < cepstrum_mag_threshold) = 0; % Cut below cepstrum value threshold
pitch_period = cep_quefrency(cepstrum == max(cepstrum));
fundamental_freq = 1 / (pitch_period / sampling_freq);

maxima_plot = plot(pitch_period, cepstrum(cepstrum == max(cepstrum)), 'o');
maxima_plot.MarkerSize = 5;
maxima_plot.LineWidth = 2;
  
text(cep_quefrency(cepstrum == max(cepstrum)),cepstrum(cepstrum==max(cepstrum)),{strcat('Pitch Period =',num2str(pitch_period))},'VerticalAlignment','bottom');
annotation_str = {'F_0 = 1 \div P_0/F_S' ,(strcat('F_0 = ',num2str(round(fundamental_freq,2)),' Hz'))};
a = annotation('textbox','String',annotation_str,'Color',[0.6350 0.0780 0.1840]);
a.Position = [0.755,0.81,0.1,0.1]; 
a.FontWeight = 'bold';
a.BackgroundColor = [0.9290 0.6940 0.1250];
a.FaceAlpha = 0.7;
a.HorizontalAlignment = 'center' ;
a.VerticalAlignment = 'middle' ;
hold off

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%