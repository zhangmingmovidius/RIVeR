function [BLUR]=rvr_auto_bckgrd(PathName)
%automatic background
listing = dir(PathName);
id_images=[];
stringToBeFound=['jpg'];
numOfFiles = length(listing);
for i=1:numOfFiles
    filename=listing(i).name;
    if ~isempty(findstr(filename,stringToBeFound))
        id_images=[id_images i];
    end
end

%make a blured image
if length(id_images)>101
    id_blur=[1:10:101];
else
    id_blur=[1:10];
end
if size(imread([PathName listing(id_images(id_blur(1))).name]),3)>1
    BLUR=0*double(rgb2gray(imread([PathName listing(id_images(id_blur(1))).name])));
else
BLUR=0*double(imread([PathName listing(id_images(id_blur(1))).name]));
end
for i=1:10
    if size(imread([PathName listing(id_images(id_blur(i))).name]),3)>1
        BLUR=BLUR+double(rgb2gray(imread([PathName listing(id_images(id_blur(i))).name])));
    else
    BLUR=BLUR+double(imread([PathName listing(id_images(id_blur(i))).name]));
    end
end
BLUR=uint8(BLUR./10);
%
%     figure; imshow(BLUR)
%       figure; imshow(imread([PathName listing(id_images(id_blur(1))).name]))


