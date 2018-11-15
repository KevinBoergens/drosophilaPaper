addpath('D:\Git\codeBase\skeletonClassWithAdj_v8\');
load('mynml_store.mat')
N=835;
myEnding = [7552
    7395
    7606
    7750
    7500
    7342
    6705
    6756
    6739];
myBeginning = [3874
    3536
    3702
    3641
    3804
    3773
    3464
    4220
    4231];
vses = {
    [45:49 93]
    [50:52 94]
    [53:56 95]
    [57:62 96]
    [63:67 97]
    [68:71 98]
    [72:74]
    [ 75:77 99]
    [78:79 100]};
for idx3 = 1 : length(vses)
    idx3
    zze_col{idx3}.vertices = [];
    zze_col{idx3}.faces = [];
    
    for idx2 = 1 : length(vses{idx3})
        a = mynml_store{vses{idx3}(idx2)}.getEdges(1).r;
        b = mynml_store{vses{idx3}(idx2)}.getNodes(1).r;
        for idx = 1:size(a,1)
            if b(a(idx,1),3)>myBeginning(idx3) && b(a(idx,1),3)<myEnding(idx3)
                zze = makeTube(b(a(idx,1),1:3).*[12,12,25], b(a(idx,2),1:3).*[12,12,25],b(a(idx,1),4)/sqrt(2),b(a(idx,2),4)/sqrt(2));
                zze_col{idx3}.faces = [zze_col{idx3}.faces; zze.faces+size(zze_col{idx3}.vertices,1)];
                zze_col{idx3}.vertices = [zze_col{idx3}.vertices; zze.vertices];
                %hold on
                %plot3(b(a(idx,:),1)*12, b(a(idx,:),2)*12,b(a(idx,:),3)*25);
            end
        end
    end
    %patch(zze_col)
end
allofthem = cell2mat(cellfun(@(x){x.vertices},zze_col)');
maxdims = [min(allofthem(:,1))-max(allofthem(:,1)),min(allofthem(:,2))-max(allofthem(:,2)),min(allofthem(:,3))-max(allofthem(:,3))];
%%
factorStretch=1.4;
shifty = 4E3;
for idx3 = 1 : length(zze_col)
    idx3
    'hi'
    asdf{idx3}=VOXELISE(linspace(min(allofthem(:,1))-shifty,min(allofthem(:,1))+83500*factorStretch-shifty,N),linspace(min(allofthem(:,2))-shifty,min(allofthem(:,2))+83500*factorStretch-shifty,N),linspace(min(allofthem(:,3)),min(allofthem(:,3))+83500*factorStretch,N),zze_col{idx3},'xyz');
    asdf{idx3}=imdilate(asdf{idx3},ones(3,3,3));
    asdf{idx3}=imclose(asdf{idx3},ones(3,3,3));
    asdf{idx3}=imerode(asdf{idx3},ones(3,3,3));
end


%%
asdf_col = zeros(N,N,3,N,'uint8');
colorsHere = [166,206,227
    31,120,180
    178,223,138
    51,160,44
    251,154,153
    227,26,28
    253,191,111
    255,127,0
    202,178,214];
for idx3 = 1 : length(asdf)
    idx3
    for idx4 = 1 : 3
        temp = asdf_col(:,:,idx4,:);
        temp2 = reshape(colorsHere(idx3,idx4)*asdf{idx3},[N,N,1,N]);
        temp(temp2~=0)=temp2(temp2~=0);
        asdf_col(:,:,idx4,:) = temp;
        
    end
end
%%
%%save('zz','asdf')
for idx4 = 1 : 7
    idx4
    for idx3 = 1 : length(asdf)
        idx3
        asdftemp = imdilate(asdf{idx3},ones(3,3,3));
        asdf{idx3}(sum(asdf_col,3)==0) = asdftemp(sum(asdf_col,3)==0);
        for idx4 = 1 : 3
            temp = asdf_col(:,:,idx4,:);
            temp2 = reshape(colorsHere(idx3,idx4)*asdf{idx3},[N,N,1,N]);
            temp(temp2~=0)=temp2(temp2~=0);
            asdf_col(:,:,idx4,:) = temp;
        end
    end
end
save('asdf8','asdf_col','-v7.3')
%%
for idx3 = 1 : 9
    idx3
    asdftemp = imdilate(asdf{idx3},ones(3,3,3));
    surfArea(idx) = sum(sum(sum(asdftemp>0&asdf{idx3}==0)));
    for idx4 =  idx3+1:9
        resultContact(idx3,idx4) = sum(sum(sum(asdftemp>0&asdf{idx4}>0)));
    end
end
save('asdf9','resultContact')
%%
figure('Position',[100,100,600,570])
resultContact(9,9)=0
imagesc(resultContact/100*1.4*1.4)
axis equal
colorbar
set(gca,'XTick',1:9)
set(gca','XTicklabels',{'VS1','VS2','VS3','VS4','VS5','VS6','VSL1','VSL2','VSL3'});
title('Contact area [µm²]')
set(gca,'YTick',1:9)
set(gca','YTicklabels',{'VS1','VS2','VS3','VS4','VS5','VS6','VSL1','VSL2','VSL3'});
%%
figure
hold on
for idx = 1 : 9
    plot([1,2,3],'Color',colorsHere(idx,:)/255)
end