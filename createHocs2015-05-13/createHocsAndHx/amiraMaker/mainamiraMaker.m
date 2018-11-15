function mainamiraMaker(folder,tt,createBoundingBoxIndex,cuttingplanes,filename,backgroundmode, backgroundcolor,boundingboxwidth)
    function writeStuff(folder1, tl)
        for j=1:size(tl,1)
            XXXflag=tl(j,4:5); %just nodes and colormode, relevance depending on whether skel or volume
            listDir=[dir([folder1 filesep strrep(tl{j,1},'/','\') filesep '*.hoc']);dir([folder1 filesep strrep(tl{j,1},'/','\') filesep '*.issf'])];
            createFolder(strrep(tl{j,1},'/','_'));
            for i=1:length(listDir)
                createSubFolder(strrep(tl{j,1},'/','_'),[listDir(i).name 'Folder'])
                tposition=tl{j,3}(i,length(listDir));
                createData(['../' tl{j,1} '/' listDir(i).name],listDir(i).name,[listDir(i).name 'Folder'],tposition{1},tposition{2});
                if j==createBoundingBoxIndex
                    createBoundingBox(listDir(i).name);
                end
                color_diameter_alpha=tl{j,2}(i,length(listDir));
                if ~strcmp(listDir(i).name(end-2:end),'hoc')
                    createPlotSurf([listDir(i).name 'Plot'],listDir(i).name,color_diameter_alpha(1),color_diameter_alpha(2),color_diameter_alpha(3),color_diameter_alpha(4),XXXflag{2}*5,num2str(str2num(tposition{1})+300),tposition{2}); %the manual colormode is 5, hence the times 5
                else
                    if XXXflag{1}
                        createPlotNodes([listDir(i).name 'Plot'],listDir(i).name,color_diameter_alpha(1),color_diameter_alpha(2),color_diameter_alpha(3),color_diameter_alpha(4));
                    else
                        createPlot([listDir(i).name 'Plot'],listDir(i).name,color_diameter_alpha(1),color_diameter_alpha(2),color_diameter_alpha(3),color_diameter_alpha(4),num2str(str2num(tposition{1})+300),tposition{2});
                    end
                end
                if ~isempty(cuttingplanes{j}{i})
                    for k=1:size(cuttingplanes{j}{i},1)
                        createCuttingPlane([listDir(i).name 'CuttingPlane' num2str(k) '_' num2str(k) '_' num2str(k)],listDir(i).name,cuttingplanes{j}{i}(k,:),[listDir(i).name 'Plot']);
                    end
                end
                
                listDirComments=dir([folder1 'comment_' listDir(i).name(1:end-4) '_*']);
                if ~isempty(listDirComments)
                    listDir(i).name
                    createSubFolderInv([listDir(i).name 'Folder'],[listDir(i).name 'Comments']);
                    for icoms2=1:length(listDirComments)
                        createDataInv([folder2 listDirComments(icoms2).name],listDirComments(icoms2).name,[listDir(i).name 'Comments']);
                        createPlotNodesInv([listDirComments(icoms2).name 'Plot'],listDirComments(icoms2).name,1000,0,0,0);
                        createComment([folder1 'Z' listDirComments(icoms2).name], listDirComments(icoms2).name,[listDir(i).name 'Comments'])
                        %               createComment([folder1 'Z' listDirComments(icoms2).name], listDir(i).name,[listDir(i).name 'Comments'])
                    end
                    
                end
            end
        end
    end
    function fprintfK(fid,mytext)
        for itext=1:length(mytext)
            fprintf(fid,[mytext{itext},'\n']);
        end
    end
    function newtext=strrepK(oldtext,reps)
        for ireps=1:size(reps,1)
            oldtext=strrep(oldtext,reps{ireps,1},reps{ireps,2});
        end
        newtext=oldtext;
    end
    function createComment(data,name,parent)
        ct=textread('labels.hx','%s','whitespace','\n');
        comcor=load(strrep(data,'.hoc','.mat'));
        ct=strrepK(ct,{'ffff',parent;'xxxx',name;'xxx',num2str(comcor.x);...
            'yyy',num2str(comcor.y);'zzz',num2str(comcor.z);...
            'xxt',num2str(comcor.x+1);'yyt',num2str(comcor.y+1);...
            'zzt',num2str(comcor.z+1)});
        for i=1:length(comcor.n)
            ct=strrep(ct,'Hallo','  Hallo');
        end
        
        ct=strrep(ct,'Hallo',comcor.n);
        
        fprintfK(fid,ct);
    end
%%%Start
fid=fopen([folder '\amiraOutput\' filename],'w+');
createStart=@()fprintfK(fid, strrepK(textread('start.hx','%s','whitespace','\n'),{'XXMODE',num2str(backgroundmode);'XXR',num2str(backgroundcolor(1));'XXG',num2str(backgroundcolor(2));'XXB',num2str(backgroundcolor(3))}));
createFolder=@(name)fprintfK(fid,strrep(textread('folder.hx','%s','whitespace','\n'),'MyDirectory',name));
createBoundingBox=@(parent,width)fprintfK(fid,strrepK(textread('boundingbox.hx','%s','whitespace','\n'),{'XXX',parent;'XXWIDTH',num2str(width)}));
createSubFolder=@(parname,name)fprintfK(fid,strrepK(textread('subfolder.hx','%s','whitespace','\n'),{'MyDirectory',name;'XXXData',parname}));
createSubFolderInv=@(parname,name)fprintfK(fid,strrepK(textread('subfolder.hx','%s','whitespace','\n'),{'MyDirectory',name;'XXXData',parname;'32767','32766'}));
createData=@(relfn,name,parent,iconx,icony)fprintfK(fid,strrepK(textread('data.hx','%s','whitespace','\n'),{'XXXRELFN',relfn;'XXXDATA',name;'XXXPARENT',parent;'XXXICONX',iconx;'XXXICONY',icony}));
createDataInv=@(relfn,name,parent)fprintfK(fid,strrepK(textread('data_inv.hx','%s','whitespace','\n'),{'XXXRELFN',relfn;'XXXDATA',name;'XXXPARENT',parent}));
createPlot=@(name,data,diamRatio,r,g,b,iconx,icony)fprintfK(fid,strrepK(textread('plot.hx','%s','whitespace','\n'),{'MyView',name;'XXDATA',data;'XXDIAM',num2str(diamRatio);'XXR',num2str(r);'XXG',num2str(g);'XXB',num2str(b);'XXXICONX',iconx;'XXXICONY',icony}));
createPlotSurf=@(name,data,alpha,r,g,b,colormode,iconx,icony)fprintfK(fid,strrepK(textread('plotSurf.hx','%s','whitespace','\n'),{'MyView',name;'XXDATA',data;'XXXICONX',iconx;'XXXICONY',icony;'XXR',num2str(r);'XXG',num2str(g);'XXB',num2str(b);'XXALPHA',num2str(alpha);'XXCOLORMODE',num2str(colormode)}));
createPlotNodes=@(name,data,diameter,r,g,b)fprintfK(fid,strrepK(textread('plotnodes.hx','%s','whitespace','\n'),{'SpatialGraphView2',name;'XXDATA',data;'XXDIAM',num2str(diameter);'XXR',num2str(r);'XXG',num2str(g);'XXB',num2str(b)}));
createCuttingPlane=@(name,data,pos,xplot)fprintfK(fid,strrepK(textread('clippingplane.hx','%s','whitespace','\n'),{'ClippingPlane',name;'XXDATA',data;'XX1',num2str(pos(1));'XX2',num2str(pos(2));'XX3',num2str(pos(3));'XX4',num2str(pos(4));'XX5',num2str(pos(5));'XX6',num2str(pos(6));'XXPLOT',xplot}));

createPlotNodesInv=@(name,data,diameter,r,g,b)fprintfK(fid,strrepK(textread('plotnodes_inv.hx','%s','whitespace','\n'),{'SpatialGraphView2',name;'XXDATA',data;'XXDIAM',num2str(diameter);'XXR',num2str(r);'XXG',num2str(g);'XXB',num2str(b)}));
createEnd=@()fprintfK(fid, textread('end.hx','%s','whitespace','\n'));
createStart();
writeStuff(folder,tt);
createEnd();
fclose(fid);
end