k = imread('/Users/advi/Downloads/motionProfile35.tiff');
I = rgb2gray(k); % Convert to grayscale
%imshow(I)
background = imopen(I,strel('disk',15));

% Display the Background Approximation as a Surface
figure
surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
ax = gca;
ax.YDir = 'reverse';

I2 = I - background;
%imshow(I2)

I3 = imadjust(I2);
%imshow(I3);

c = graythresh(I3);
bw = im2bw(I3,c);
bw = bwareaopen(bw, 50);
imshow(bw)

cc = bwconncomp(bw, 4)