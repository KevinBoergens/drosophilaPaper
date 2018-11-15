%% make hocs
tempfolder='D:\temp\drosophila_run_2015-05-08\';
hocfolder='hocs\hocs_hoc\'
mkdir(hocfolder)
names={...
    'Cell Y_3skels_ck_was_2012-06-26_C80_11__explorational__vschuhbeck__4903f6 (49).zip'...
    'Cell7_VCH_1Skel.001_oxalis_reload_sorted_node_size_changed_wasnamed_2012-06-26_C80_11__explorational__truff__472ee6 Bis Node 10261 complete.zip'...
    'Zelle 55 fertig.zip'...
    'Zelle163_fertig.zip'...
    'Zelle40_fertig.zip'...
    'Zelle64_fertig.zip'...
    'cell15_was_2012-06-26_C80_11__explorational__truff__604db8 (3).zip'...
    'cell23_was_2012-06-26_C80_11__explorational__vrobl__48ebdb.zip'...
    'corrected_hw_DCH_cell3_28_70_127_ck_node_size_changed.zip'...
    'Cell Z_5skels_ck.001_corrected_sorted_diametered.zip'...
    'Cell45_6skels_ck.001_corrected_sorted_diametered.zip'...
    'Cell48_5skels_ck.001_corrected_sorted_diametered.zip'...
    'ZELLE_22.zip'...
    'Cell19_7skels_ck.001_corrected_sorted_diametered.zip'...
    'Cell71_4skels_ck.001_corrected_sorted_diametered.zip'...
    'XXHSE_5skels_ck.001_completed.zip'...
    'XXHSN_5skels_ck.001.zip'...
    'XXHSS_5skels_ck.001_node10578.zip'...
    'XXVS1_5skels_ck.001_completed.zip'...
    'XXVS2_3skels_ck.001_completed.zip'...
    'XXVS3_4skels_ck.001_completed.zip'...
    'XXVS4_skels_ck.001_completed.zip'...
    'XXVS5_5skels_ck.001_completed.zip'...
    'XXVS6_4skels_ck.001_completed.zip'...
    'XXVSlike1_3skels_ck.001_corectedVersion.zip'...
    'XXVSlike3_2skels_ck.001_completed.zip'}
for j=setdiff(1:length(names),[18 21])
    if strcmp(names{j}(1:2),'XX')
        names{j}=names{j}(3:end);
        unzip(['..' filesep 'createCommentsForDiameter' filesep 'lastyear_4erPattern_diameter\afterAdditionalDiametersForSomaFaden' filesep names{j}],tempfolder);
    else
        unzip(['..' filesep 'createCommentsForDiameter' filesep 'withdiameters' filesep names{j}],tempfolder);
    end
    
    if ~exist([tempfolder names{j}(1:end-3) 'nml'],'file')
        disp(names{j})
    end
    convertKnossosNmlToHoc2(parseNml([tempfolder names{j}(1:end-3) 'nml']),strrep(strrep(strrep([hocfolder names{j}(1:end-3) 'hoc'],' ','_'),'(',''),')',''),...
        0,0,0,1,[12,12,25],1)
end