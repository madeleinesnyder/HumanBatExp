% To check the correlation of the Decawave positional data and feeder
% activations.

% Setup
root_save = ['C:' filesep 'Users' filesep 'Batman' filesep 'Desktop' filesep 'BatHumanExp' filesep 'box_3'];
bat1 = 'Clementine'; % Silver Falcon
bat2 = 'Ovaltine'; % Optimus Prime
bat3 = 'Saltine'; 
bat4 = 'Valentine';
day = '200923'; % Date [yrmoda]
paradigm = 'FeedTask';
HLRBat = 'Ovaltine';
session = '1';

% Load in the Decawave data
load(strcat(root_save,filesep,'decawave_',day,'_',session,'.mat'));

% Load in the Decawave binary data
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

% Find y_dca index where Decawave Positional Data starts
% 31566 is to account for the peak decay before starting recording.
ON = find(y_dca>0.1); OFF = find(y_dca<-0.1);
ON_idx = ON(1)+ 31566; OFF_idx = OFF(1);

% Get how many MOTU samples per one Decawave Position
MOTU_per_DCA = (OFF_idx-ON_idx)/size(UD.Pos,3)

% Get sample rate of Decawave
DCA_elapsed_time_copy_from_matlab = 234.144703;
DCA_samplerate = size(UD.Pos,3)/DCA_elapsed_time_copy_from_matlab

% Interpolate the Decawave Positional Data s.t. it is closer to the MOTU
% accquisition data.
DCA_upsampled = zeros(3,2,size(upsample(squeeze(UD.Pos(i,t,:)),round(MOTU_per_DCA)),1));
for t=1:2
    for i=1:3
        temp1 = upsample(squeeze(UD.Pos(i,t,:)),round(MOTU_per_DCA));
        temp2 = reshape(tst,[1 1 size(tst,1)]);
        DCA_upsampled(i,t,:) = temp2;
    end
end
