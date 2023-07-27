%_________________________________________________________________________%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Put in the same folder the following codes: Signal2OPs.m, OrderPattern.m, ShannonEnt.m%%
%x=dir('N*.txt');
%%% This version cut the signal in 225 datapoint data and remove the ones that 
%%% have less than 225

clear
%dataDir='/home/diego/Insync/TRABAJO/Grupo_Montevideo/RAFE_2/Datos/';
dataDir='';

x=dir([dataDir 'N*.txt']); % the input for this program are txt files with instant frequencies time series

Lmax=225; % max length to analyze 
counter=0;
for i=1:length(x)
    filename=x(i).name;
    archivo=dlmread([ dataDir x(i).name],'\t',4,0);
    %%% here we check the length , if it is larger we cut it , if it is 
    %%%shorter we skip it
    
    Ldata=length(archivo(:,2));
    if Ldata<225 % choose here the lenght of the time series
        continue     
    else 
        data=archivo(1:Lmax,2);     
    end
    
    counter=counter+1;
    rafe(counter).nombre=x(i).name;
    rafe(counter).descarga=archivo(:,1);
    rafe(counter).INDATA=data;
    neuronas{1,counter}=x(i).name(1:end-4);
    neuronas{2,counter}=archivo(:,2);
end
%
%% INTER-SPIKE INTERVALS:
 for i=1:counter
rafe(i).ISIDAT = 1./rafe(i).INDATA;        % inter-spike interval (ISI) time-series



N_DATA(i)= length(rafe(i).ISIDAT);        % time-series length

%%% ISI STATISTICS MAIN MOMENTS:
media(i,1) = mean(rafe(i).ISIDAT);
moda(i,1)=mode(rafe(i).ISIDAT);
mediana(i,1)=median(rafe(i).ISIDAT);
dStd(i,1)=std(rafe(i).ISIDAT);
cv(i,1) =dStd(i,1)/media(i,1);    % coefficient of variation ~relative st.dev
skew (i,1)= skewness(rafe(i).ISIDAT);      % ISIs skewness
kurt (i,1)= kurtosis(rafe(i).ISIDAT);      % ISIs kurtosis
rango(i,1)=range(rafe(i).ISIDAT);
 
 end
 %%
 %Ordinal Patterns
 

 global  EMBDIM  DELAYS  
 EMBDIM = 3; % Dimension, word length 
DELAYS = EMBDIM-1;
 NPOSIB = factorial(EMBDIM);

 for i=1:counter
    clear OPCODE NUMOPS AVGSTA N_BINS
    OPCODE = Signal2OPs(rafe(i).ISIDAT);  % OP symbolic sequence from ISI series
    NUMOPS = length(OPCODE);        % number of OPs in symbolic sequence
    AVGSTA = floor(NUMOPS/NPOSIB);  % average statistics for OP appearance
    N_BINS = floor(N_DATA(i)/AVGSTA);  % number of bins for ISI histogram
 
%% Entropia de OP
    clear NFREQS OPSPDF SH_ENT SH_VAR
    NFREQS = hist(OPCODE,1:NPOSIB);
    OPSPDF = NFREQS'/sum(NFREQS);   % OPs probability density function (PDF)
    [SH_ENT,SH_VAR] = ShannonEnt(OPSPDF,NPOSIB); % word Entropy
    SH_ENT_OP(i,1)=SH_ENT;
    SH_VAR_OP(i,1)=SH_VAR;
    SH_RSV_OP(i,1)= sqrt(SH_VAR_OP(i,1))/SH_ENT_OP(i,1);   % entropy relative standard deviation

%% Entropia de los intervalos
    clear NFREQS X_BINS XCOORD ISIPDF SH_ENT SH_VAR
    [NFREQS,X_BINS] = hist(rafe(i).ISIDAT,N_BINS);
    XCOORD = [X_BINS(1)-0.05 X_BINS(end)+0.05];
    ISIPDF = NFREQS'/sum(NFREQS);   % ISI probability density function (PDF)
    [SH_ENT,SH_VAR] = ShannonEnt(ISIPDF,N_BINS);
    SH_ENT_int(i,1)=SH_ENT;
    SH_VAR_int(i,1)=SH_VAR;
    SH_RSV(i,1) = sqrt(SH_VAR)/SH_ENT;

%% Lempel Ziv Permutation complexity
%%% this part calculates Lempel Ziv complexity as well as Shanon permutation entropy

    %mex BPLZ.c   % run this line in console before starting, it is to compile the program that is in c (BPLZ.mexa64)
             % ones the program is generated you do not have to run it again 
    [PLZC,HPE]=HPE_PLZC(rafe(i).ISIDAT,EMBDIM,DELAYS );    % HPE is permutation entropy but it is repeated, so can be discarded 
    PLZC_int(i,1)=PLZC;
    
 
%% Permutation Min Entropy 
%%%% this use the program perm_min_entropy.

    PME=perm_min_entropy(rafe(i).ISIDAT,EMBDIM,DELAYS);
    PME_int(i,1)=PME;
    

end
 nombre=neuronas(1,:)';
tabla=table(nombre,media,moda, mediana, rango,dStd,cv,skew,kurt,SH_ENT_OP,SH_ENT_int,PLZC_int,PME_int );