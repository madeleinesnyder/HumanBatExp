% Script to test out analysis of the recorded audio and TTL reads in all _1
% _2 etc in sequence

% Setup. Change these parameters to pull the data you want. 
bat1 = 'Jonnie'; % Clementine
bat2 = 'Polly'; % Ovaltine/Poutine
bat3 = 'Georgia'; % Saltine
bat4 = 'Ringa'; % Valentine

day = '201116'; % Date [yrmoda]
paradigm = 'HLRTask'; %HLRTask, RecOnly, DividedHLRTask...
HLRBat = 'Georgia'; % Clementine, Poutine, Saltine, Valentine, Jonnie, Polly, Georgia, Ringa
session = '4'; 
storage_location = 'server1'; % server1, local, ext_drive...

%% Load in the root paths of the various storage places.
root_save_mic_local = ['C:' filesep 'Users' filesep 'Batman' filesep 'Desktop' filesep 'BatHumanExp' filesep 'box_3' filesep day filesep strcat('session',session)];
root_save_dca_local = ['C:' filesep 'Users' filesep 'Batman' filesep 'Desktop' filesep 'BatHumanExp' filesep 'box_3' filesep day];
root_save_mic_server1 = ['Y:' filesep 'users' filesep 'Madeleine' filesep '2021_BatHumanExp' filesep day filesep 'reward' filesep strcat('session',session)];
root_save_cam_server1 = ['Y:' filesep 'users' filesep 'Madeleine' filesep '2021_BatHumanExp' filesep day filesep 'cam' filesep strcat('session',session)];
root_save_dca_server1 = ['Y:' filesep 'users' filesep 'Madeleine' filesep '2021_BatHumanExp' filesep day filesep 'reward'];

%% Examine the ttl WAV
% Find the ttl files you want
if strcmp(paradigm,'FeedTask')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','ttl','*');
elseif strcmp(paradigm,'HLRTask')
    filetype = strcat(HLRBat,'_',day,'*',paradigm,'*','ttl','*');
elseif strcmp(paradigm,'RecOnly')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','ttl','*');
elseif strcmp(paradigm,'DividedHLRTraining')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','ttl','*');
end  

% Load in the data
if strcmp(storage_location, 'local')
    dirlist = dir(fullfile(root_save_mic_local,filetype)); 
    ttl_wav = [root_save_mic_local filesep dirlist(end).name];
elseif strcmp(storage_location, 'server1')
    dirlist = dir(fullfile(root_save_mic_server1,filetype)); 
    ttl_wav_files = {};
    for i=1:length(dirlist)
        ttl_wav_files{i} = [root_save_mic_server1 filesep dirlist(i).name];
    end
elseif strcmp(storage_location, 'ext_drive')
    disp("Which drive? Configure this!");
end

% Read in the TTL WAV file(s)
y_ttl_full=[]; Fs_ttl_full = [];
for i=1:length(dirlist)
    [y_ttl_tmp,Fs_ttl_tmp] = audioread(ttl_wav_files{i});
    num_ch(i) = size(y_ttl_tmp,2);
    y_ttl_full = [y_ttl_full;y_ttl_tmp];
    Fs_ttl_full = [Fs_ttl_full;Fs_ttl_tmp];
end

% Plot the ttl to make sure it's recorded
dt = 1/sum(Fs_ttl_full); % NOT SURE IF THIS IS RIGHT. COuld just be 19200
dt = 1/Fs_ttl_full(1); % I THINK IT"S JUST 19200 because that's what the MOTU says.....
t_ttl = 0:dt:(length(y_ttl_full)*dt)-dt;
figure(); hold on;
title('Raw TTL Pulse');plot(t_ttl(1:end),y_ttl_full(1:end)); xlabel('Seconds'); ylabel('Amplitude');

%% Examine the actual audio WAV from mic1

% Find the audio files you want
if strcmp(paradigm,'FeedTask')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','mic1','*');
elseif strcmp(paradigm,'HLRTask')
    filetype = strcat(HLRBat,'_',day,'*',paradigm,'*','mic1','*');
elseif strcmp(paradigm,'RecOnly')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','mic1','*');
elseif strcmp(paradigm,'DividedHLRTraining')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','mic1','*');
end

% Load in the data
if strcmp(storage_location, 'local')
    dirlist = dir(fullfile(root_save_mic_local,filetype)); 
    mic1_wav = [root_save_mic_local filesep dirlist(end).name];
elseif strcmp(storage_location, 'server1')
    dirlist = dir(fullfile(root_save_mic_server1,filetype)); 
    mic1_wav = [root_save_mic_server1 filesep dirlist(end).name];
elseif strcmp(storage_location, 'ext_drive')
    disp("Which drive? Configure this!");
end

% Read in the WAV file
[y_mic1,Fs_mic1] = audioread(mic1_wav);
num_ch = size(y_mic1,2);

% Plot the ttl to make sure it's recorded
dt = 1/Fs_mic1;
t_mic1 = 0:dt:(length(y_mic1)*dt)-dt;
figure(); hold on;
title('Raw Amplitude of Microphone 1');
plot(t_mic1,y_mic1); xlabel('Seconds'); ylabel('Amplitude');

%% Examine the dca (Decawave) WAV
% Find the dca files you want
if strcmp(paradigm,'FeedTask')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','dca','*');
elseif strcmp(paradigm,'HLRTask')
    filetype = strcat(HLRBat,'_',day,'*',paradigm,'*','dca','*');
elseif strcmp(paradigm,'DividedHLRTraining')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','dca','*');
end

% Load in the data
if strcmp(storage_location, 'local')
    dirlist = dir(fullfile(root_save_mic_local,filetype)); 
    dca_wav = [root_save_mic_local filesep dirlist(end).name];
elseif strcmp(storage_location, 'server1')
    dirlist = dir(fullfile(root_save_mic_server1,filetype)); 
    dca_wav = [root_save_mic_server1 filesep dirlist(end).name];
elseif strcmp(storage_location, 'ext_drive')
    disp("Which drive? Configure this!");
end

% Read in the WAV file
[y_dca,Fs_dca] = audioread(dca_wav);
num_ch = size(y_dca,2);

% Plot the ttl to make sure it's recorded
dt = 1/Fs_dca;
t_dca = 0:dt:(length(y_dca)*dt)-dt;
figure(); hold on;
title('Raw DCA Signal (Decawave)');
plot(t_dca(1:end),y_dca(1:end)); xlabel('Seconds'); ylabel('Amplitude');

%% Overlay TTL and raw mic amplitude
figure(); hold on;
title('Raw Mic1 Amplitude and TTL');
plot(t_mic1,y_mic1); xlabel('Seconds'); ylabel('Amplitude');
plot(t_ttl(1:end),y_ttl(1:end)); xlabel('Seconds'); ylabel('Amplitude');
%plot(t_dca(1:end),y_dca(1:end)); xlabel('Seconds'); ylabel('Amplitude');

% Plot the end of the recording to make sure the recoding GUI was stopped
% last. 
figure(); hold on; 
title('Raw Mic1 Amplitude and TTL for end of session.');
plot(t_mic1(end-100000:end),y_mic1(end-100000:end)); xlabel('Seconds'); ylabel('Amplitude');
plot(t_ttl(end-100000:end),y_ttl(end-100000:end)); xlabel('Seconds'); ylabel('Amplitude');
%plot(t_dca(end-1000:end),y_dca(end-1000:end)); xlabel('Seconds'); ylabel('Amplitude');

% Plot the beginning of the recording to make sure the recoding GUI was
% started first.
figure(); hold on; 
title('Raw Mic1 Amplitude and TTL for start of session.');
plot(t_mic1(1:100000),y_mic1(1:100000)); xlabel('Seconds'); ylabel('Amplitude');
plot(t_ttl(1:100000),y_ttl(1:100000)); xlabel('Seconds'); ylabel('Amplitude');
%plot(t_dca(end-1000:end),y_dca(end-1000:end)); xlabel('Seconds'); ylabel('Amplitude');

%% Read in the decawave positional data and plot it below 

% Load in the data
if strcmp(storage_location, 'local')
    dcaFile = dir(fullfile(root_save_dca_local,filesep,['decawave_' day '*' session '.mat']));
    deca = load([root_save_dca_local,filesep,dcaFile.name]);
elseif strcmp(storage_location, 'server1')
    dcaFile = dir(fullfile(root_save_dca_server1,filesep,['decawave_' day '*' session,'*']));
    deca = load([root_save_dca_server1,filesep,dcaFile.name]);
elseif strcmp(storage_location, 'ext_drive')
    disp("Which drive? Configure this!");
end

figure(); hold on;
title('Decawave Data');
scatter3(deca.UD.Pos(1,1,:),deca.UD.Pos(2,1,:),deca.UD.Pos(3,1,:),'r');

%% Plot the decawave x and y to make sure the drift is ok. 

figure();
title('Decawave X, Y, and trace');
subplot(2,1,2); hold on;
plot(t_mic1(1:end),y_mic1(1:end)); xlabel('Seconds'); ylabel('Amplitude');
plot(t_ttl(1:end),y_ttl(1:end)); xlabel('Seconds'); ylabel('Amplitude');
plot(t_dca(1:end),y_dca(1:end)); xlabel('Seconds'); ylabel('Amplitude');
subplot(2,2,1); hold on;
title("Decawave X");
plot(squeeze(deca.UD.Pos(1,1,:)));
subplot(2,2,2); hold on;
title("Decawave Y");
plot(squeeze(deca.UD.Pos(2,1,:)));
