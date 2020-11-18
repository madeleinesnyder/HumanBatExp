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

%% Read in ttl data
% Find the files you want
filetype = strcat('*',day,'*','ttl','*');
dirlist = dir(fullfile(rew_root,filetype)); 
ttl_wav = [rew_root filesep dirlist(which_micfile).name];

[y_ttl,Fs_ttl] = audioread(mic1_wav);
num_ch = size(y_mic1,2);

% Plot the mic data to make sure it's recorded
dt = 1/Fs_ttl;
t_ttl = 0:dt:(length(y_ttl)*dt)-dt;
figure(); hold on;
title('Raw Amplitude of TTL');
plot(t_ttl,y_ttl); xlabel('Seconds'); ylabel('Amplitude');

%% Read in camera data

vd = VideoReader([avi_root filesep 'session' session '.avi']);
video = read(vd,1);
read(vd, Inf);
vd.NumberOfFrames






