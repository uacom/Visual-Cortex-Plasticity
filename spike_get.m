function Md = spike_get(rank,sort_number,sti,interval,repeats,datapoint,spont_time)
% input: 'rank', measurement number, ex. ori3, a=3;
% sort_number: how many cells classified in this trace
% load 'ori-R' and 'ori-S' data, which is save as by spike-2 data 
% sti : stimlation time;
% interval: interval between each stimulation;
% repeats: how many times in measurments;
% datapoint: how many datapoint in each measurment;
% spont_time: record spontaneous time


FileName_R = ['ori' num2str(rank) '-R' '.mat'];
FileName_S = ['ori' num2str(rank) '-S' '.mat'];


%FileName_R = [rank '-R' '.mat'];
%FileName_S = [rank '-S' '.mat'];



response = load (FileName_R);
spont = load (FileName_S);


%timestamp
%for i=1:nn
%eval(['RE','=','ori' ,num2str(a), '_Ch',num2str(3+i),'.times']);
%end
t_time=(sti+interval)*repeats*datapoint;
cishu=repeats*datapoint;
% hist=zeros(96,nn);
% h_spike=zeros(48,nn);
% hL_sti=zeros(1,nn);
hist_spk=zeros(cishu,sort_number);
% h_spike_sp=zeros(48,nn);
for i=1:sort_number
eval(['t1','=','response.ori',num2str(rank), '_Ch', num2str(2+i)]);
timestamp = t1.times;
%count spikes under stimulation
% bins= 1:2:191;
% hist(:,i)=histc(t1,bins)';
% h_spike(:,i)=hist(1:2:end,i);
%transform timestamp to spk
dt=0.1;  %time resolution (0.1s)
time_bins=dt:dt:(t_time);
spk=hist(timestamp,time_bins);

%count response 
for k=1:(datapoint*repeats)
     st1=10*((interval/2)+(k-1)*(interval+sti))+1; % start point
     st2=10*((interval/2)+(k-1)*(interval+sti)+sti); % end point    
     sum_spk=sum(spk(st1:st2));
     hist_spk(k,i)=sum_spk/sti;
end
end


% count spontaneous
sp=zeros(1,sort_number);
for i=1:sort_number
eval(['t2','=','spont.ori',num2str(rank), '_Ch', num2str(2+i)]);
spt_spk = t2.length;
sp(1,i)=spt_spk/spont_time;
end




%output
Md.Response=hist_spk;
Md.spt=sp;