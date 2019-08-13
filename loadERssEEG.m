function [visERs] = loadERssEEG(pat)
%% Load mat-file
dataPath = '/Fridge/CCEP/derivatives/visERs';
V = dir(fullfile(dataPath));

variant=size(pat(1).epoch_sorted_avg,2);

if variant==54

    % Load NvK visER
    visERsNvK = load(fullfile(V(1).folder, [pat(1).RESPnum '_ERs_NvK.mat']));

    %Load NvK stimsets
    cc_stimsetsNvK = load(fullfile(V(1).folder, [pat(1).RESPnum '_cc_stimsets_NvK.mat']));
    cc_stimsetsNvK = cc_stimsetsNvK.cc_stimsets;

    %Load NvK channels
    channelsNvK = load(fullfile(V(1).folder, [pat(1).RESPnum '_channels_NvK.mat']));
    chNvK= table2cell(channelsNvK.cc_channels(:,1));
    visERsNvK.ch=chNvK;

    for trial=1:size(pat(1).epoch_sorted_avg,2)
        for elec=1:2
            visERsNvK.ch2(trial,[1,2])=visERsNvK.ch(cc_stimsetsNvK(trial,[1,2]));
            visERsNvK.stimpair(trial,elec)=find(strcmp(pat(1).ch,visERsNvK.ch2(trial,elec)));
        end
    end

    for trial=1:size(visERsNvK.stimpair,1)
        visERs(trial).stimpair = visERsNvK.stimpair(trial,1:2);
        visERs(trial).vis=visERsNvK.ERs(trial).vis;
        visERs(trial).stimcur=cc_stimsetsNvK(trial,3);
        visERs(trial).polarity=3;
    end
    
    patNvK= load('/home/bram/Desktop/CCEP/RESP0773_ERs_NvK_FPchecked.mat');
    visERs2NvK=patNvK.pat(1).visERs2NvK;

    for trial=1:size(visERs,2)
        visERs(trial).vis=[visERs(trial).vis visERs2NvK(trial).vis];
        visERs(trial).vis=sort(visERs(trial).vis);
    end

elseif variant==108
    
    % Load DvB visER
    visERsDvB = load(fullfile(V(1).folder, [pat(1).RESPnum '_visERs_DvB.mat']));
    visERsDvB = visERsDvB.RESP0773;

    for trial=1:size(visERsDvB.visERs,2)
        visERs(trial).stimpair = visERsDvB.visERs(trial).stimpair;
        visERs(trial).vis=visERsDvB.visERs(trial).vis;
        visERs(trial).stimcur=visERsDvB.visERs(trial).stimcur;
        if visERsDvB.visERs(trial).stimpair(1) < visERsDvB.visERs(trial).stimpair(2)
           visERs(trial).polarity=1;
        else
           visERs(trial).polarity=2;
        end
    end

    patDvB=load('/home/bram/Desktop/CCEP/RESP0773_ERs_DvB_FPchecked.mat');
    visERs2DvB=patDvB.pat(1).visERs2DvB;

    for trial=1:size(visERs,2)
        visERs(trial).vis=[visERs(trial).vis visERs2DvB(trial).vis];
        visERs(trial).vis=sort(visERs(trial).vis);
    end
end
end