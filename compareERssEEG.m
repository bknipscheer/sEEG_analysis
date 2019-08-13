% ER analysis in seeg
% This code is used to analyse the seeg data
% author: B Knipscheer
% date: August 2019

function [cc_stim_network,cc_stimchans,stim_network,settings,channel,visERs,nrERs] = compareERssEEG(pat)
%% Load variables
epoch_sorted_avg = pat(1).epoch_sorted_avg;

elec=1:size(epoch_sorted_avg,1);

visERs = pat(1).visERs;
detERs=pat(1).detERs;
cc_stimchans=pat(1).cc_stimchans;
ch=pat(1).ch;

%% False Positives
for trial=1:size(pat(1).epoch_sorted_avg,2)

    membertp=ismember(detERs(trial).detERs,visERs(trial).vis);
    memberfp=~ismember(detERs(trial).detERs,visERs(trial).vis);
    memberfn=~ismember(visERs(trial).vis,detERs(trial).detERs);

    tp=detERs(trial).detERs(membertp);
    fp=detERs(trial).detERs(memberfp);
    fn=visERs(trial).vis(memberfn);
    membertn=~ismember(elec,unique([tp fp fn]));
    tn=elec(membertn);
    membertn2=~ismember(tn,visERs(trial).stimpair);
    tn=tn(membertn2);

    sens=(length(tp)./(length(tp)+length(fn)))*100;
    spec=(length(tn)./(length(tn)+length(fp)))*100;
    ppv=(length(tp)./(length(tp)+length(fp)))*100;
    npv=(length(tn)./(length(tn)+length(fn)))*100;

    visERs(trial).tp=tp;
    visERs(trial).fp=fp;
    visERs(trial).fn=fn;
    visERs(trial).tn=tn;
    visERs(trial).sens=sens;
    visERs(trial).spec=spec;
    visERs(trial).ppv=ppv;
    visERs(trial).npv=npv;
end

%% Differentiate between stimcur, polarity and brainmatter

% Categorize brainmatter of the detected electrodes
for elec=1:size(epoch_sorted_avg,1)
    if strcmp(pat(1).ch(elec,2),'white')
        channel(elec,1)=1;
    elseif strcmp(pat(1).ch(elec,2),'gray')
        channel(elec,1)=2;
    elseif strcmp(pat(1).ch(elec,2),'gw')
        channel(elec,1)=3;
    elseif strcmp(pat(1).ch(elec,2),'other')
        channel(elec,1)=4;
    end
end

% Brainmatter of stimpairs
for trial = 1:size(epoch_sorted_avg,2)
    cc_stimchans(trial,2)={sprintf('%s-%s',pat(1).ch{visERs(trial).stimpair(1),2},pat(1).ch{visERs(trial).stimpair(2),2})};
end

% Categorize brainmatter of the stimulating electrodes
for trial = 1:size(epoch_sorted_avg,2)
    if strcmp(pat(1).ch(visERs(trial).stimpair(1),2),'white')
        if strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'white')
            brainmatter(trial,1)=1;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gray')
            brainmatter(trial,1)=2;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gw')
            brainmatter(trial,1)=3;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'other')
            brainmatter(trial,1)=4;
        end
    elseif strcmp(pat(1).ch(visERs(trial).stimpair(1),2),'gray')
        if strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'white')
            brainmatter(trial,1)=5;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gray')
            brainmatter(trial,1)=6;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gw')
            brainmatter(trial,1)=7;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'other')
            brainmatter(trial,1)=8;
        end
    elseif strcmp(pat(1).ch(visERs(trial).stimpair(1),2),'gw')
        if strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'white')
            brainmatter(trial,1)=9;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gray')
            brainmatter(trial,1)=10;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gw')
            brainmatter(trial,1)=11;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'other')
            brainmatter(trial,1)=12;
        end
    elseif strcmp(pat(1).ch(visERs(trial).stimpair(1),2),'other')
        if strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'white')
            brainmatter(trial,1)=13;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gray')
            brainmatter(trial,1)=14;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'gw')
            brainmatter(trial,1)=15;
        elseif strcmp(pat(1).ch(visERs(trial).stimpair(2),2),'other')
            brainmatter(trial,1)=16;
        end
    end
    visERs(trial).brainmatter=brainmatter(trial);
end

% Create the settings
stimvar=unique([visERs.stimcur;visERs.polarity]','rows');
elecbmvar=unique(channel);
bmvar=unique([visERs.brainmatter]');

settingsbm=NaN((size(stimvar,1)*size(elecbmvar,1)),3);

for elecsett=1:size(elecbmvar,1)
    settingsbm(elecsett:size(elecbmvar,1):end,1:2)=stimvar;
    settingsbm(elecsett:size(elecbmvar,1):end,3)=elecbmvar(elecsett);
end

nrERs=NaN(size(settingsbm,1),3,size(bmvar,1));

% Count the ERs per setting
for sett=1:size(settingsbm,1)
    for bmstim=1:size(bmvar,1)
        count=[];
        for trial = 1:size(epoch_sorted_avg,2)
            for elecER=1:size(visERs(trial).vis,2) 
                 if visERs(trial).stimcur==settingsbm(sett,1) && visERs(trial).polarity==settingsbm(sett,2) ...
                         && channel(visERs(trial).vis(elecER))==settingsbm(sett,3) && visERs(trial).brainmatter==bmvar(bmstim)
                            count=[count visERs(trial).vis(elecER)];
                            nrERs(sett,1,bmstim)=length(count);   
                 end
            end
        end
    end
end

% 2) Calculate the total number of electrodes that can respond to stimulation (possible ERs) for every
% setting. 3) Devide the ERs by the possible ERs for every setting
elec=1:size(epoch_sorted_avg,1);
for sett=1:size(settingsbm,1)
    for bmstim=1:size(bmvar,1)
        count=[];
        for trial=1:size(epoch_sorted_avg,2)
            if visERs(trial).stimcur==settingsbm(sett,1) && visERs(trial).polarity==settingsbm(sett,2) ...
                             && visERs(trial).brainmatter==bmvar(bmstim)
                stimelec=elec(~ismember(elec,visERs(trial).stimpair)); %The stimulated electrodes
                %The number of stimulated electrodes of the correct brainmatter type for that trial
                maxER=size(find(channel(stimelec)==settingsbm(sett,3)),1);
                count=[count maxER];
                nrERs(sett,2,bmstim)=sum(count);
            end
        end
        nrERs(sett,3,bmstim)=nrERs(sett,1,bmstim)/nrERs(sett,2,bmstim);
    end
end

%% Confusion Matrix for every setting
for sett=1:size(stimvar,1)
    counttp=[]; countfp=[]; countfn=[]; counttn=[];
    settings(sett,1:2)=stimvar(sett,1:2);
    for trial = 1:size(epoch_sorted_avg,2)
         if visERs(trial).stimcur==1 && visERs(trial).polarity==stimvar(sett,2)
            counttp=[counttp visERs(trial).tp];
            countfp=[countfp visERs(trial).fp];
            countfn=[countfn visERs(trial).fn];
            counttn=[counttn visERs(trial).tn];
            settings(sett,3)=length(counttp);
            settings(sett,4)=length(countfp);
            settings(sett,5)=length(countfn);
            settings(sett,6)=length(counttn);
         end
    end
end

settings(:,7)=(settings(:,3)./(settings(:,3)+settings(:,5)))*100; %sensitivity
settings(:,8)=(settings(:,6)./(settings(:,6)+settings(:,4)))*100; %specificity
settings(:,9)=(settings(:,3)./(settings(:,3)+settings(:,4)))*100; %positive predictive value
settings(:,10)=(settings(:,6)./(settings(:,6)+settings(:,5)))*100; %negative predictive value

%% Create Stimpair Network
for trial=1:size(pat(1).epoch_sorted_avg,2)
    stim_net(trial).stimpair=visERs(trial).stimpair;
    stim_net(trial).cc_stimpair=pat(1).cc_stimchans(trial);
    stim_net(trial).elec=pat(1).ch(visERs(trial).vis);
    stim_net(trial).ERs=numel(visERs(trial).vis);
end  

%% Create Stimpair Network
stim_network=unique(sort(pat(1).cc_stimsets(:,1:2),2),'rows');
stim_network(:,3:7)=NaN;
for sett=1:size(stimvar,1)
    for stim2=1:size(stim_network,1)
        count=[];
        for trial = 1:size(epoch_sorted_avg,2)
            if visERs(trial).stimcur==stimvar(sett,1) && visERs(trial).polarity==stimvar(sett,2) && ...
        ((visERs(trial).stimpair(1)==stim_network(stim2,1) && visERs(trial).stimpair(2)==stim_network(stim2,2)) || (visERs(trial).stimpair(2)==stim_network(stim2,1) && visERs(trial).stimpair(1)==stim_network(stim2,2)))
                stim2ER=numel(visERs(trial).vis);
                count=[count stim2ER];
                stim_network(stim2,sett+3)=sum(count);
            end
        end     
    end
end    

stim_network(:,3)=nansum(stim_network(:,4:7),2);

for stim2=1:size(stim_network,1)
    cc_stim_network(stim2,1)={sprintf('%s-%s',pat(1).ch{stim_network(stim2,1),1},pat(1).ch{stim_network(stim2,2),1})};
end
%% Create Channel Network
for sett=1:size(stimvar,1)
    for elec=1:size(epoch_sorted_avg,1)
        count=[];
        for trial=1:size(pat(1).epoch_sorted_avg,2)
            if visERs(trial).stimcur==stimvar(sett,1) && visERs(trial).polarity==stimvar(sett,2)
                ERelec=find(visERs(trial).vis==elec);
                count=[count ERelec];
                channel(elec,sett+1)=numel(count);
            end
        end
    end
end

%% Create the label and format the data
% Create xlabels
polarity=[{'pos'} {'neg'} {'both'}];
bm=[{'white'} {'gray'} {'gw'} {'other'}];
xt={};
for sett=1:size(settingsbm,1)
    if settingsbm(sett,3)~=4
        C=[sprintf('sc=%d',settingsbm(sett,1)) 'pol=' polarity(settingsbm(sett,2)) 'bm=' bm(settingsbm(sett,3))];
        str=strjoin(C);
        xt=[xt str];
    end
end

nrERs2=[];
for sett=1:size(settingsbm,1)
    if settingsbm(sett,3)~=4
        nrERs2=[nrERs2; nrERs(sett,:,:)];
    end
end

%% Plot the Bar Charts
f3=figure (3);
subplot(2,1,1);

bar(squeeze(nrERs2(:,1,:)),'stacked')
xticklabels(xt);
xticks([1:size(nrERs2,1)])
xtickangle(45)
ylabel('Number of ERs')
legend('gray-gray','gray-gw','gw-gray','gw-gw','Location','northwest')

subplot(2,1,2);
bar(squeeze(nrERs2(:,1,:))./sum(nrERs2(:,2,:),3)*100,'stacked')
xticks([1:size(nrERs2,1)])
xticklabels(xt);
xtickangle(45)
ylabel('Number of ERs to possible ERs (in %)')
legend('gray-gray','gray-gw','gw-gray','gw-gw','Location','northwest')

figdir='/home/bram/Desktop/Figures/';
figures=[f3];
[figures.WindowState]=deal('maximized');
if size(pat(1).epoch_sorted_avg,2)==108
    print(f3, [figdir 'Figure3A'],'-depsc')
    print(f3, [figdir 'Figure3A'],'-dpng')
elseif size(pat(1).epoch_sorted_avg,2)==54
    print(f3, [figdir 'Figure3B'],'-depsc')
    print(f3, [figdir 'Figure3B'],'-dpng')
end

%% Create Table
if size(pat(1).epoch_sorted_avg,2)==108
    tb_stim_network=table(cc_stim_network,stim_network(:,3:7));
    tb_ch_network=table(ch(:,1),channel(:,2),channel(:,3),channel(:,4),channel(:,5));
    writetable(tb_stim_network,'/home/bram/Desktop/Figures/stimnetwork.xlsx','Range','A1')
    writetable(tb_ch_network,'/home/bram/Desktop/Figures/chnetwork.xlsx','Range','A1')
elseif size(pat(1).epoch_sorted_avg,2)==54
    tb_stim_network=table(cc_stim_network,stim_network(:,3:5));
    tb_ch_network=table(ch(:,1),channel(:,2),channel(:,3));
    writetable(tb_stim_network,'/home/bram/Desktop/Figures/stimnetwork.xlsx','Range','H1')
    writetable(tb_ch_network,'/home/bram/Desktop/Figures/chnetwork.xlsx','Range','H1')
end
end