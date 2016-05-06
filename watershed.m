RGB = imread('/Users/advi/Downloads/motionProfile100099.tiff');

I = rgb2gray(RGB);


% Noise Detection and Filtering
%K = wiener2(I,[5 5]);
%imshow(K)

% Convert the Filterd Image to a binary Image
%BW = im2bw(K, level)
%Iblur1 = imgaussfilt(K,2);

% Edge detection using canny
BW1 = edge(I,'Canny');
imshow(BW1);

% Applying hough transform
%[H,T,R] = hough(BW1,'RhoResolution',0.5,'ThetaResolution',0.5);

[H,T,R] = hough(BW1);
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;


P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');


lines = houghlines(BW1,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(BW1), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end


plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');