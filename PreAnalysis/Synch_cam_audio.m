% Make a video out of the cam frames and the audio
% MCS 10/12/20

% Note: change this into a function

%%%%%%%% Pick date, os, session %%%%%%%%%%
day = '201010';
%day = datestr(now,30); today = today(3:8);

% Pick OS
os_var = 'mac';

% Pick session
session = '10';

% Pick which mic file (there are multiple if the session is long)
which_micfile = 1;

%%%%%%%%%%%% Do not change below %%%%%%%%%

% Set up roots and paths
if strcmp(os_var,'mac')
    root_root = [filesep 'Volumes' filesep 'server1_home'];
elseif strcmp(os,'pc')
    root_root = ['Y:'];
end
root = [root_root filesep 'users' filesep 'Madeleine' filesep '2021_BatHumanExp' filesep day];
cam_root = [root filesep 'cam' filesep 'session',session]; 
rew_root = [root filesep 'reward' filesep 'session',session];
dca_root = [root filesep 'reward' filesep];
avi_root = [root filesep 'cam']; 

%% Read in mic data (note: there may be multiple files)
% Find the files you want
filetype = strcat('*',day,'*','mic1','*');
dirlist = dir(fullfile(rew_root,filetype)); 
mic1_wav = [rew_root filesep dirlist(which_micfile).name];

[y_mic1,Fs_mic1] = audioread(mic1_wav);
num_ch = size(y_mic1,2);

% Plot the mic data to make sure it's recorded
dt = 1/Fs_mic1;
t_mic1 = 0:dt:(length(y_mic1)*dt)-dt;
figure(); hold on;
title('Raw Amplitude of Microphone 1');
plot(t_mic1,y_mic1); xlabel('Seconds'); ylabel('Amplitude');

% Save number of frames you want as a wav (test)
%audiowrite([avi_root filesep 'FirstThousandSession10.wav'],y_mic1,Fs_mic1);

%% Read in ttl data
% Find the files you want
filetype = strcat('*',day,'*','ttl','*');
dirlist = dir(fullfile(rew_root,filetype)); 
ttl_wav = [rew_root filesep dirlist(which_micfile).name];

[y_ttl,Fs_ttl] = audioread(ttl_wav);
num_ch = size(y_ttl,2);

% Plot the mic data to make sure it's recorded
dt = 1/Fs_ttl;
t_ttl = 0:dt:(length(y_ttl)*dt)-dt;
figure(); hold on;
title('Raw Amplitude of TTL');
plot(t_ttl,y_ttl); xlabel('Seconds'); ylabel('Amplitude');

%% Calculate how many mic data points per TTL pulse

% Plot progressive zooms to get an idea of the order of magnitude we are
% looking for for the multiplier
figure(); hold on;
plot(y_ttl(100000:105000));
plot(y_mic1(100000:105000));
figure(); hold on;
plot(y_ttl(1000000:1050000));
plot(y_mic1(1000000:1050000));
figure(); hold on;
plot(y_ttl(10000000:10500000));
plot(y_mic1(10000000:10500000));

% Capture 1 TTL
figure(); hold on;
plot(y_ttl(1006000:1009085));
plot(y_mic1(1006000:1009085));

% Find rising edge. This corrosponds to the exposure time, and then after
% the TTL the frames are being sent to the computer. 

% The number of samples between TTL rising edges is the multiplier for "how
% many audio points per frame"

 %% Take Derivative
dy_ttl = gradient(y_ttl, mean(diff(t_ttl)));               

% Find starting downspike index 
downspike_ix = find(dy_ttl == min(dy_ttl));
true_downspike = downspike_ix;

% Find ending downspike index
y_ttl_end = y_ttl(end-10000000:end);
upspike_ix = find(y_ttl == min(y_ttl_end));
true_upspike = upspike_ix - 80000;

figure(); plot(dy_ttl(downspike_ix-100000:downspike_ix+1000000));

% Find the peaks in this interval.
[dypks,ix] = findpeaks(dy_ttl(downspike_ix-100000:downspike_ix+1000000), 'MinPeakDistance',2000, 'MinPeakHeight',2000);

% Plot these peaks with the actual ttl signal
buffer = zeros(1100000,1);
buffer(ix) = 0.1;
figure(); hold on; plot(y_ttl(downspike_ix-100000:downspike_ix+1000000)); plot(buffer,'*');

% Find the peaks for the WHOLE session. Will take a while
% ix_sess are the MOTU indexes of each video frame. 
[dypks_sess,ix_sess] = findpeaks(dy_ttl(true_downspike:true_upspike), 'MinPeakDistance',2000, 'MinPeakHeight',2000);

%% Read in camera data

vd = VideoReader([avi_root filesep 'session' session '_pyvid.avi']);
vd_e = VideoReader('/Users/madeleinesnyder/Documents/Berkeley/Bats/data/BatHumanExp/201010/cam/session10_pyvid_cvt.mov');
read(vd_e, Inf);

% Get num frames
nFrames = vd_e.NumberOfFrames;

% Get samples per frame
tempdf = [];
for i=2:length(ix_sess)
    tempdf(i) = ix_sess(i)-ix_sess(i-1);
end
SamplesPerFrame = round(mean(tempdf));

% Downsample the camera data spatially


%% Truncate audio data and Downsample to the Video Data Rate

new_audio = y_mic1(true_downspike:true_upspike);
new_audio_ds = downsample(new_audio,SamplesPerFrame);
new_audio_Fs = Fs_mic1/SamplesPerFrame;
% Write the audio to a file in the same dir as the video.
audiowrite('/Users/madeleinesnyder/Documents/Berkeley/Bats/data/BatHumanExp/201010/cam/session10_audio.wav',new_audio_ds,round(new_audio_Fs));













