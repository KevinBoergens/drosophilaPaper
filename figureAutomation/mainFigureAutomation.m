cells = {'vs1','vs2','vs3','vs4','vs5','vs6','vsl1','vsl2','vsl3','hsn','hse','hss','cell24','cell48','cellz','vslbd','allhs'};
for idx = 1 : length(cells)
    figure('Position',[10,10,1414,1000],'PaperOrientation','Landscape')
    
    im_frontal = imread([cells{idx} '_frontal.png']);
    im_sagittal = imread([cells{idx} '_sagittal.png']);
    image([im_frontal(:,150:end-550,:), im_sagittal(:,400:end-700,:)])
    axis off
    axis equal
    hold on
    mainFigureAutomationSub(90,800,'LMVD');
    mainFigureAutomationSub(1300,800,'PAVD');
    
    title(upper(cells{idx}))
    set(gcf,'PaperUnits','normalized');
    set(gcf,'PaperPosition', [0 0 1 1]);
    print(gcf,[cells{idx} '.pdf'],'-dpdf','-r0')
    close
end
