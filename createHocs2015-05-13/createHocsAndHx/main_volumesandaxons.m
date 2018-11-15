
tempfolder='D:\temp\drosophila_2015_05_13\'
mkdir(tempfolder);
addpath skeletonClassWithAdj\
mkdir ([tempfolder  'for_amira\']);
mkdir([tempfolder 'for_amira\dendrites\']);
unzip( '../all_diametered_final_changed_for_fewer_comments.zip', tempfolder);
liste=dir([tempfolder '*.nml']);
list_of_diams={
'HSE_5skels_ck.001_completed.nml0001.hoc'
'HSN_5skels_ck.001.nml0001.hoc'
'VS1_5skels_ck.001_completed.nml0001.hoc'
'HSS_5skels_ck.001_node10578.nml0001.hoc'
'VS2_3skels_ck.001_completed.nml0001.hoc'
'VS4_skels_ck.001_completed.nml0001.hoc'
'VS3_4skels_ck.001_completed.nml0001.hoc'
'VS6_4skels_ck.001_completed.nml0001.hoc'
'VS5_5skels_ck.001_completed.nml0001.hoc'
'VSlike3_2skels_ck.001_completed.nml0001.hoc'
'VSlike1_3skels_ck.001_corectedVersion.nml0001.hoc'
};
for i=1:length (liste)
    skel=skeleton([tempfolder liste(i).name],0);
    diamfactor=0;
    deprob=@(x)strrep(strrep(strrep(strrep(x,'(','_'),' ','_'),')','_'),',','_');
    if sum(cellfun(@(x)~isempty(x),strfind(list_of_diams,[liste(i).name '0001.hoc'])))==0
        diamfactor=1;
    end
    
    convertKnossosNmlToHoc2(skel.reverse(),[tempfolder 'for_amira\dendrites\' deprob(liste(i).name) ],0,0,0,0,[12 12 25],diamfactor);
end






%%
main_amira
