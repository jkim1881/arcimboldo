function [ region_map_out ] = shuffle( region_map,window_size,composition_scale )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    addpath('randblock');
    region_map_out = zeros(size(region_map,1),size(region_map,2));
    for i = 1:2
        blockshape = max(min(round(normrnd(window_size/2,window_size/4,[1,2])),window_size),0);
        while (blockshape(1) > composition_scale*1/2 && blockshape(2) > composition_scale*1/2) ...
            ||(blockshape(1) < composition_scale*1/4 || blockshape(2) < composition_scale*1/4) %random block shuffle should have block size smaller than the compositional frame
            blockshape = max(min(round(normrnd(window_size/2,window_size/4,[1,2])),window_size),0);
        end
        height_remainder = mod(size(region_map,1),blockshape(1));
        width_remainder = mod(size(region_map,2),blockshape(2));
        [region_map_out_windowd,~,~] = randblock(region_map(1:end-height_remainder,1:end-width_remainder),blockshape);
        temp_out =region_map;
        temp_out(1:end-height_remainder,1:end-width_remainder)=region_map_out_windowd;
        temp_out = imrotate(temp_out,ceil(rand*360),'crop');
        temp_out = ceil(temp_out);
        region_map_out = region_map_out+max(min(round(temp_out),1),0);
    end
    region_map_out = max(min(round(region_map_out),1),0);
end

