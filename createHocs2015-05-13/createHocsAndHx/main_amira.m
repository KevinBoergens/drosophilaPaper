%% make amira

folder=[tempfolder 'for_amira\']
addpath('amiraMaker');
mkdir([folder 'amiraOutput']);
tt={}; %name, color, position in pool, justnodes
%hoc structure needs to be folders with hocs
nodiameter=0;
onlyshownodes=1;
volumesinglecolor=1;

noalpha=1;
green=[0 1 0];
turquoise=[0 1 1];
blue=[0 0 1];
white=[1 1 1];
red=[1 0 0];
yellow=[1 0.8 0.1];
markerdiameter=1800; %value sets node radius.. must be huge! 5000 makes 10um balls
axondiameter=2;  % value is tube scale factor,5 for 500nm but this is radius!!!!!!!!!!!!!!!!! the hundred comes from convertKnossosNmlToHoc2.m
dendritediameter=5;
usecustomcolorscheme=1;
onlyshownodes=1;
colorsforvolumes={green, turquoise, blue};
randomcolor=@(i,o)[squeeze(hsv2rgb(i/o,1,1))'];
%tt=[tt; {'dendrites',@(i,o)[dendritediameter, randomcolor(i,o)],@(i,o){'10' num2str(i*25) },~onlyshownodes,volumesinglecolor}];
tt=[tt; {'dendrites',@(i,o)[1, randomcolor(i,o)],@(i,o){'10' num2str(i*25) },~onlyshownodes,volumesinglecolor}];
%tt=[tt; {'dendrites_volumes',@(i,o)[dendritediameter, randomcolor(i,o)],@(i,o){'10' num2str(i*25) },~onlyshownodes,volumesinglecolor}];
cuttingplanes=repmat({cell(1,1000)},size(tt));
%load('../results_moving_from_5_to_10/irisFamousDendrite_boundingBoxes_original_output_2015-03-03.mat');
%THIS BLOCK CAN BE REMOVED
% for dii=1:length(dirlisting) %there are only 89 because not all of them have volumes
%     addtt=@(xcolor){num2str(dirlisting(dii)),@(i,o)[axondiameter, xcolor],@(i,o){'10' num2str(i*25) },~onlyshownodes,volumesinglecolor};
%     if isempty(boundingBoxes{dirlisting(dii)})
%         tt=[tt; addtt(yellow)];
%     else
%         if boundingBoxes{dirlisting(dii)}{1}==1
%             tt=[tt; addtt(blue)];
%         else
%             tt=[tt; addtt(red)];
%         end
%     end
%     cuttingplanes{end+1}=cell(1,1000);
%     if ~isempty(boundingBoxes{dirlisting(dii)})
%         for kk=1:2
%             for kkj=1:3
%                 eye3=eye(3);
%                 cuttingplanes{end}{kk}(end+1:end+2,:)=[eye3(kkj,:), (boundingBoxes{dirlisting(dii)}{2}.*[11.24 11.24 28]+0.5E4*eye3(kkj,:));...
%                     -eye3(kkj,:), (boundingBoxes{dirlisting(dii)}{2}.*[11.24 11.24 28]-0.5E4*eye3(kkj,:))] ;
%             end
%         end
%     end
% end

%
%

backgroundmode=0 % zero is homogenious, one is gradient
backgroundcolor=[1,1,1];
createBoundingBoxIndex=2; %size(tt,1); %zero for no bounding box, here somata
boundingbox=2;
mainamiraMaker([folder],tt,createBoundingBoxIndex,cuttingplanes,'main_auto_v2.hx',backgroundmode, backgroundcolor,boundingbox);
'done writing'
winopen([tempfolder 'for_amira\amiraOutput\main_auto_v2.hx']);