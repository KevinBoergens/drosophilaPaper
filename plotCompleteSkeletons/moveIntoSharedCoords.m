function [ skelwrite ] = moveIntoSharedCoords( skel1, skel2, treeidx )
idxtop = 2;
persistent grid
persistent ttemp
if isempty(grid)
    load('D:\Git\drosophila\plotCompleteSkeletons\LDKMB_nml\ttemp_20170803.mat','ttemp');
    grid = reshape(ttemp.shiftsN,9,13,2760,2);
    grid(:,:,:,1) = grid(:,:,:,1) + repmat((1:9)'*2048,1,13,2760)-2048+1024;
    grid(:,:,:,2) = grid(:,:,:,2) + repmat((1:13)*1768,9,1,2760)-1768+884;
    grid(:,:,:,3) = repmat(permute(1:2760,[1,3,2]),9,13,1,1);
    grid = reshape(grid, [], 3);
    ttemp.shiftsNL = reshape(ttemp.shiftsN,[],2);
end
offsets = [0,0,0;[12530-12404, 11230-8423, 7298]];

nodestemp = skel2.nodes{treeidx}(:,1:3);
distances = pdist2(bsxfun(@times,nodestemp,[1,1,1000]), bsxfun(@times,grid,[1,1,1000]));
[~,minidx] = min(distances,[],2);
[minidxx,minidxy, minidxz] = ind2sub([9,13,2760],minidx);
nodestemp(:,1:2)=nodestemp(:,1:2)-ttemp.shiftsNL(sub2ind([9,13,2760],minidxx,minidxy,minidxz),:);
nodestemp=nodestemp+repmat(offsets(idxtop,:),size(nodestemp,1),1);
[~, maxidx] = max(skel1.nodes{1}(:,3));
[~, minidx2] = min(min(pdist2(nodestemp,skel1.nodes{1}(:,1:3)),[],2));
skel2.nodes{treeidx}(:,4)=skel2.nodes{treeidx}(:,4)/2*4/pi;
skel2.nodes{treeidx}(:,1:3)=nodestemp;
skel2.edges{treeidx}(end+1,:)=[minidx2, maxidx + size(skel2.nodes{treeidx},1)];
skel2.edges{treeidx} = [skel2.edges{treeidx}; skel1.edges{1}+ size(skel2.nodes{treeidx},1)];
skel2.nodes{treeidx} = [skel2.nodes{treeidx}; skel1.nodes{1}];
todelete = skel2.nodes{treeidx}(:,3)<7000;
skel2.edges{treeidx}(any(ismember(skel2.edges{treeidx},find(todelete)),2),:)=[];
clear lookup;
lookup(setdiff(1:size(skel2.nodes{treeidx},1),find(todelete)))=1:(size(skel2.nodes{treeidx},1)-sum(todelete));
skel2.edges{treeidx} = lookup(skel2.edges{treeidx});
skel2.nodes{treeidx}(todelete,:)=[];
connM = skel2.createAdjacencyMatrix(treeidx);
connM=connM+eye(size(connM));
connM=connM;
connM=connM>0;
connM = connM./repmat(sum(connM),size(connM,1),1);
skel2.nodes{treeidx}(:,1)=connM'*skel2.nodes{treeidx}(:,1);
skel2.nodes{treeidx}(:,2)=connM'*skel2.nodes{treeidx}(:,2);
skel2.nodes{treeidx}(:,3)=connM'*skel2.nodes{treeidx}(:,3);
connM=connM^6;
connM=connM>0;
connM = connM./repmat(sum(connM),size(connM,1),1);
skel2.nodes{treeidx}(:,4)=connM'*skel2.nodes{treeidx}(:,4);
skelwrite{1}.nodes = skel2.nodes{treeidx};
skelwrite{1}.edges = skel2.edges{treeidx};

end

