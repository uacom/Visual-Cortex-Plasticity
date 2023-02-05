function [Results] = cbiCalc(spdsht, binSize)
%% Calculates CBI and plots figures from ODP experiments
% ********* REQUIRES groupedBarCBI.m ************************
% ********* CLOSE SPREADSHEET BEFORE RUNNING PROGRAM ********
%
% INPUTS
% spdsht = path to spreadsheet - needs sheet called "Ctrl" and another sheet called "Exp"
% binSize = bin size for cum. plot
% SQ note:  in the excel data file, 'Ctrl' and 'Exp' sheet really represent 'ND' and
% 'MD' groups. If you have WT and cKO groups, each group has 'ND (Ctrl)' and 'MD (Exp)',
% you will need to run code twice, one for each group. 
%
% OUTPUT
% Results - struct including all the data

%%% DEBUGGING %%%
%%% spdsht = 'singleUnitCBI2.xlsx';
%%% binSize = 0.05;
%%% Results = cbiCalc('singleUnitCBI2.xlsx', 0.02);

% autoArrangeFigures(0, 0, 2)

%% To process data in orignal data folder:
% Results = cbiCalc('E:\My Documents\Current Projects\Microglia synapse pruning\VC paper\singleUnitCBI_ctrl', 0.02);
% **************NOTE: the program write an earlier version of excel file with the same name in that folder,
% which cannot be opened correctly. To run it again, you need to delete
% this earlier version file with the same name. 

%% Process data into cell array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SQ IGNORE the xlswrite warning messages, because no sheet exist, it will
% create a sheet for you. 
% Warning: Added specified worksheet. 
% > In xlswrite>activate_sheet (line 293)
%   In xlswrite/ExecuteWrite (line 259)
%   In xlswrite (line 213)
%   In cbiCalc (line 263) 
% Warning: Added specified worksheet. 
% > In xlswrite>activate_sheet (line 293)
%   In xlswrite/ExecuteWrite (line 259)
%   In xlswrite (line 213)
%   In cbiCalc (line 264) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load from excel
rctrl = xlsread(spdsht,'Ctrl');
rexp = xlsread(spdsht,'Exp');

biglyC = size(rctrl,2);
biglyE = size(rexp,2);

% Preallocate size of cell array
ctrlCell{biglyC} = [];
expCell{biglyE} = [];

% Make cell arrays. Check for NaN, and make sure values are in the range [-1,1]
for i=1:biglyC
    ctrlCell{i} = rctrl(:,i);
    ctrlCell{i} = ctrlCell{i}(~isnan(ctrlCell{i}));
    ctrlCell{i} = ctrlCell{i}(ctrlCell{i}>=-1 & ctrlCell{i}<=1);
end
for i=1:biglyE
    expCell{i} = rexp(:,i);
    expCell{i} = expCell{i}(~isnan(expCell{i}));
    expCell{i} = expCell{i}(expCell{i}>=-1 & expCell{i}<=1);
end

%% Generate ODI cum plot

% Concatenate ODI cell arrays
combODI{1} = ctrlCell{1};
combODI{2} = expCell{1};


for i=2:biglyC
    combODI{1} = [combODI{1};ctrlCell{i}];
end
for i=2:biglyE
    combODI{2} = [combODI{2};expCell{i}];
end

% Generate figure
figure(1)
hist1 = histogram(combODI{1}, (-1:binSize:1), 'Normalization','cdf');
yCtrl = hist1.Values*100;
yCtrl(2:length(yCtrl)+1) = yCtrl;
yCtrl(1) = 0;
xCum = hist1.BinEdges;
hist2 = histogram(combODI{2}, (-1:binSize:1), 'Normalization','cdf');
yExp = hist2.Values*100;
yExp(2:length(yExp)+1) = yExp;
yExp(1) = 0;
hold off
plot(xCum,yCtrl,'r')
hold on
plot(xCum,yExp, 'r')
scatter(xCum, yCtrl, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r')
scatter(xCum, yExp, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'r')

%scatter(xCum, yCtrl, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
%scatter(xCum, yExp, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k')

xlabel('Ocular Dominance Index')
ylabel('Cumulative Proportion (%)')
Results.odi.x = xCum';
Results.odi.yCtrl = yCtrl';
Results.odi.yExp = yExp';
legend('ctrl','exp')


[~, p] = kstest2(combODI{1},combODI{2});
roundp = round(p,3);
if roundp >= 0.001
    text(-0.2, 90, sprintf('p = %.3f',roundp),'FontSize',10)
else
    text(-0.2, 90, 'p < 0.001','FontSize',10)
end
% if(h == 1)
%     text(-0.2, 90, '*','FontSize',16)
% else
%     text(-0.2, 90, 'NS','FontSize',14)
% end
text(0.2,40,sprintf('nCtrl = %d units',length(combODI{1})),'FontSize',10)
text(0.2,35,sprintf('nExp = %d units',length(combODI{2})),'FontSize',10)
Results.odi.pValue = p;

% Stairstep Plot
figure(2)
stairs(xCum,yCtrl)
hold on
stairs(xCum,yExp)

if roundp >= 0.001
    text(-0.2, 90, sprintf('p = %.3f',roundp),'FontSize',10)
else
    text(-0.2, 90, 'p < 0.001','FontSize',10)
end
ylabel('Cumulative Proportion of CBI values(%)')
xlabel('Ocular Dominance Index')

%% Calculate OD category (ODC) values and cum plot

% Preallocate cell arrays
odcCtrl{biglyC} = [];
odcExp{biglyE} = [];

% Generate ODI cell arrays
for i=1:biglyC
    for j=1:length(ctrlCell{i})
       x = ctrlCell{i}(j);
       if (x>=-1 && x<=-0.6)
           odcCtrl{i}(j) = 1;
       elseif (x>=-0.6 && x<=-0.4)
           odcCtrl{i}(j) = 2;
       elseif (x>=-0.4 && x<=-0.1)
           odcCtrl{i}(j) = 3;
       elseif (x>=-0.1 && x<=0.1)
           odcCtrl{i}(j) = 4;
       elseif (x>=0.1 && x<=0.4)
           odcCtrl{i}(j) = 5;
       elseif (x>=0.4 && x<=0.6)
           odcCtrl{i}(j) = 6;
       elseif (x>=0.6 && x<=1)
           odcCtrl{i}(j) = 7;
       end
    end
    odcCtrl{i} = odcCtrl{i}';
end

for i=1:biglyE
    for j=1:length(expCell{i})
       x = expCell{i}(j);
       if (x>=-1 && x<=-0.6)
           odcExp{i}(j) = 1;
       elseif (x>=-0.6 && x<=-0.4)
           odcExp{i}(j) = 2;
       elseif (x>=-0.4 && x<=-0.1)
           odcExp{i}(j) = 3;
       elseif (x>=-0.1 && x<=0.1)
           odcExp{i}(j) = 4;
       elseif (x>=0.1 && x<=0.4)
           odcExp{i}(j) = 5;
       elseif (x>=0.4 && x<=0.6)
           odcExp{i}(j) = 6;
       elseif (x>=0.6 && x<=1)
           odcExp{i}(j) = 7;
       end
    end
    odcExp{i} = odcExp{i}';
end   

% Concatenate cell arrays for histogram
combOdc{1} = odcCtrl{1};
combOdc{2} = odcExp{1};


for i=2:biglyC
    combOdc{1} = [combOdc{1};odcCtrl{i}];
end
for i=2:biglyE
    combOdc{2} = [combOdc{2};odcExp{i}];
end

% Generate figure
figure(3)

subplot(2,1,1) % Just counts, not normalized
hist1 = histogram(combOdc{1});
ctrlCount = hist1.Values';
hist2 = histogram(combOdc{2});
expCount = hist2.Values';
hold off
barCount = bar([ctrlCount expCount]);
barCount(1).FaceColor = [0 0 0];
barCount(2).FaceColor = [0.8 0.8 0.8];
legend('Ctrl/ND','Exp/MD');
xlabel('Ocular dominance index (ODI)'); ylabel('Number of units');
hold off

subplot(2,1,2)
hist1 = histogram(combOdc{1},'Normalization','probability');
odcyCtrl = hist1.Values';
hist2 = histogram(combOdc{2},'Normalization','probability');
odcyExp = hist2.Values';
hold off
barOBC = bar([odcyCtrl odcyExp]);
% barOBC(1).FaceColor = [0 0 0];
barOBC(1).FaceColor = [0.75 0.37 0]; % using Red color for bar
% barOBC(2).FaceColor = [0.8 0.8 0.8];
barOBC(2).FaceColor = [0.92549 0.811765 0.698039];
legend('Ctrl/ND','Exp/MD')
xlabel('Ocular dominance index (ODI)'); ylabel('Fraction of units');

hold off
Results.odc.yCtrl = odcyCtrl;
Results.odc.yExp = odcyExp;
Results.odc.x = (1:7)';



figure(4) % Single bar graphs
subplot(2,1,1)
barSingleC = bar(odcyCtrl);
barSingleC.FaceColor = [0 0 0];
legend('Ctrl/ND')
xlabel('Ocular dominance index (ODI)'); ylabel('Fraction of units');
subplot(2,1,2)
barSingleE = bar(odcyExp);
barSingleE.FaceColor = [0.8 0.8 0.8];
legend('Exp/MD')
xlabel('Ocular dominance index (ODI)'); ylabel('Fraction of units');

%% Calculate CBI and plot bar graph
CBI{2} = [];
for i=1:biglyC
    n1 = length(find(odcCtrl{i} == 1));
    n2 = length(find(odcCtrl{i} == 2));
    n3 = length(find(odcCtrl{i} == 3));
    n4 = length(find(odcCtrl{i} == 4)); %#ok<*NASGU>
    n5 = length(find(odcCtrl{i} == 5));
    n6 = length(find(odcCtrl{i} == 6));
    n7 = length(find(odcCtrl{i} == 7));
    num = length(odcCtrl{i});
    CBI{1}(i) = ((n1-n7) + ((2/3)*(n2-n6)) + ((1/3)*(n3-n5)) + num)/(2*num);
end
for i=1:biglyE
    n1 = length(find(odcExp{i} == 1));
    n2 = length(find(odcExp{i} == 2));
    n3 = length(find(odcExp{i} == 3));
    n4 = length(find(odcExp{i} == 4)); %#ok<*NASGU>
    n5 = length(find(odcExp{i} == 5));
    n6 = length(find(odcExp{i} == 6));
    n7 = length(find(odcExp{i} == 7));
    num = length(odcExp{i});
    CBI{2}(i) = ((n1-n7) + ((2/3)*(n2-n6)) + ((1/3)*(n3-n5)) + num)/(2*num);
end
CBI{1} = CBI{1}';
CBI{2} = CBI{2}';

Results.CBI.ctrl = CBI{1};
Results.CBI.exp = CBI{2};

figure(5)
groupedBarCBI(CBI);
legend('Ctrl/ND','Exp/MD')
xlabel('Groups'); ylabel('Calculated CBI values');

[~,p2] = ttest2(CBI{1},CBI{2});
roundp2 = round(p2,3);
text(1.2, max(CBI{2})+0.15, sprintf('p = %.3f',roundp2),'FontSize',10)

Results.CBI.pvalue = p2;

Results.odc.ctrl = odcCtrl;
Results.odc.exp = odcExp;

% Following lines for export to same excel spreadsheet as data
for i=1:length(odcCtrl)
    exportCtrl(1:length(odcCtrl{i}),i) = odcCtrl{i}; %#ok<AGROW>
end
exportCtrl(exportCtrl==0) = nan;

for i=1:length(odcExp)
    exportExp(1:length(odcExp{i}),i) = odcExp{i}; %#ok<AGROW>
end
exportExp(exportExp==0) = nan;

xlswrite(spdsht,exportCtrl,'Ctrl categories') % export results to same spreadsheet
xlswrite(spdsht,exportExp,'Exp categories')

end