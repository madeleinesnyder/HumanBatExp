% Synchronize reward with cameras
% MCS 10/1/20

% Note: change this into a function

%%%%%%%% Pick date, os, session %%%%%%%%%%
day = '201006';
%day = datestr(now,30); today = today(3:8);

% Pick OS (If PC, check that drive is mounted as the letter in line 22)
os_var = 'mac';

% Pick session
session = '6';

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

%load reward parameters and eventfile

%load micfile wav
micfiletype = strcat('*','mic1','*','.wav');
micfiles = dir(fullfile(rew_root,micfiletype)); 
mic1_file = [rew_root filesep micfiles(end).name];
[y_mic1,Fs_mic1] = audioread(mic1_file);
num_ch_mic1 = size(y_mic1,2);

%load ttl file wav
ttlfiletype = strcat('*','Task_ttl','*','.wav');
ttlfiles = dir(fullfile(rew_root,ttlfiletype)); 
ttl_file = [rew_root filesep ttlfiles(end).name];
[y_ttl,Fs_ttl] = audioread(ttl_file);
num_ch_ttl = size(y_ttl,2);

%load dca file wav
dcafiletype = strcat('*','dca','*','.wav');
dcafiles = dir(fullfile(rew_root,dcafiletype)); 
dca_file = [rew_root filesep dcafiles(end).name];
[y_dca,Fs_dca] = audioread(dca_file);
num_ch_dca = size(y_dca,2);

%load parameter file
paramfiletype = strcat('*','param','*','.txt');
paramfiles = dir(fullfile(rew_root,paramfiletype)); 
param_file = [rew_root filesep paramfiles(end).name];
pfid = fopen(param_file);
tline = fgetl(pfid);
while ischar(tline)
    disp(tline)
    tline = fgetl(pfid);
end
fclose(pfid);

%load event file
eventfiletype = strcat('*','event','*','.txt');
eventfiles = dir(fullfile(rew_root,eventfiletype)); 
event_file = [rew_root filesep eventfiles(end).name];
efid = fopen(event_file);
tline = fgetl(efid);
stored_event_lines = {};
while ischar(tline)
    disp(tline)
    tline = fgetl(efid);
    stored_event_lines{end+1} = tline;
end
fclose(efid);

%load decawave matfile
dcamatfiletype = strcat('decawave','*',session,'.mat');
dcamatfiles = dir(fullfile(dca_root,dcamatfiletype)); 
dca_matfile = [dca_root filesep dcamatfiles(end).name];
load(dca_matfile);

% Find all the camera files in dir
dirlist = dir(cam_root);
num_camera_frames = size(dirlist,1);

%ttl pulses per camera frame (how many ttls are sent during a single
%exposure)
% 66 FPS is the rate of frame capture. 
% The exposure is active for 0.015s. The exposure is active at 66Hz. The
% MOTU samples at 192kHz. 
ttl_train_start = find(y_ttl>0.45);
ttl_start = ttl_train_start(1);

% Align the reward, decawave, and camera TTL
RDC = [y_mic1,y_ttl,y_dca];

% Align the events to RDCi
% We know MOTU samples at 192kHz (192000 Hz). 
% The timestamp is "seconds after the start".
% The timestamp*192000 gives the sample at which that event occurred.
MOTU_FS = 192000; %wav_index = zeros(1,size(stored_event_lines,2));
for i=1:size(stored_event_lines,2)-1
    split_line = split(stored_event_lines{i});
    bb_timestamp = str2double(split_line{2});
    led_timestamp = str2double(split_line{2})-str2double(split_line{6});
    bb_wav_index(i) = bb_timestamp*MOTU_FS;
    led_wav_index(i) = led_timestamp*MOTU_FS;
end

% Plot the reward events (beam breaks and led cues)
figure(); hold on; plot(RDC); 
for i=1:size(stored_event_lines,2)-1
    xline(bb_wav_index(i),'Color','r');
    xline(led_wav_index(i),'Color','g');
end

% Plot the decawave x movement 







