clc;

kumeSayisi=4;
gozlemler=csvread('randomdata.csv');

gozlemSayisi=size(gozlemler,1);
parametreSayisi=size(gozlemler,2);

kumeMerkezleri=zeros(kumeSayisi,parametreSayisi);

%G�zlemlerin hangi k�meye ait oldu�unu belirlemek i�in dizide indexler tutulur.
kumeler=zeros(gozlemSayisi,1);

%�nce her k�meye birer g�zlem atmay� unutma!!!!
for index=1:kumeSayisi
   kumeler(index)=index; 
end

%G�zlemler k�melere random da��t�l�r
for index=(kumeSayisi+1):gozlemSayisi
    kumeler(index)=randi(kumeSayisi);
end

durum=true;
while(durum)
    %K�melerin merkez noktalar� bulunur.
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
    
    %K�me i�i de�i�meler
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
    
    %G�zlemlerin k�melere uzakl��� ile k�meler yeniden d�zenlenir

        oncekiKumeler=kumeler;
    for gozlem=1:gozlemSayisi
        kumeUzakliklari=zeros(1,kumeSayisi);
        for merkez=1:kumeSayisi
            kumeUzakliklari(merkez)=sqrt(sum((gozlemler(gozlem,:)-kumeMerkezleri(merkez,:)).^2));
        end
        [~,kumeIndex]=min(kumeUzakliklari);
        kumeler(gozlem)=kumeIndex;
    end
    
    %Ko�ul
    if(oncekiKumeler==kumeler)
        durum=false;
    end
end

figure
gplotmatrix(gozlemler,[],kumeler);
