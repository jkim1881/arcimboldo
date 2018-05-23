function [img, mask] = preprocess_and_makemask(img, scale, maskpad, shrinkage_rate, shrinkage_base)

% rescale the shape image
shrinkage = round(shrinkage_rate*max(scale-shrinkage_base,0));

img = imresize(im2double(img),[round(scale),round(scale)],'bilinear');

if shrinkage > 0
    img = round(conv2(im2single(bwmorph(ceil(img),'shrink',shrinkage)),fspecial('gaussian',shrinkage*4,shrinkage*2),'same'));
end
% img = conv2(img,fspecial('gaussian',max(round(scale/50),6),max(round(scale/10),2)),'same');

if maskpad > 0
    padsize = maskpad;
    img = padarray(img,[padsize,padsize]);
    mask = ceil(img);
    hdilate = vision.MorphologicalDilate('Neighborhood', ones(padsize,padsize));
    mask = min(ceil(step(hdilate,mask)),1); % morphological dilation
else
    mask = ceil(img);
end

end

