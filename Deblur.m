fontSize = 10;
I = imread('/Users/advi/Downloads/motionProfile100099.tiff');
grayImage = rgb2gray(I);
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows columns numberOfColorBands] = size(grayImage);
% Display the original gray scale image.
subplot(2,2,1);
imshow(I);
title('Original Image', 'FontSize', fontSize);
subplot(2,2,2);
imshow(grayImage);
title('grayscale Image', 'FontSize', fontSize);
gaussian1 = fspecial('Gaussian', 21, 15);
gaussian2 = fspecial('Gaussian', 21, 20);
dog = gaussian1 - gaussian2;
dogFilterImage = conv2(double(grayImage), dog, 'same');
subplot(2,2,3);
imshow(dogFilterImage, []);
title('DOG Filtered Image', 'FontSize', fontSize);
bw =(dogFilterImage);
subplot(2,2,4);
imshow(bw);