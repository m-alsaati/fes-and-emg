close all
clear all

%% Initializations
% Load all relevent files and, if necessary, save the components of them
% into variables

datadir = ('D:\Documents\Fourth Year (Final year... maybe)\BME 705\BME 705 matlab stuff\Lab 1\FStim_data.mat')
Data = load("FStim_data.mat");

stim_train = (Data.stim_train);
force = (Data.force);

fs = 100;
t = (0:length(force)-1)/100;

plot(t,force)
grid
xlabel('Time (s)');
ylabel('Force (N)');
title('Plot of Raw Force Measurements During Stimulation Train');

% figure;
% plot(t, stim_train)

dc_offset = mean(force(1:6000));

force_adj = zeros(19003,1);
for i = 1: length(force)
    force_adj(i,1) = force(i,1) - dc_offset;
end

% figure;
% plot(t,force_adj)

figure;
hold on;

% yyaxis left
plot(t,force_adj)
grid
xlabel('Time (s)');
ylabel('Force (N), Stimulation Amplitude (mA)');
title('Plot of Force Measurements and Stimulation Train');

% yyaxis right
plot(t,stim_train)
% ylabel('Stimulation Amplitude (mA)');

hold off;
