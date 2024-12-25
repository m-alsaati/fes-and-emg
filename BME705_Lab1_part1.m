%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BME705: Rehabilitation Engineering
% Lab 1: Applications of FES and EMG in Rehabilitation
%
% Created by: Devon Santillo, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Names: 
 
% Student IDs: 
%

close all
clear all

%% Initializations
% Load all relevent files and, if necessary, save the components of them
% into variables

datadir = ('D:\Documents\Fourth Year (Final year... maybe)\BME 705\BME 705 matlab stuff\Lab 1\TA_data1.mat')
Data = load("TA_data1.mat");

EMG = (Data.increase_ta_emg);
Force = (Data.increase_ta_force);

%define the three sampling frequencies for each data set
fs = 2000;

%% Part 1: Introduction to EMG analysis
% separate EMG and force data using the dot operator
EMG = (Data.increase_ta_emg);
Force = (Data.increase_ta_force);

% Define time as a vector
t1 = (0:length(EMG)-1)/2000;

% Processing: 

%1)original graphs
plot(t1, EMG)
grid
xlabel('Time (s)');
ylabel('EMG Potential (mV)');
title('Plot of Raw EMG Signal');

figure;
plot(t1, Force)
grid
xlabel('Time (s)');
ylabel('Force (N)');
title('Plot of Force Measured During Muscle Contraction');

% 2) normalizations
%EMG_norm = rescale(EMG);
EMG_abs = abs(EMG);
Force_abs = abs(Force);

EMG_max = max(EMG_abs);
EMG_norm = EMG/EMG_max;

Force_max = max(Force_abs);
Force_norm = Force/Force_max;

figure;
plot(t1, EMG_norm)
grid
xlabel('Time (s)');
ylabel('EMG Potential (mV)');
title('Plot of Normalized EMG Signal');

figure;
plot(t1, Force_norm)
grid
xlabel('Time (s)');
ylabel('Force (N)');
title('Plot of Normalized Force Data');

%3) rectification; 
EMG_rect = abs(EMG);

figure;
plot(t1, EMG_rect)
grid
xlabel('Time (s)');
ylabel('EMG Potential (mV)');
title('Plot of Rectified EMG Signal');

%4) Filtered EMG signal
fc = 2.5;
%establishing the transfer function of a 4th order butterworth filter
%filtering emg and graphing output

load butterworth.mat;
[b,a] = sos2tf(SOS, G);
butterworth = filter(b,a,EMG_rect);

figure;
plot(t1, butterworth)
grid
xlabel('Time (s)');
ylabel('EMG Potential (mV)');
title('Plot of Rectified and Filtered EMG Signal');

%5) calculating iEMG
EMG_trap = cumtrapz(1/fs, butterworth);

figure;
plot(t1, EMG_trap)
grid
xlabel('Time (s)');
ylabel('EMG Potential (mV)');
title('Plot of Integrated EMG Signal');

%6) Dividing signal into individual contractions
% using the reshape function to evenly split each matrix into even columns
% each column should be a contraction event
EMGr = reshape(butterworth, [30000,10]);
Forcer = reshape(Force_norm, [30000,10]);

%%% This next code is optional to compute the envelopes automatically %%%
%establishing blank arrays to input RMS and median frequency data
EMGr_rms = zeros(10:1);
Forcer_avg = zeros(10:1);

%Arrays 1 and 2 are established as sets of zeros equivalent to the # of
%envelopes

%using a for loop to go through every column of the reshaped EMG matrix

for i = 1:10 %i variable should go from 1 to your the total number of envelopes
    
    %Calculating i-th RMS variable corresponding to i-th column 
    %in reshaped EMG matrix
    % Array1(i) = rms of EMGr(i)
    EMGr_rms(i) = rms(EMGr(1:30000,i));
   
    %plotting the EMG signal with RMS for the i-th column
    %recommended to use 'num2str()' function for a dynamic plot title
    
    %Calculating the corresponding average force for the i-th contraction
    % Array2(i) = rms of EMGr(i)
    Forcer_avg(i) = mean(Forcer(1:30000,i));
end

t2 = (0:30000-1)/2000;

figure;
hold on;

plot(t2, EMGr(1:30000,1))
yline(EMGr_rms(1), '--','RMS');
grid
xlabel('Time (s)');
ylabel('EMG Potential (mV)');
title('Plot of Isolated Contraction With its RMS');
xlim([0 14]);

hold off;

%plot emg vs. force magnitude relationship
figure;
hold on;
for i = 1:10
    scatter(EMGr_rms(i), Forcer_avg(i))
end

grid
xlabel('Average Force (F)');
ylabel('EMG Potential RMS Value (mV)');
title('Plot of Force-EMG Relation');
hold off;
