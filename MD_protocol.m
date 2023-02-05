function Md = MD_protocol(logfile,rank,sort_number,spont_time)
% clear;
% get parameters from F21 data
% logfile: file name, need to be the .log file name
% rank: ex. ori1, 1 is the rank;
% sort_number: classified neurons in this file; if two neurons are sorted,
% then this number is 2
% spont_time: time for the spontaneous activity that is used to substract
% from visual evoked response

% MXK: Example: Md = MD_protocol('171009.A.01ori5',5,2,4); need to call
% this function, not press the RUN button.
% make sure the '171009.A.01ori5' is in current working directory!!!!! 
% last use of this function is for visual deprivation in MET
% mouce\metstTA\...\20171009(4113 4119)\F21\4113.

flog=ta(strcat(logfile,'.log'),strcat(logfile,'.sa0'),0);
stimuli=flog.test_sequence;
sti=flog.single_test_time;
interval=flog.interval;
repeats=flog.repeats;
datapoint=flog.data_points;%is reddit anon

spike=spike_get(rank,sort_number,sti,interval,repeats,datapoint,spont_time);
spk=spike.Response;
spt=spike.spt;
zm=datapoint*repeats;

% calculate average of response in each stimulation

nt=sort_number+1;
Sti_Res=zeros(zm,nt);
Sti_Res(:,1)=stimuli;
Sti_Res(:,2:nt)=spk;
spkk=sortrows(Sti_Res,1);
Res_ave=zeros(datapoint,nt);
Res_sem=zeros(datapoint,nt);
for m=1:datapoint
    k1=(m-1)*repeats+1;
    k2=repeats*m;
    pp=spkk(k1:k2,:);
    Res_ave(m,:)=mean(pp);
    Res_sem(m,:)=std(pp)/(sqrt(repeats));
end
Res_sem(:,1)=Res_ave(:,1);

% plot figure
stti=Res_ave(:,1)*30;
for i=1:sort_number
[mem,pos]=max(Res_ave(:,i+1));
figure;
plot(stti,Res_ave(:,i+1));
hold on;
plot(30*(pos-1),mem,'o','MarkerSize',15,'markerfacecolor', [ 0, 0, 0 ] );
text(30*pos,mem,['max=' num2str(mem)]);

wz=[logfile,'.', 'neuron',num2str(i)];

text(180,1.5*mem,wz);
hold on;
plot (1:2:330,spt(i)*ones(165),'.');
sptk=roundn(spt(i),-2);
text(300,spt(i),['spt=' num2str(sptk)])
hold on;
errorbar(stti,Res_ave(:,i+1),Res_sem(:,i+1),'r','Linewidth',1.5);
xlabel('Direction','FontSize',15);
ylabel('Response (spikes/s)','FontSize',12);
xlim([0,345]);
set(gca,'xtick', 0:30:360);
ylim([0,1.7*max(Res_ave(:,i+1))]);
end
Md.max_response=max(Res_ave(:,2:(sort_number+1)));
Md.spont=spt;
Md.real_resp=max(Res_ave(:,2:(sort_number+1)))-spt;
Md.sti_Response=Res_ave;
eval(['save',' ',logfile, '.mat']);

