function [visERs,quadrant] = compareERssEEG(pat)
% Load mat-file
dataPath = '/Fridge/CCEP/derivatives/visERs';
V = dir(fullfile(dataPath));

sort=size(pat(1).epoch_sorted_avg,2);

if sort==54;

    % Load NvK visER
    visERsNvK = load(fullfile(V(1).folder, [pat(1).RESPnum '_ERs_NvK.mat']));

    %Load NvK stimsets
    cc_stimsetsNvK = load(fullfile(V(1).folder, [pat(1).RESPnum '_cc_stimsets_NvK.mat']));
    cc_stimsetsNvK = cc_stimsetsNvK.cc_stimsets;

    %Load NvK channels
    channelsNvK = load(fullfile(V(1).folder, [pat(1).RESPnum '_channels_NvK.mat']));
%     cc_channelsNvK = 
    chNvK= table2cell(channelsNvK.cc_channels(:,1));
    visERsNvK.ch=chNvK;


    for trial=1:size(pat(1).epoch_sorted_avg,2);
        for elec=1:2
            visERsNvK.ch2(trial,[1,2])=visERsNvK.ch(cc_stimsetsNvK(trial,[1,2]));
            visERsNvK.stimpair(trial,elec)=find(strcmp(pat(1).ch,visERsNvK.ch2(trial,elec)));
        end
    end

    for trial=1:size(visERsNvK.stimpair,1);
        visERs(trial).stimpair = visERsNvK.stimpair(trial,1:2);
        visERs(trial).vis=visERsNvK.ERs(trial).vis;
        visERs(trial).stimcur=cc_stimsetsNvK(trial,3);
        visERs(trial).polarity=3;
    end
    
elseif sort==108
    
    % Load DvB visER
    visERsDvB = load(fullfile(V(1).folder, [pat(1).RESPnum '_visERs_DvB.mat']));
    visERsDvB = visERsDvB.RESP0773;

    for trial=1:size(visERsDvB.visERs,2);
        visERs(trial).stimpair = visERsDvB.visERs(trial).stimpair;
        visERs(trial).vis=visERsDvB.visERs(trial).vis;
        visERs(trial).stimcur=visERsDvB.visERs(trial).stimcur;
        if visERsDvB.visERs(trial).stimpair(1) < visERsDvB.visERs(trial).stimpair(2)
           visERs(trial).polarity=1;
        else
           visERs(trial).polarity=2;
        end
    end

end

%% False Positives

elec=1:size(pat(1).epoch_sorted_avg,1);

for trial=1:size(pat(1).epoch_sorted_avg,2)
    detERs(trial,:)=pat(1).detERs(trial);

    membertp=ismember(detERs(trial).detERs,visERs(trial).vis);
    memberfp=~ismember(detERs(trial).detERs,visERs(trial).vis);
    memberfn=~ismember(visERs(trial).vis,detERs(trial).detERs);
    membertn=~ismember(elec,visERs(trial).stimpair);

    tp=detERs(trial).detERs(membertp);
    fp=detERs(trial).detERs(memberfp);
    fn=visERs(trial).vis(memberfn);
    tn=elec(membertn);
    membertn2=~ismember(tn,unique([tp fp fn]));
    tn=elec(membertn2);

    sens=(length(tp)./(length(tp)+length(fn)))*100;
    spec=(length(tn)./(length(tn)+length(fp)))*100;
    ppv=(length(tp)./(length(tp)+length(fp)))*100;
    npv=(length(tn)./(length(tn)+length(fn)))*100;

    quadrant(trial).tp=tp;
    quadrant(trial).fp=fp;
    quadrant(trial).fn=fn;
    quadrant(trial).tn=tn;
    quadrant(trial).sens=sens;
    quadrant(trial).spec=spec;
    quadrant(trial).ppv=ppv;
    quadrant(trial).npv=npv;
end
end
