function J=rvr_correctlens(I, intParam)
% ver http://www.mathworks.com/help/vision/ref/cameraparameters-class.html#bt8l9d6-5
% I = imread('D:\Laboratorio_LH\5_Calibración_Camaras\DJI_Phantom\modo_video\IMG_0601.jpg');

K=intParam.K;
kc=intParam.kc;
pc=intParam.pc;


cameraParams=cameraParameters('IntrinsicMatrix', K','RadialDistortion',kc,'TangentialDistortion',pc);
% J = undistortImage(I,cameraParams);

J = undistortImage(I,cameraParams,'OutputView','valid');


% figure; imshowpair(imresize(I, 0.5), imresize(J, 0.5), 'montage');