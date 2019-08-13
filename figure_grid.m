% Create figures of the sEEG electrodes
% author: D van Blooijs, P L Smit, B Knipscheer
% date: August 2019
function figure_grid(pat)
%% initialise
% close all
clear BW nch fact topo chanoverlap

stim_network=pat(1).stim_network;
channel=pat(1).channel;
epoch_sorted_avg = pat(1).epoch_sorted_avg;
visERs = pat(1).visERs;

fact=30;                         %factor size of the circles e.g. 30
nch=size(epoch_sorted_avg,1);    %number of channels e.g. 81

[BW, topo, chanoverlap] = construct_grid(num2cell(1:nch)',fact);

%%

locmat=cell2mat(topo.locresize'); %	location matrix based on cells
%Color of the outer circles (white, light gray, dark gray, black)
c_map2=[1 1 1;   0.3333    0.3333    0.3333;0.6667 0.6667 0.6667;0 0 0];

if size(epoch_sorted_avg,2)==108
    
channel(:,6)=sum(channel(:,2:5),2);
for elec=1:size(epoch_sorted_avg,1)
    edgecolor(elec,:)=c_map2(channel(elec,1),:);
end

%% figure for the responding electrodes
f4=figure(4);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,3)) || stim_network(stim,3)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,3)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,3)*8/max(stim_network(:,3)))
    end
end

c_map=jet(38);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
       C(ch,:)=c_map(channel(ch,6),:);
    end
end

im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');

xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs for stimuation settings 1-4')
colormap(c_map)
colorbar('ticks',(0:2:38)/38,'ticklabels',0:2:38,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
% labels
% labels=cellstr(num2str([1:nch]')); % example labels in string cells
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%%
f5=figure(5);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,4)) || stim_network(stim,4)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,4)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,4)*8/max(stim_network(:,3)))
    end
end

c_map=jet(16);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
        C(ch,:)=c_map(channel(ch,2)+1,:);
    end
end

im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');

xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs stimcur=1mA, polarity=pos')
colormap(c_map)
colorbar('ticks',(1:16)/16,'ticklabels',0:15,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%% 
f6=figure(6);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,5)) || stim_network(stim,5)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,5)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,5)*8/max(stim_network(:,3)))
    end
end

c_map=jet(16);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
        C(ch,:)=c_map(channel(ch,3)+1,:);
    end
end

im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');

xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs stimcur=1mA, polarity=neg')
colormap(c_map)
colorbar('ticks',(1:16)/16,'ticklabels',0:15,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%%
f7=figure(7);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,6)) || stim_network(stim,6)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,6)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,6)*8/max(stim_network(:,3)))
    end
end

c_map=jet(16);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
        C(ch,:)=c_map(channel(ch,4)+1,:);
    end
end

im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');


xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs stimcur=2mA, polarity=pos')
colormap(c_map)
colorbar('ticks',(1:16)/16,'ticklabels',0:15,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%%
f8=figure(8);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,7)) || stim_network(stim,7)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,7)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,7)*8/max(stim_network(:,3)))
    end
end

c_map=jet(16);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
        C(ch,:)=c_map(channel(ch,5)+1,:);
    end
end


im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');

xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs stimcur=2mA, polarity=neg')
colormap(c_map)
colorbar('ticks',(1:16)/16,'ticklabels',0:15,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%% Save Figures
figdir='/home/bram/Desktop/Figures/';
figures=[f4 f5 f6 f7 f8];
[figures.WindowState]=deal('maximized');
print(f4, [figdir 'Figure4A'],'-depsc')
print(f5, [figdir 'Figure5'],'-depsc')
print(f6, [figdir 'Figure6'],'-depsc')
print(f7, [figdir 'Figure7'],'-depsc')
print(f8, [figdir 'Figure8'],'-depsc')
print(f4, [figdir 'Figure4A'],'-dpng')
print(f5, [figdir 'Figure5'],'-dpng')
print(f6, [figdir 'Figure6'],'-dpng')
print(f7, [figdir 'Figure7'],'-dpng')
print(f8, [figdir 'Figure8'],'-dpng')

elseif size(pat(1).epoch_sorted_avg,2)==54

channel(:,4)=sum(channel(:,2:3),2);
for elec=1:size(epoch_sorted_avg,1)
    edgecolor(elec,:)=c_map2(channel(elec,1),:);
end    
    
%% figure for the responding electrodes
f9=figure(9);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,3)) || stim_network(stim,3)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,4)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,3)*8/max(stim_network(:,3)))
    end
end

c_map=jet(38);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
       C(ch,:)=c_map(channel(ch,4)+1,:);
    end
end

im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');

xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs for stimuation settings 5-6')
colormap(c_map)
colorbar('ticks',(1:39)/39,'ticklabels',0:38,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%%
f10=figure(10);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,4)) || stim_network(stim,4)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,4)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,4)*8/max(stim_network(:,3)))
    end
end

c_map=jet(16);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
        C(ch,:)=c_map(channel(ch,2)+1,:);
    end
end


im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');

xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs stimcur=1mA, polarity=both')
colormap(c_map)
colorbar('ticks',(1:16)/16,'ticklabels',0:15,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%%
f11=figure(11);
hold on

for stim=1:size(stim_network,1)
    if isempty(stim_network(stim,5)) || stim_network(stim,5)==0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'k--')
    elseif stim_network(stim,5)>0
        plot(locmat(stim_network(stim,1:2),1),locmat(stim_network(stim,1:2),2),'r-','LineWidth',...
        stim_network(stim,5)*8/max(stim_network(:,3)))
    end
end

c_map=jet(16);
for ch=1:size(channel,1)
    if channel(ch,1)==4
       C(ch,1:3)=0;
    else
        C(ch,:)=c_map(channel(ch,3)+1,:);
    end
end

im_out=scatter(locmat(:,1),locmat(:,2),fact*16,edgecolor,'filled','MarkerEdgeColor','k');
im_in=scatter(locmat(:,1),locmat(:,2),fact*8,C,'filled','MarkerEdgeColor','k');

xticks([])
yticks([])
xlim([0 ceil(max(locmat(:,1))*1.1)])
ylim([0 ceil(max(locmat(:,2))*1.1)])
title('ERs stimcur=1mA, polarity=neg')
colormap(c_map)
colorbar('ticks',(1:16)/16,'ticklabels',0:15,'Location','east')
hold off
axis ij %y axis starts from top as in images. (necessary when imshow isn't used)
labels=pat(1).ch(:,1);
%locate labels from string cells to locations in locmat:
text(locmat(:,1)-10,locmat(:,2)+10,labels,'Color','black','FontWeight','Bold','HorizontalAlignment','center')

%%
figdir='/home/bram/Desktop/Figures/';
figures=[f9 f10 f11];
[figures.WindowState]=deal('maximized');
print(f9, [figdir 'Figure9'],'-depsc')
print(f10, [figdir 'Figure10'],'-depsc')
print(f11, [figdir 'Figure11'],'-depsc')
print(f9, [figdir 'Figure9'],'-dpng')
print(f10, [figdir 'Figure10'],'-dpng')
print(f11, [figdir 'Figure11'],'-dpng')
end