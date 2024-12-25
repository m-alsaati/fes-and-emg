close all
clear all

%% Initializations
% Load all relevent files and, if necessary, save the components of them
% into variables

datadir = ('D:\Documents\Fourth Year (Final year... maybe)\BME 705\BME 705 matlab stuff\Lab 1\FESfatigue_data1.mat')
Data = load("FESfatigue_data1.mat");

force30_1 = (Data.force30_1);
force30_1 = force30_1(1600:88200-1);

force30_2 = (Data.force30_2);

force30_3 = (Data.force30_3);
force30_3 = force30_3(1450:88050-1);

t1 = (0:length(force30_1)-1)/1000;

force60_1 = (Data.force60_1);
force60_1 = force60_1(50:86450-1);

force60_2 = (Data.force60_2);
force60_2 = force60_2(1450:87850-1);

force60_3 = (Data.force60_3);

t2 = (0:length(force60_1)-1)/1000;

%define the three sampling frequencies for each data set
fs = 1000;

sig_avg30 = zeros(86600,1);
for i = 1:length(force30_1)
    sig_avg30(i,1) = force30_1(i,1) + force30_2(i,1) + force30_3(i,1);
end
sig_avg30 = sig_avg30/3;

hold on;

plot(t1,force30_1)
plot(t1,force30_2)
plot(t1,force30_3)
plot(t1, sig_avg30)
grid
xlabel('Time (s)');
ylabel('Force (N)');
title('Plot of Force Measurements Under 30 Hz Stimulation');

hold off;

sig_avg60 = zeros(86400,1);
for i = 1:length(force60_1)
    sig_avg60(i,1) = force60_1(i,1) + force60_2(i,1) + force60_3(i,1);
end
sig_avg60 = sig_avg60/3;

figure;
hold on;

plot(t2,force60_1)
plot(t2,force60_2)
plot(t2,force60_3)
plot(t2, sig_avg60)
grid
xlabel('Time (s)');
ylabel('Force (N)');
title('Plot of Force Measurements Under 60 Hz Stimulation');

hold off;
