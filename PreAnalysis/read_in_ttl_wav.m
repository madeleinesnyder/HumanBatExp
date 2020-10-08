% Script to test out analysis of the recorded audio and TTL 

% Setup
bat1 = 'Clementine'; % Silver Falcon
bat2 = 'Ovaltine'; % Optimus Prime
bat3 = 'Saltine'; 
bat4 = 'Valentine';
day = '200930'; % Date [yrmoda]
paradigm = 'RecOnly';
HLRBat = 'Ovaltine';
session = '1';
root_save = ['C:' filesep 'Users' filesep 'Batman' filesep 'Desktop' filesep 'BatHumanExp' filesep 'box_3' filesep day filesep strcat('session',session)];
root_save_dca = ['C:' filesep 'Users' filesep 'Batman' filesep 'Desktop' filesep 'BatHumanExp' filesep 'box_3' filesep day];

%% Examine the ttl WAV
% Find the ttl files you want
if strcmp(paradigm,'FeedTask')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','ttl','*');
elseif strcmp(paradigm,'HLRTask')
    filetype = strcat(HLRBat,'_',day,'*',paradigm,'*','ttl','*');
elseif strcmp(paradigm,'RecOnly')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','ttl','*');
end  
dirlist = dir(fullfile(root_save,filetype)); 
ttl_wav = [root_save filesep dirlist(end).name];

% Read in the WAV file
[y_ttl,Fs_ttl] = audioread(ttl_wav);
num_ch = size(y_ttl,2);

% Plot the ttl to make sure it's recorded
dt = 1/Fs_ttl;
t_ttl = 0:dt:(length(y_ttl)*dt)-dt;
figure(); hold on;
title('Raw TTL Pulse');plot(t_ttl(1:end),y_ttl(1:end)); xlabel('Seconds'); ylabel('Amplitude');

%% Examine the actual audio WAV from mic1

% Find the audio files you want
if strcmp(paradigm,'FeedTask')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','mic1','*');
elseif strcmp(paradigm,'HLRTask')
    filetype = strcat(HLRBat,'_',day,'*',paradigm,'*','mic1','*');
elseif strcmp(paradigm,'RecOnly')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','mic1','*');
end
dirlist = dir(fullfile(root_save,filetype)); 
mic1_wav = [root_save filesep dirlist(end).name];

% Read in the WAV file
[y_mic1,Fs_mic1] = audioread(mic1_wav);
num_ch = size(y_mic1,2);

% Plot the ttl to make sure it's recorded
dt = 1/Fs_mic1;
t_mic1 = 0:dt:(length(y_mic1)*dt)-dt;
figure(); hold on;
title('Raw Amplitude of Microphone 1');
plot(t_mic1,y_mic1); xlabel('Seconds'); ylabel('Amplitude');
%figure; hold on;
%title('Periodogram of Microphone 1');
%plot(psd(spectrum.periodogram,y_mic1,'Fs',Fs_mic1,'NFFT',length(y_mic1)))

%% Examine the dca (Decawave) WAV
% Find the ttl files you want
if strcmp(paradigm,'FeedTask')
    filetype = strcat(bat1(1:2),bat2(1:2),bat3(1:2),bat4(1:2),'_',day,'*',paradigm,'*','dca','*');
elseif strcmp(paradigm,'HLRTask')
    filetype = strcat(HLRBat,'_',day,'*',paradigm,'*','dca','*');
end
dirlist = dir(fullfile(root_save,filetype)); 
dca_wav = [root_save filesep dirlist(end).name];

% Read in the WAV file
[y_dca,Fs_dca] = audioread(dca_wav);
num_ch = size(y_dca,2);

% Plot the ttl to make sure it's recorded
dt = 1/Fs_dca;
t_dca = 0:dt:(length(y_dca)*dt)-dt;
figure(); hold on;
title('Raw DCA Signal (Decawave)');
plot(t_dca(1:end),y_dca(1:end)); xlabel('Seconds'); ylabel('Amplitude');
%figure(); hold on;
%plot(psd(spectrum.periodogram,y_dca,'Fs',Fs_dca,'NFFT',length(y_dca)));

%% Overlay TTL and raw mic amplitude
figure(); hold on;
title('Raw Mic1 Amplitude and TTL and DCA');
plot(t_mic1,y_mic1); xlabel('Seconds'); ylabel('Amplitude');
plot(t_ttl(1:end),y_ttl(1:end)); xlabel('Seconds'); ylabel('Amplitude');
%plot(t_dca(1:end),y_dca(1:end)); xlabel('Seconds'); ylabel('Amplitude');

% Plot the end of the recording to make sure the recoding GUI was stopped
% last. 
figure(); hold on; 
plot(t_mic1(end-100000:end),y_mic1(end-100000:end)); xlabel('Seconds'); ylabel('Amplitude');
plot(t_ttl(end-100000:end),y_ttl(end-100000:end)); xlabel('Seconds'); ylabel('Amplitude');
%plot(t_dca(end-1000:end),y_dca(end-1000:end)); xlabel('Seconds'); ylabel('Amplitude');


%% Read in the decawave positional data and plot it below 
deca = load(strcat(root_save_dca,filesep,'decawave_',day,'_',session,'.mat'));
figure(); hold on;
title('Decawave Data');
scatter3(deca.UD.Pos(1,1,:),deca.UD.Pos(2,1,:),deca.UD.Pos(3,1,:),'r');

%% 
figure();
subplot(2,1,2); hold on;
plot(t_mic1(1:end),y_mic1(1:end)); xlabel('Seconds'); ylabel('Amplitude');
plot(t_ttl(1:end),y_ttl(1:end)); xlabel('Seconds'); ylabel('Amplitude');
plot(t_dca(1:end),y_dca(1:end)); xlabel('Seconds'); ylabel('Amplitude');
subplot(2,2,1); hold on;
title("Decawave X");
plot(squeeze(deca.UD.Pos(1,1,:)));
