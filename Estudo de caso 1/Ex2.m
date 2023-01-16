clc 
clear

%% Leitura dos dados

data=xlsread('dados.xlsx');
unidades=data(:,2);
forced=data(:,3);
power=data(:,5);


cont=1;

for i=1:1:size(unidades)
      
   b=unidades(i);
   
   for m=1:1:b 
   
   p(cont)=forced(i)/100;
   capacidade(cont)=power(i);
   
   cont=cont+1;
   
   end
   
end

capacidadeTotal=sum(capacidade);
carga=2850;
soma=0;

funcaoTeste(1)=0;
perdaCarga(1)=0;
beta=1;
k=1;


%% Monte Carlo

while beta>.05


    
A=binornd(ones(1,32),p);
capacidadeIndisponivel=sum(A.*capacidade);

capacidadeDisponivel=capacidadeTotal-capacidadeIndisponivel;

if carga>capacidadeDisponivel

perdaCarga(k)=carga-capacidadeDisponivel;
funcaoTeste(k)=1;



end

esperanca(k)=sum(funcaoTeste)/k;
vEPNS(k)=sum(perdaCarga)/k;

if k>100

beta = sqrt( var(esperanca) )/esperanca(k);

end

k=k+1;
 
 

end



LOLP=esperanca(end)
LOLE=LOLP*8760
EPNS=vEPNS(end)
EENS=EPNS*8760









