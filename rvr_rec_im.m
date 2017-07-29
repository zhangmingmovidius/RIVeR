function [Him_out,HX,HY,Hroi]=rvr_rec_im(im,roi,H)

if size(im,3)==3
    im=rgb2gray(im);
end

%rectify roi
Hroi=rvr_trans2rw(roi,H);

%dimensions of original image
w=size(im,2);
h=size(im,1);
%transform the image into vectors
x=1:w;
y=1:h;
[X Y]=meshgrid(x,y);
xx=reshape(X,numel(X),1);
yy=reshape(Y,numel(Y),1);
cc=reshape(im,numel(Y),1);
imi=[xx'; yy' ; ones(1,numel(X))];

%rectify pixels of the image
Himi=rvr_trans2rw(imi,H);

% determine the extent
Hxmin=min(Hroi(1,:)); Hxmax=max(Hroi(1,:));
Hymin=min(Hroi(2,:)); Hymax=max(Hroi(2,:));
box_Hroi=[Hxmin Hxmin Hxmax Hxmax;Hymin Hymax Hymax Hymin; 1 1 1 1];

Hx=[Hxmin:(Hxmax-Hxmin)/599:Hxmax];
Hy=[Hymin:(Hymax-Hymin)/599:Hymax];
[HX HY]=meshgrid(Hx, Hy);

%get the pixels in the image that won't be used for color interpolation
pix_box_Hroi=rvr_trans2pix(box_Hroi,H);
[id_in,on] = inpolygon(xx,yy,[min(pix_box_Hroi(1,:)) min(pix_box_Hroi(1,:)) max(pix_box_Hroi(1,:)) max(pix_box_Hroi(1,:))]',...
    [min(pix_box_Hroi(2,:)) max(pix_box_Hroi(2,:)) max(pix_box_Hroi(2,:)) min(pix_box_Hroi(2,:))]');

%delete useless pixels
Himi_filt=Himi(1:2,id_in==1);
cc_filt=cc(id_in==1);

%filter (optional)
ind=1:2:length(Himi_filt(1,:));
F = scatteredInterpolant(Himi_filt(1,ind)',Himi_filt(2,ind)',double(cc_filt(ind)),'linear','none');

Him_out=F(HX,HY);
% figure; pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray')
% hold on
% grid on
% plot(Hroi(1,:),Hroi(2,:))
