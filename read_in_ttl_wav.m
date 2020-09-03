% Script to test out analysis of the recorded audio and TTL

% Setup
root_save = ['C:' filesep 'Users' filesep 'Batman' filesep 'Desktop' filesep 'bataudio' filesep 'autoTrain' filesep 'box_9'];
bat1 = 'Si'; % Silver Falcon
bat2 = 'Op'; % Optimus Prime
day = '200817'; % Date [yrmoda]
paradigm = 'RecOnly';

%% Examine the ttl WAV
% Find the ttl files you want
filetype = strcat(bat1,bat2,'_',day,'*',paradigm,'*','ttl','*');
dirlist = dir(fullfile(root_save,filetype)); 
ttl_wav = [root_save filesep dirlist(end).name];

% Read in the WAV file
[y_ttl,Fs_ttl] = audioread(ttl_wav);
num_ch = size(y_ttl,2);

% Plot the ttl to make sure it's recorded
dt = 1/Fs_ttl;
t = 0:dt:(length(y_ttl)*dt)-dt;
figure();
plot(t(1:20000),y_ttl(1:20000)); xlabel('Seconds'); ylabel('Amplitude');
plot(psd(spectrum.periodogram,y_ttl,'Fs',Fs_ttl,'NFFT',length(y_ttl)));

%% Examine the actual audio WAV from mic1

% Find the audio files you want
filetype = strcat(bat1,bat2,'_',day,'*',paradigm,'*','mic1','*');
dirlist = dir(fullfile(root_save,filetype)); 
mic1_wav = [root_save filesep dirlist(end).name];

% Read in the WAV file
[y_mic1,Fs_mic1] = audioread(mic1_wav);
num_ch = size(y_mic1,2);

% Plot the ttl to make sure it's recorded
dt = 1/Fs_mic1;
t = 0:dt:(length(y_mic1)*dt)-dt;
plot(t,y_mic1); xlabel('Seconds'); ylabel('Amplitude');
figure;
plot(psd(spectrum.periodogram,y_mic1,'Fs',Fs_mic1,'NFFT',length(y_mic1)))





