addpath(genpath('D:\Repositories\auxiliaryMethods_v5\'));
data = readKnossosRoi('D:\8\','2012-06-26_C80_11_mag8',[1,128*21;1,128*24;5000/8,5000/8]);
imwrite(data(550:2200,560:2900)','xy.png');
%%
data = readKnossosRoi('D:\8\','2012-06-26_C80_11_mag8',[128*10.5,128*10.5;1,128*24;1,8*128]);
for idx = 1 : 1024
    slice = data(1,:,idx);
    pos = round(mean(find(slice)));
    if ~isnan(pos)
        data(1,:,idx) = data(1,mod((1:3072)+pos+1536,3072)+1,idx);
    end
end
temp=imresize(squeeze(data),[3072,2048]);

for idx = 1 : 1830
    imwrite(temp(360:2720,idx)-(mean(temp(360:2720,idx))-128),['LDKMB_yztop/yztop' num2str(idx) '.png']);
end
%%
data = readKnossosRoi('D:\8\','2012-06-26_C80_11_mag8',[1,128*21;128*12,128*12;1,8*128]);
for idx = 1 : 1024
    slice = data(:,1,idx);
    pos = round(mean(find(slice)));
    if ~isnan(pos)
        data(:,1,idx) = data(mod((1:2688)+pos+1536,2688)+1,1,idx);
    end
end
temp=imresize(squeeze(data),[2688,2048]);
for idx = 1 : 1830
    imwrite(temp(300:2000,idx)'-(mean(temp(300:2000,idx))-128),['LDKMB_xztop/xztop' num2str(idx) '.png']);
end
%%
data = readKnossosRoi('/tmpscratch/kboerg/cubes2/2017-06-28_C80_11/mag1/','2017-06-28_C80_11_mag1',[1344,1344;1,128*24;1,2760]);
imwrite(squeeze(data),'/tmpscratch/kboerg/yz2.png')
data = readKnossosRoi('/tmpscratch/kboerg/cubes2/2017-06-28_C80_11/mag1/','2017-06-28_C80_11_mag1',[1,128*21;128*12,128*12;1,2760]);

%%
data = imread('xz2.png');
for idx = 1 : 4 : 685
    imwrite(data(1:1792,idx)'-(mean(data(1:1792,idx))-128),['LDKMB_xztop2/xztop2_' num2str(idx) '.png']);
end
for idx = 685 : 4 : 2760
    imwrite(data(mod((1:1792)-95,1792)+1,idx)'-(mean(data(1:1792,idx))-128),['LDKMB_xztop2/xztop2_' num2str(idx) '.png']);
end
%%
data = imread('yz2.png');
for idx = 1 : 4 : 685
    imwrite(data(:,idx)-(mean(data(:,idx))-128),['LDKMB_yztop2/yztop2_' num2str(idx) '.png']);
end
for idx = 685 : 4 : 2760
    imwrite(data(mod((1:end)-341,size(data,1))+1,idx)-(mean(data(:,idx))-128),['LDKMB_yztop2/yztop2_' num2str(idx) '.png']);
end
%%
addpath('D:\Git\codeBase\createHocsAndHx\')
for i_x = 2 : 2 :7
    convertKnossosNmlToHoc2({struct('nodes',[1+(i_x-1)*1650/7,1,1,1;i_x*1650/7,2340,1,1],'edges',[1,2])},['e' num2str(i_x) '_'],1,0,1,1,[1,1,1],1);
    convertKnossosNmlToHoc2({struct('nodes',[1+(i_x-1)*1650/7,1,2349,1;i_x*1650/7,2340,2349,1],'edges',[1,2])},['g' num2str(i_x) '_'],1,0,1,1,[1,1,1],1);
end
for i_y = 2 : 2 :11
    convertKnossosNmlToHoc2({struct('nodes',[1,1+(i_y-1)*2340/11,1,1;1650,i_y*2340/11,1,1],'edges',[1,2])},['f' num2str(i_y) '_'],1,0,1,1,[1,1,1],1);
    convertKnossosNmlToHoc2({struct('nodes',[1,1+(i_y-1)*2340/11,2349,1;1650,i_y*2340/11,2349,1],'edges',[1,2])},['h' num2str(i_y) '_'],1,0,1,1,[1,1,1],1);
end
