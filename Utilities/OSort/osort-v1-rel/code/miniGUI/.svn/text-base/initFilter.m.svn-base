function handles = initFilter(handles)

n = 4;
Wn = [300 3000]/(25000/2);
[b,a] = butter(n,Wn);
HdNew=[];
HdNew{1}=b;
HdNew{2}=a;
handles.Hd=HdNew;

