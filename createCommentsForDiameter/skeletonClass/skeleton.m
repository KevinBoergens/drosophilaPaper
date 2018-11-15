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
            temp=parseNml(filename,1);
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
                obj.names{i}=temp{i}.name;
                
                obj.nodesAsStruct{i}=temp{i}.nodesAsStruct;
                obj.nodesNumDataAll{i}=temp{i}.nodesNumDataAll;
                tmax(i)=max(temp{i}.nodesNumDataAll(:,1));
                
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
            listoffinds=find(obj.edges{tree_index}==index);
            for k=length(listoffinds):-1:1
                actualindex=mod(listoffinds(k)-1,size(obj.edges{tree_index},1))+1;
                obj.edges{tree_index}=obj.edges{tree_index}([1:actualindex-1, actualindex+1:end],:);
            end
            obj.nodes{tree_index}=obj.nodes{tree_index}([1:index-1, index+1:end],:);
            obj.nodesAsStruct{tree_index}=obj.nodesAsStruct{tree_index}([1:index-1, index+1:end]);
            obj.nodesNumDataAll{tree_index}=obj.nodesNumDataAll{tree_index}([1:index-1, index+1:end],:);
            obj.edges{tree_index}(obj.edges{tree_index}>index)=obj.edges{tree_index}(obj.edges{tree_index}>index)-1;
        end
        function n=length(obj)
            n=length(obj.nodes);
        end
        function write(obj,filename)
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
            writeNml(filename,temp');
            
        end
        function G=showNetwork(obj,tree_index)
            function networkwalker(node,depth, referer)
                done=[done node];
                if length(positions)<depth
                    positions{depth}=node;
                else
                    positions{depth}=[positions{depth} node];
                end
                for i=find(am(node,:))
                    if ~isempty(find(done==i,1))
                        disp('circle found');
                        continue;
                    end
                    if i~=referer
                        networkwalker(i,depth+1, node);
                    end
                end
            end
            done=[];
            positions=cell(0);
            am=createAdjacencyMatrix(obj,tree_index);
            networkwalker(1,1,-1);
            addtosystempath('C:\Program Files (x86)\Graphviz2.30\bin');
            labels= feval(@(x)mat2cell(x,(1:size(x,1))*0+1,size(x,2)),num2str(obj.nodesNumDataAll{tree_index}(:,1)));
            G=graphViz4Matlab('-adjMat',am,'-nodeLabels',labels);
            for j=1:length(positions)
                for k=1:length(positions{j})
                    real_positions(positions{j}(k),:)=[j/(length(positions)+1) k/(length(positions{j})+1)];
                end
            end
            
            G.setNodePositions(real_positions)
            G.redraw_handle=@()G.setNodePositions(real_positions);
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
            if ~isempty(obj.thingIDs,1)
                obj.thingIDs=[obj.thingIDs,min(setdiff(1:union(1,max(obj.thingIDs)),obj.thingIDs))];
            else
                obj.thingIDs=1;
            end
            obj.names=[obj.names tree_name];
        end
        function obj=addNode(obj, tree_index, x, y, z, connect_to, diameter)
            if nargin()==6
                diameter=1.5
            end
            if isempty(obj.nodes{tree_index})
                error('Please add first node using addFirstNode');
            end
            obj.nodes{tree_index}=[obj.nodes{tree_index}; x y z 1.5];
            obj.nodesNumDataAll{tree_index}=[obj.nodesNumDataAll{tree_index}; obj.largestID+1 1.5 x y z 0 0 0];
            ts.id=num2str(obj.largestID+1);
            ts.radius='1.5';
            ts.x=num2str(x);
            ts.y=num2str(y);
            ts.z=num2str(z);
            ts.inVp='0';
            ts.inMag='0';
            ts.time='0';
            ts.comment='';
            obj.nodesAsStruct{tree_index}=[obj.nodesAsStruct{tree_index} ts];
            obj.largestID=obj.largestID+1;
            obj.edges{tree_index}=[obj.edges{tree_index}; connect_to length(obj.nodesAsStruct{tree_index})];
        end
        function obj=addFirstNode(obj, tree_index, x, y, z,diameter)
            if nargin()==5
                diameter=1.5
            end
            if ~isempty(obj.nodes{tree_index})
                error('Tree not empty');
            end
            obj.nodes{tree_index}=[obj.nodes{tree_index}; x y z 1.5];
            obj.nodesNumDataAll{tree_index}=[obj.nodesNumDataAll{tree_index}; obj.largestID+1 1.5 x y z 0 0 0];
            ts.id=num2str(obj.largestID+1);
            ts.radius='1.5';
            ts.x=num2str(x);
            ts.y=num2str(y);
            ts.z=num2str(z);
            ts.inVp='0';
            ts.inMag='0';
            ts.time='0';
            ts.comment='';
            obj.nodesAsStruct{tree_index}={ts};
            obj.largestID=obj.largestID+1;
        end
        function writeHoc(obj, filename)
            convertKnossosNmlToHocAll(obj,filename,false,false,false,false,[1 1 1]);
        end
        function obj=switchIDs(obj, tree_index, index1, index2) 
            temp=obj.nodes{tree_index}(index1,:);
            obj.nodes{tree_index}(index1,:)=obj.nodes{tree_index}(index2,:);
            obj.nodes{tree_index}(index2,:)=temp;
            
            temp=obj.nodesNumDataAll{tree_index}(index1,2:end); %1 is ID
            obj.nodesNumDataAll{tree_index}(index1,2:end)=obj.nodesNumDataAll{tree_index}(index2,2:end);
            obj.nodesNumDataAll{tree_index}(index2,2:end)=temp;
            
            temp=obj.nodesAsStruct{tree_index}{index1};
            obj.nodesAsStruct{tree_index}{index1}=obj.nodesAsStruct{tree_index}{index2};
            obj.nodesAsStruct{tree_index}{index2}=temp;
            
            temp=obj.nodesAsStruct{tree_index}{index1}.id; %revert ID flip
            obj.nodesAsStruct{tree_index}{index1}.id=obj.nodesAsStruct{tree_index}{index2}.id;
            obj.nodesAsStruct{tree_index}{index2}.id=temp;
            
            temp=obj.edges{tree_index};
            obj.edges{tree_index}(temp==index1)=index2;
            obj.edges{tree_index}(temp==index2)=index1;
        end
    end
end
