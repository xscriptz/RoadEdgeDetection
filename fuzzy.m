Irgb = imread('/Users/advi/Downloads/motionProfile100099.tiff');
%Igray = 0.2989*Irgb(:,:,1)+0.5870*Irgb(:,:,2)+0.1140*Irgb(:,:,3);
Igray = rgb2gray(Irgb); % Convert to grayscale

background = imopen(Igray,strel('disk',15));

% Display the Background Approximation as a Surface
figure
surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
ax = gca;
ax.YDir = 'reverse';

I0 = Igray - background;
%imshow(I2)

I01 = imadjust(I0);
%imshow(I3);

cm = graythresh(I01);
bwm = im2bw(I01,cm);
bwm = bwareaopen(bwm, 100);
bi = conv2(single(bwm), ones(15));
imshow(bi)

figure; image(bi,'CDataMapping','scaled'); colormap('gray');
title('Input Image in Grayscale')

I = double(bi);

classType = class(Igray);
scalingFactor = double(intmax(classType));
I = I/scalingFactor;

Gx = [-1 1];
Gy = Gx';
Ix = conv2(I,Gx,'same');
Iy = conv2(I,Gy,'same');

figure; image(Ix,'CDataMapping','scaled'); colormap('gray'); title('Ix');
figure; image(Iy,'CDataMapping','scaled'); colormap('gray'); title('Iy');


edgeFIS = newfis('edgeDetection');
edgeFIS = addvar(edgeFIS,'input','Ix',[-1 1]);
edgeFIS = addvar(edgeFIS,'input','Iy',[-1 1]);

sx = 0.1; sy = 0.1;
edgeFIS = addmf(edgeFIS,'input',1,'zero','gaussmf',[sx 0]);
edgeFIS = addmf(edgeFIS,'input',2,'zero','gaussmf',[sy 0]);

edgeFIS = addvar(edgeFIS,'output','Iout',[0 1]);

wa = 0.1; wb = 1; wc = 1;
ba = 0; bb = 0; bc = .7;
edgeFIS = addmf(edgeFIS,'output',1,'white','trimf',[wa wb wc]);
edgeFIS = addmf(edgeFIS,'output',1,'black','trimf',[ba bb bc]);

figure
subplot(2,2,1); plotmf(edgeFIS,'input',1); title('Ix');
subplot(2,2,2); plotmf(edgeFIS,'input',2); title('Iy');
subplot(2,2,[3 4]); plotmf(edgeFIS,'output',1); title('Iout')

r1 = 'If Ix is zero and Iy is zero then Iout is white';
r2 = 'If Ix is not zero or Iy is not zero then Iout is black';
r = char(r1,r2);
edgeFIS = parsrule(edgeFIS,r);
showrule(edgeFIS)


Ieval = zeros(size(I));% Preallocate the output matrix
for ii = 1:size(I,1)
    Ieval(ii,:) = evalfis([(Ix(ii,:));(Iy(ii,:));]',edgeFIS);
end


%figure; image(I,'CDataMapping','scaled'); colormap('gray');
%title('Original Grayscale Image')

%figure; image(Ieval,'CDataMapping','scaled'); colormap('gray');
%title('Edge Detection Using Fuzzy Logic')

BW = edge(Ieval,'Sobel',[]);
cc = bwconncomp(BW);
I4 = labelmatrix(cc);
a_rp = regionprops(cc,'Area','MajorAxisLength','MinorAxislength','Orientation','PixelList','Eccentricity');
idx = ([a_rp.Eccentricity] > 0.99 & [a_rp.Area] > 100 & [a_rp.Orientation] < 60 & [a_rp.Orientation] > -90);

BW2 = ismember(I4,find(idx));
[H,T,R] = hough(BW2);

%  figure, imshow(H,[], 'XData', T, 'YData', R, 'InitialMagnification', 'fit');
%  xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P  = houghpeaks(H,50,'threshold',ceil(0.1*max(H(:))));

% Set houghpeaks parameters, threshold unsure
x = T(P(:,2));
y = R(P(:,1));
plot(x,y,'s','color','white');

% Apply median filtering
I3 = medfilt2(I2);

% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',20,'MinLength',10);
figure, imshow(I3),imagesc(I3), hold on
max_len = 0;

for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

    % plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

showlines = struct(lines);
cellData = struct2cell(showlines);

% X-coordinates are for width
% Y-coordinates are for height
%point1(x y) etc

for i = 1:length(showlines)
    % 'A' stores all 'x' coordinates of point 1
    A([i,i+1])= [cellData{1,i}];
    % 'B' stores all 'x' coordinates of point 2
    B([i,i+1])= [cellData{2,i}];
    % 'C' stores all 'y' coordinates of point 1
    C([i,i])= [cellData{1,i}];
    % 'D' stores all 'y' coordinates of point 2
    D([i,i])= [cellData{2,i}];
end