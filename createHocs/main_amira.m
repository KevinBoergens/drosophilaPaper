%% make amira
folder='hocs/'
addpath('amiraMaker');
mkdir([folder 'amiraOutput']);
dirlist={'hocs', [0 1 0 0]};
tt={};
for i=1:size(dirlist,1)
    color=@(i,o)[100 1 1 1];
    if dirlist{i,2}(1)==0
        color=@(i,o)[1 squeeze(hsv2rgb(i/o,1,1))']; % first value is tube scale factor 
    end
    tt=[tt; {[dirlist{i,1} '_hoc'],color,@(i,o){'10' num2str(i*25) },dirlist{i,2}(1)==1}];
end
mainamiraMaker([folder],tt);
'done writing'