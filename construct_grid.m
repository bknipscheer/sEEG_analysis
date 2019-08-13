% author: D van Blooijs
% load excel grid

function [BW, topo, chanoverlap] = construct_grid(channels,fact)

chanoverlap = [];

% [filename, pathname] = uigetfile('*.xls;*.xlsx', 'Select *.xls File');
% templatefile = [pathname filename];
templatefile= '/home/bram/Desktop/CCEP/RESP0773_elektroden.xlsx';

topo.template = xlsread(templatefile,'matlabsjabloon'); % in this template, the electrodes must all have a different number, in the order of appearance in matlab
% omringen met 0-en
topo.template = [zeros(1,size(topo.template,2)); topo.template; zeros(1,size(topo.template,2))];
topo.template = [zeros(size(topo.template,1),1) topo.template zeros(size(topo.template,1),1)];
topo.template(isnan(topo.template))= 0;

% omranding maken van het grid
	BW = edge(imresize(topo.template>0+0,fact),'canny');
% 	BW=zeros(10*fact,18*fact);
% 	BW([1 end])=1;
% 	BW=1-BW;

% find location of each electrode
clear topo.loc
for j = 1:size(channels,1)
    if ~isempty(find(topo.template ==j, 1))
        topo.loc{j} = find(topo.template == j); % index number of location in template
    else
        topo.loc{j} = 0; % overlappende electrodes hebben geen nummer in het excel en zijn dus 0
        chanoverlap = [chanoverlap j];
    end
end

% electrodes als cirkels
for i = 1:numel(topo.loc)
    if ~rem(topo.loc{i},size(topo.template,1))
        topo.locresize{i} = [ceil(topo.loc{i}/size(topo.template,1))*fact-(fact/2),size(topo.template,1)*fact-(fact/2)];
    else
        topo.locresize{i} = [ceil(topo.loc{i}/size(topo.template,1))*fact-(fact/2),rem(topo.loc{i},size(topo.template,1))*fact-(fact/2)];
    end
end
% 

% for i=1:size(topo.locresize,2)
%     if ~ismember(i, chanoverlap)
%         BW(topo.locresize{1,i}(2),topo.locresize{1,i}(1)) = 0;
%     end
% end


end
