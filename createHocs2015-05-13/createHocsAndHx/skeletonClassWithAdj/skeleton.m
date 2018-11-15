classdef skeleton
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes={};
        nodesAsStruct={};
        nodesNumDataAll={};
        edges={};
        parameters;
        thingIDs;
        names={};
        branchpoints;
        largestID=0;
        scale;
    end
    
    methods
        function obj=skeleton(filename,justcloneparameters)
            try
                temp=parseNml(filename);
                for i=1:length(temp)
                    obj.names{i}=temp{i}.name;
                end
            catch error
                warning('parseNml failed, trying readKnossosNml')
                temp=readKnossosNml(filename);
                
            end
            if justcloneparameters
                obj.parameters=temp{1}.parameters;
                return;
            end
            obj.thingIDs=zeros(length(temp),1);
            obj.nodes=cell(length(temp),1);
            obj.edges=cell(length(temp),1);
            obj.names=cell(length(temp),1);
            obj.nodesAsStruct=cell(length(temp),1);
            obj.nodesNumDataAll=cell(length(temp),1);
            tmax=[];
            for i=1:length(temp)
                
                obj.nodes{i}=temp{i}.nodes;
                obj.edges{i}=temp{i}.edges;
                obj.thingIDs(i)=temp{i}.thingID;
                tmax(i)=0;
                if isfield(temp{i},'nodesAsStruct')
                    obj.nodesAsStruct{i}=cell2mat(temp{i}.nodesAsStruct);
                    obj.nodesNumDataAll{i}=temp{i}.nodesNumDataAll;
                    if numel(temp{i}.nodesNumDataAll)
                        tmax(i)=max(temp{i}.nodesNumDataAll(:,1));
                    end
                end
            end
            obj.largestID=max(tmax);
            obj.parameters=temp{1}.parameters;
            obj.branchpoints=temp{1}.branchpoints;
            obj.scale=cellfun(@(s)str2double(obj.parameters.scale.(s)),{'x','y','z'});
        end
        function obj=deleteNode(obj,tree_index,index)
            if obj.nodesNumDataAll{tree_index}(index,1)==obj.largestID
                obj.largestID=max(obj.largestID-1,0);
            end
            actualindex=[];
            listoffinds=find(obj.edges{tree_index}==index);
            for k=length(listoffinds):-1:1
                actualindex(k)=mod(listoffinds(k)-1,size(obj.edges{tree_index},1))+1;
            end
            if length(listoffinds)~=1
                'deleting node with unexpected degree'
            end
            
            actualindex=sort(actualindex);
            for k=length(listoffinds):-1:1
                obj.edges{tree_index}=obj.edges{tree_index}([1:actualindex(k)-1, actualindex(k)+1:end],:);
            end
            obj.nodes{tree_index}=obj.nodes{tree_index}([1:index-1, index+1:end],:);
            obj.nodesAsStruct{tree_index}=obj.nodesAsStruct{tree_index}([1:index-1, index+1:end]);
            obj.nodesNumDataAll{tree_index}=obj.nodesNumDataAll{tree_index}([1:index-1, index+1:end],:);
            obj.edges{tree_index}(obj.edges{tree_index}>index)=obj.edges{tree_index}(obj.edges{tree_index}>index)-1;
            
            
        end
        function n=length(obj)
            n=length(obj.nodes);
        end
        function temp=reverse(obj)
            temp=cell(obj.length,1);
            for i=1:length(temp)
                temp{i}.nodes=obj.nodes{i};
                temp{i}.name=obj.names{i};
                temp{i}.edges=obj.edges{i};
                temp{i}.nodesAsStruct=obj.nodesAsStruct{i};
                temp{i}.nodesNumDataAll=obj.nodesNumDataAll{i};
                temp{i}.thingID=obj.thingIDs(i);
            end
            temp{1}.parameters=obj.parameters;
            temp{1}.branchpoints=obj.branchpoints;
        end
        function write(obj,filename)
            writeNml(filename,reverse(obj)');
        end        
        function cf=hasCircle(obj,tree_index)
            function networkwalker(node,depth, referer)
                done=[done node];
                for i=find(am(node,:))
                    if i~=referer && ~isempty(find(done==i,1))
                        cf=true;
                        continue;
                    end
                    if i~=referer
                        networkwalker(i,depth+1, node);
                    end
                end
            end
            cf=false;
            done=[];
            am=createAdjacencyMatrix(obj,tree_index);
            networkwalker(1,1,-1);
        end
        
        function li=createIdEdgeList(obj,tree_id)
            li=[obj.nodesNumDataAll{tree_id}(obj.edges{tree_id}(:,1),1) obj.nodesNumDataAll{tree_id}(obj.edges{tree_id}(:,2),1)];
        end
        function am=createWeightedAdjacencyMatrix(obj,tree_index)
            am=createAdjacencyMatrix(obj,tree_index);
            dist=zeros([size(am) 3]);
            for dim=1:3 %get distance between all point pairs
                dist(:,:,dim)=feval(@(y)y.^2,...
                    feval(@(x)repmat(x,1,numel(x))-repmat(x',numel(x),1),...
                    obj.scale(dim)*obj.nodes{tree_index}(:,dim)));
            end
            am=sparse(sqrt(sum(dist,3)).*am);
            
        end
        function am=createAdjacencyMatrix(obj,tree_index)
            am=zeros(size(obj.nodes{tree_index},1));
            am=logical(am);
            am((obj.edges{tree_index}(:,1)-1)*size(obj.nodes{tree_index},1)+obj.edges{tree_index}(:,2))=true;
            am=reshape(am,size(obj.nodes{tree_index},1),size(obj.nodes{tree_index},1));
            am=sparse(am+am');
        end
        function obj=deleteAllBranchpoints(obj)
            obj.branchpoints=[];
        end
        function obj=addBranchpoint(obj,id)
            obj.branchpoints=[obj.branchpoints; id];
        end
        function obj=addTree(obj,tree_name)
            obj.nodes=[obj.nodes cell(1)];
            obj.nodesAsStruct=[obj.nodesAsStruct cell(1)];
            obj.nodesNumDataAll=[obj.nodesNumDataAll cell(1)];
            obj.edges=[obj.edges cell(1)];
            if ~isempty(obj.thingIDs)
                obj.thingIDs=[obj.thingIDs,min(setdiff(1:max(obj.thingIDs)+1,obj.thingIDs))];
            else
                obj.thingIDs=1;
            end
            obj.names=[obj.names tree_name];
        end
        function obj=addNodeNaked(obj, tree_index, x, y, z, diameter)
            if nargin()==5
                diameter=1.5;
            end
            obj.nodes{tree_index}=[obj.nodes{tree_index}; x y z diameter];
            obj.nodesNumDataAll{tree_index}=[obj.nodesNumDataAll{tree_index}; obj.largestID+1 diameter x y z 0 0 0 0];
            ts.id=num2str(obj.largestID+1);
            ts.radius=num2str(diameter);
            ts.x=num2str(x);
            ts.y=num2str(y);
            ts.z=num2str(z);
            ts.inVp='0';
            ts.inMag='0';
            ts.time='0';
            ts.comment='';
            obj.nodesAsStruct{tree_index}=[obj.nodesAsStruct{tree_index} ts];
            obj.largestID=obj.largestID+1;
            
        end
        function obj=addNode(obj, tree_index, x, y, z, connect_to, diameter)
            if isempty(obj.nodes{tree_index})
                error('Please add first node using addFirstNode');
            end
            obj=addNodeNaked(obj,tree_index,x,y,z,diameter);
            obj.edges{tree_index}=[obj.edges{tree_index}; connect_to length(obj.nodesAsStruct{tree_index})];
            
        end
        function obj=addFirstNode(obj, tree_index, x, y, z,diameter)
            if ~isempty(obj.nodes{tree_index})
                error('Tree not empty');
            end
            obj=addNodeNaked(obj,tree_index,x,y,z,diameter);
        end
        function writeHoc(obj, filename)
            convertKnossosNmlToHocAll(reverse(obj),filename,false,false,false,false,[obj.parameters.scale.x obj.parameters.scale.y obj.parameters.scale.z]);
        end
        function obj=intermediateNodes(obj, tree_index, max_dist)
            numedges=size(obj.edges{tree_index},1);
            for i=1:numedges
                thisEdge=obj.edges{tree_index}(i,:);
                p1=obj.nodes{tree_index}(thisEdge(1),1:3);
                p2=obj.nodes{tree_index}(thisEdge(2),1:3);
                dist=sqrt((sum((p1-p2).*obj.scale).^2));
                if dist>max_dist
                    numNodesToAdd=ceil(dist/max_dist)-1;
                    obj.edges{tree_index}(i,2)=length(obj.nodesAsStruct{tree_index})+1;
                    for j=1:numNodesToAdd
                        nodeTodo=p1+(p2-p1)*(j-1)/numNodesToAdd;
                        obj=addNodeNaked(obj,tree_index,nodeTodo(1),nodeTodo(2),nodeTodo(3));
                        if j>1
                            obj.edges{tree_index}(end+1,:)=[length(obj.nodesAsStruct{tree_index})-1 length(obj.nodesAsStruct{tree_index})];
                        end
                    end
                    obj.edges{tree_index}(end+1,:)=[length(obj.nodesAsStruct{tree_index}),thisEdge(2)];
                    
                end
            end
        end
        function y=nodeCount(obj,tree_index)
            y=length(obj.nodesAsStruct{tree_index});
        end
        function nodes=getScaledNodes(obj,tree_index)
            nodes=obj.nodes{tree_index}(:,1:3).*repmat(obj.scale,nodeCount(obj,tree_index),1);
        end
        
        function y=lengthTree(obj, tree_index,mask)
            y=0;
            if nodeCount(obj,tree_index)>1
                one=getScaledNodes(obj,tree_index);
                one=one(obj.edges{tree_index}(:,1),:);
                two=getScaledNodes(obj,tree_index);
                two=two(obj.edges{tree_index}(:,2),:);
                if nargin==2
                    y=sum(sqrt(sum((one-two).^2,2)));
                else
                    y=sum(mask.*sqrt(sum((one-two).^2,2)));
                end
            end
        end
        function y=getDistanceToOtherSkeleton(obj,obj2, tree_index1, tree_index2)
            one=getScaledNodes(obj,tree_index1);
            two=obj2.getScaledNodes(tree_index2);
            y=pdist2(one(obj.edges{tree_index1}(:,1),:),two(obj2.edges{tree_index2}(:,1),:));
        end
        function obj=removeTPAs(obj, tree_id)
            deletecounter=0;
            
            am=createAdjacencyMatrix(obj,tree_id);
            am(logical(eye(size(am))))=1;
            am2=(am^2)>0;
            list=find(sum(am)==2 & sum(am2)==3);
            todelete=[];
            for i=1:length(list)
                com=lower(obj.nodesAsStruct{tree_id}{list(i)}.comment);
                if isempty(com) || (~isempty(strfind(com,'end'))) || (~isempty(strfind(com,'first')))
                    continue;
                end
                todelete=[todelete find(am(list(i),:))];
                deletecounter=deletecounter+1;
            end
            for i=fliplr(sort(todelete))
                obj=deleteNode(obj,tree_id,i);
            end
            
            deletecounter
        end
        function obj=deleteTree(obj, tree_id)
            obj=deleteAllBranchpoints(obj);
            list_of_entities={'names','nodes', 'nodesAsStruct', 'nodesNumDataAll', 'edges', 'thingIDs'};
            for ent=list_of_entities
                obj.(ent{1})=obj.(ent{1})([1:tree_id-1, tree_id+1:end]);
            end
        end
        
    end
end
