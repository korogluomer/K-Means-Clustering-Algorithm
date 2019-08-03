clc;

kumeSayisi=4;
gozlemler=csvread('randomdata.csv');

gozlemSayisi=size(gozlemler,1);
parametreSayisi=size(gozlemler,2);

kumeMerkezleri=zeros(kumeSayisi,parametreSayisi);

%Gözlemlerin hangi kümeye ait olduðunu belirlemek için dizide indexler tutulur.
kumeler=zeros(gozlemSayisi,1);

%Önce her kümeye birer gözlem atmayý unutma!!!!
for index=1:kumeSayisi
   kumeler(index)=index; 
end

%Gözlemler kümelere random daðýtýlýr
for index=(kumeSayisi+1):gozlemSayisi
    kumeler(index)=randi(kumeSayisi);
end

durum=true;
while(durum)
    %Kümelerin merkez noktalarý bulunur.
    kumeMerkezleri=zeros(kumeSayisi,parametreSayisi);
    for merkez=1:kumeSayisi
        kumedekiGozlemSayisi=0;
        for gozlem=1:gozlemSayisi
            if(kumeler(gozlem)==merkez)
                kumedekiGozlemSayisi=kumedekiGozlemSayisi+1;
                kumeMerkezleri(merkez,:)=kumeMerkezleri(merkez,:)+gozlemler(gozlem,:);
            end
        end
        kumeMerkezleri(merkez,:)=kumeMerkezleri(merkez,:)/kumedekiGozlemSayisi;
    end
    
    %Küme içi deðiþmeler
    e=zeros(kumeSayisi,1);
    for kume=1:kumeSayisi
        uzaklik=zeros(1,parametreSayisi);
        for gozlem=1:gozlemSayisi
            if(kumeler(gozlem)==kume)
                uzaklik=(uzaklik+((gozlemler(gozlem,:)-kumeMerkezleri(kume,:)).^2));
            end
        end
        e(kume)=sum(uzaklik,2);
    end
    
    %Kare hata
    E=sum(e);
    disp(E)
    
    %Gözlemlerin kümelere uzaklýðý ile kümeler yeniden düzenlenir

        oncekiKumeler=kumeler;
    for gozlem=1:gozlemSayisi
        kumeUzakliklari=zeros(1,kumeSayisi);
        for merkez=1:kumeSayisi
            kumeUzakliklari(merkez)=sqrt(sum((gozlemler(gozlem,:)-kumeMerkezleri(merkez,:)).^2));
        end
        [~,kumeIndex]=min(kumeUzakliklari);
        kumeler(gozlem)=kumeIndex;
    end
    
    %Koþul
    if(oncekiKumeler==kumeler)
        durum=false;
    end
end

figure
gplotmatrix(gozlemler,[],kumeler);
