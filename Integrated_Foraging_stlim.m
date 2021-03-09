
function y=Integrated_Foraging_stlim(x,ass,Vmx,Vmn,size)
    ngh=ass*size;
    
    nVar=numel(x);
    
    k=randi([1 nVar]);
    
    y=x;
    y(k)=y(k)+ ngh*((-1)^randi(2));
    y(y>Vmx)=Vmx;
    y(y<Vmn)=Vmn;
    
end