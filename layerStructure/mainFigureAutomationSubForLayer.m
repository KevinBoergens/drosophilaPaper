function mainFigureAutomationSubForLayer(centerx,centery, labels)
width = 1E4;
arrowa = width/5;
arrowb = width/10;
textd=width*3/5;
plot([centerx,centerx],[centery-width,centery+width],'w','LineWidth',1)
plot([centerx-width,centerx+width],[centery,centery],'w','LineWidth',1)
plot([centerx-width, centerx-width+arrowa],[centery, centery + arrowb],'w','LineWidth',1)
plot([centerx-width, centerx-width+arrowa],[centery, centery - arrowb],'w','LineWidth',1)
plot([centerx+width, centerx+width-arrowa],[centery, centery + arrowb],'w','LineWidth',1)
plot([centerx+width, centerx+width-arrowa],[centery, centery - arrowb],'w','LineWidth',1)

plot([centerx, centerx + arrowb],[centery-width, centery-width+arrowa],'w','LineWidth',1)
plot([centerx, centerx - arrowb],[centery-width, centery-width+arrowa],'w','LineWidth',1)
plot([centerx, centerx + arrowb],[centery+width, centery+width-arrowa],'w','LineWidth',1)
plot([centerx, centerx - arrowb],[centery+width, centery+width-arrowa],'w','LineWidth',1)

text(centerx+width+textd,centery,labels(1),'FontSize',13,'HorizontalAlignment','center','Color','white')
text(centerx-width-textd,centery,labels(2),'FontSize',13,'HorizontalAlignment','center','Color','white')
text(centerx,centery+width+textd,labels(3),'FontSize',13,'HorizontalAlignment','center','Color','white')
text(centerx,centery-width-textd,labels(4),'FontSize',13,'HorizontalAlignment','center','Color','white')