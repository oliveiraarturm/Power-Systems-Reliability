clc 
clear

contingencias=6;
n=32;

EstadosPossiveis=0;

for k=0:1:contingencias;
EstadosPossiveis=nchoosek(n,k)+EstadosPossiveis;
end

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



q=1-p; %probabilidade de sucesso de cada gerador
j=1;

for k=0:1:contingencias %aqui agrupo até contingencias geradores
    
comb=nchoosek([1:n],k); %exibe todas as combinações de falha. Retorna um vetor com k colunas e o numero de linhas é o total de combinações

for i=1:1:size(comb)
    x=[1:n];
    falha{j,1}=comb(i,:); %esta célula guarda linha a linha o conjunto de geradores que falhou. Ex: [] [1 2] [contingencias 5] [1 8 contingencias1] 
    falha{j,6}=sum(capacidade(comb(i,:))); %capacidade indisponível
    falha{j,7}=capacidadeTotal-falha{j,6}; %capacidade disponível;
    falha{j,2}= prod ( p( comb(i,:) ) )   ;  %  p( comb(i,:) ) seleciono apenas os FORs (que está contido no veotr p) dos geradores que falharam e realizo o produtorio.
    x( comb(i,:) )=[]; % aqui elimino o conjunto dos geradores falhados do conjunto total de geradores.
    falha{j,3}=x; %coloco na coluna contingencias da célula o conjunto de geradores que não falharam
    falha{j,4}=prod ( q( x ) ) ; % realizo o calculo desses geradores não falharem .  É um AND das probabilidades de sucesso individuais.
    falha{j,5}=falha{j,4}*falha{j,2}; % a probabilidade total é o produto de um conjunto falhar e do outro não falhar.
    j=j+1;
end


end


carga=2850;
SomaProbabilidadeEstados=0;

for k=1:1:size(falha)
    
if  carga-falha{k,7}>0
     
 falha{k,8} = carga-falha{k,7}; %perda de carga
 EPNS(k)=falha{k,8}*falha{k,5};
 LOLP(k)=falha{k,5};
 
 
 
end

SomaProbabilidadeEstados = falha{k,5}+SomaProbabilidadeEstados;

end


Expected_Power_Not_Supplied=sum(EPNS);
Expected_Energy_Not_Supplied=Expected_Power_Not_Supplied*8760;
Loss_of_Load_Probability=sum(LOLP);
Loss_of_Load_Expectation=Loss_of_Load_Probability*8760;

Indices=table(Expected_Power_Not_Supplied,Expected_Energy_Not_Supplied,Loss_of_Load_Probability,Loss_of_Load_Expectation)






