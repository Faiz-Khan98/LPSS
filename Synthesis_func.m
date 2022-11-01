%% Synthesis

function synthesised_speech = Synthesis_func(lpc_coeff, fundamental_freq, sampling_freq, synthesised_speech_t)

required_samples = (synthesised_speech_t / 1000) * sampling_freq;
impulse_train = zeros(1,required_samples);   
impulse_train(1:round(sampling_freq/fundamental_freq):end)=1;
synthesised_speech = filter(1, lpc_coeff, impulse_train);

figure(5) % plot impulse train
hold on
plot(impulse_train,'Color',[0 0.4470 0.7410]);
t = title('Impulse Train');
ax = gca;
ax.TitleHorizontalAlignment = 'left';
t.Color = [0.6350 0.0780 0.1840];
xlabel('Samples(n)')
ylabel('Amplitude-Fx(n)')
hold off

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%