 function mainamiraMaker(folder,tt)
    function writeStuff(folder1, tl)
        for j=1:size(tl,1)
            XXXflag=tl{j,4};
            
            
            listDir=dir([folder1 filesep strrep(tl{j,1},'/','\') filesep '*.hoc']);
            createFolder(strrep(tl{j,1},'/','_'));
            for i=1:length(listDir)
                createSubFolder(strrep(tl{j,1},'/','_'),[listDir(i).name 'Folder'])
                tposition=tl{j,3}(i,length(listDir));
                createData(['../' tl{j,1} '/' listDir(i).name],listDir(i).name,[listDir(i).name 'Folder'],tposition{1},tposition{2});
                tabcd=tl{j,2}(i,length(listDir));
                if XXXflag
                    
                    createPlotNodes([listDir(i).name 'Plot'],listDir(i).name,tabcd(1),tabcd(2),tabcd(3),tabcd(4));
                else
                    
                    createPlot([listDir(i).name 'Plot'],listDir(i).name,tabcd(1),tabcd(2),tabcd(3),tabcd(4),num2str(str2num(tposition{1})+300),tposition{2});
                    
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


%%% Functions


%%%Start
fid=fopen([folder '\amiraOutput\main_auto.hx'],'w+');
createStart=@()fprintfK(fid, textread('start.hx','%s','whitespace','\n'));
createFolder=@(name)fprintfK(fid,strrep(textread('folder.hx','%s','whitespace','\n'),'MyDirectory',name));
createBoundingBox=@(parent)fprintfK(fid,strrep(textread('boundingbox.hx','%s','whitespace','\n'),'XXDATA',parent));

createSubFolder=@(parname,name)fprintfK(fid,strrepK(textread('subfolder.hx','%s','whitespace','\n'),{'MyDirectory',name;'XXXData',parname}));
createSubFolderInv=@(parname,name)fprintfK(fid,strrepK(textread('subfolder.hx','%s','whitespace','\n'),{'MyDirectory',name;'XXXData',parname;'32767','32766'}));

createData=@(relfn,name,parent,iconx,icony)fprintfK(fid,strrepK(textread('data.hx','%s','whitespace','\n'),{'XXXRELFN',relfn;'XXXDATA',name;'XXXPARENT',parent;'XXXICONX',iconx;'XXXICONY',icony}));
createDataInv=@(relfn,name,parent)fprintfK(fid,strrepK(textread('data_inv.hx','%s','whitespace','\n'),{'XXXRELFN',relfn;'XXXDATA',name;'XXXPARENT',parent}));

createPlot=@(name,data,diamRatio,r,g,b,iconx,icony)fprintfK(fid,strrepK(textread('plot.hx','%s','whitespace','\n'),{'MyView',name;'XXDATA',data;'XXDIAM',num2str(diamRatio);'XXR',num2str(r);'XXG',num2str(g);'XXB',num2str(b);'XXXICONX',iconx;'XXXICONY',icony}));
createPlotNodes=@(name,data,diameter,r,g,b)fprintfK(fid,strrepK(textread('plotnodes.hx','%s','whitespace','\n'),{'SpatialGraphView2',name;'XXDATA',data;'XXDIAM',num2str(diameter);'XXR',num2str(r);'XXG',num2str(g);'XXB',num2str(b)}));
createPlotNodesInv=@(name,data,diameter,r,g,b)fprintfK(fid,strrepK(textread('plotnodes_inv.hx','%s','whitespace','\n'),{'SpatialGraphView2',name;'XXDATA',data;'XXDIAM',num2str(diameter);'XXR',num2str(r);'XXG',num2str(g);'XXB',num2str(b)}));
createEnd=@()fprintfK(fid, textread('end.hx','%s','whitespace','\n'));

createStart();



% tt={...
%     'CX-ex145-myelinatedaxons-mh03',@(i,o)[0.25 squeeze(hsv2rgb(i/o,1,1))'];...
%     'CX-ex145-apicaldendrites-mh03',@(i,o)[0.25,0,1,0];...
%     'XXXbodies',@(i,o)[3000,0.9,0.8,0.5];...
%     'bloodvessels',@(i,o)[0.25,1,1,1];...
%     'cell02mh2', @(i,o)[0.25 squeeze(hsv2rgb(i/o,1,1))'];...
%    'apicaldentritesfinal',@(i,o)[0.25 1 0 0];...
%     'apikaldendritenfinalmittwoch',@(i,o)[0.25 1 0 1];...
%     'apikaldendritenfinal25.012',@(i,o)[0.25 0 1 1]...
%     
%     };
% 
writeStuff(folder,tt);
% 
% tt={'3_18', @(i,o)[0.25 squeeze(hsv2rgb(i/o,1,1))']...
%     
% };
% writeStuff('D:\0\Cortex\st07x2Top\Tracings\hocGrab2012-11-05\','../hocGrab2012-11-05/',tt);
createEnd();
fclose(fid);
 end