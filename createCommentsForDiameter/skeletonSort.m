function yy=skeletonSort(obj,tree_index,start)
    function y=skeletonWalker(visited,goto)
        visited(goto)=true;
        y=goto;
        for i=find(am(goto,:).*(~visited))
            y=[y skeletonWalker(visited,i)];
        end
    end
    am=obj.createAdjacencyMatrix(tree_index);
    visited=false(size(obj.nodesAsStruct{tree_index}));
   yy=skeletonWalker(visited,start);
    
end
