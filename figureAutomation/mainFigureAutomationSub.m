function mainFigureAutomationSub(centerx,centery, labels)
width = 50;
arrowa = 10;
arrowb = 5;
textd=30;
plot([centerx,centerx],[centery-width,centery+width],'k','LineWidth',1)
plot([centerx-width,centerx+width],[centery,centery],'k','LineWidth',1)
plot([centerx-width, centerx-width+arrowa],[centery, centery + arrowb],'k','LineWidth',1)
plot([centerx-width, centerx-width+arrowa],[centery, centery - arrowb],'k','LineWidth',1)
plot([centerx+width, centerx+width-arrowa],[centery, centery + arrowb],'k','LineWidth',1)
plot([centerx+width, centerx+width-arrowa],[centery, centery - arrowb],'k','LineWidth',1)

plot([centerx, centerx + arrowb],[centery-width, centery-width+arrowa],'k','LineWidth',1)
plot([centerx, centerx - arrowb],[centery-width, centery-width+arrowa],'k','LineWidth',1)
plot([centerx, centerx + arrowb],[centery+width, centery+width-arrowa],'k','LineWidth',1)
plot([centerx, centerx - arrowb],[centery+width, centery+width-arrowa],'k','LineWidth',1)

text(centerx+width+textd,centery,labels(1),'FontSize',13,'HorizontalAlignment','center')
text(centerx-width-textd,centery,labels(2),'FontSize',13,'HorizontalAlignment','center')
text(centerx,centery+width+textd,labels(3),'FontSize',13,'HorizontalAlignment','center')
text(centerx,centery-width-textd,labels(4),'FontSize',13,'HorizontalAlignment','center')