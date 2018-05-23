clear

window_size = 700;
pad_thickness = 0;
shrinkage_rate = 0;%0.15
shrinkage_base = 15;
orientation_randomize = 15;

num_image_per_condition = 10000;

shape0_path                 = './element_shapes/setX/';
shape0_composition_path     = './composition_shapes/setA/';
shape1_path                 = './element_shapes/setY/';
shape1_composition_path     = './composition_shapes/setB/';

save_path                   = './output/AXBY/'; %target_composition - target_element - distractor_composition - distractor_element

shape0_scale                = 25 + (rand-0.5)*5;
shape0_density              = 30*2025/(shape0_scale^2);
shape0_force                = 2;

shape0_composition_scale    = 300 + (rand-0.5)*80;

shape0_distractor_density   = 30*2025/(shape0_scale^2);
shape0_distractor_force     = 1;

shape1_scale                = 25 + (rand-0.5)*5;
shape1_density              = 30*2025/(shape1_scale^2);
shape1_force                = 2;

shape1_composition_scale    = 300 + (rand-0.5)*80;
        
        
        
num_total_imgs = 0;
for i_img = 1:1000
    fprintf(strcat('i_img: ',num2str(i_img),'\n'));
    
    shape0_list = dir(shape0_path);
    shape0_composition_list = dir(shape0_composition_path);
    shape1_list = dir(shape1_path);
    shape1_composition_list = dir(shape1_composition_path);
    
    ishape0 = 0;
    for shape0_idx = 1:length(shape0_list)
        fn = strcat(shape0_path,shape0_list(shape0_idx).name);
        if strcmp(fn(end-2:end),'png') 
            shape0_img = im2double(rgb2gray(imread(fn)));
            ishape0 = ishape0+1;
        else
            continue
        end
    
    ishape0_composition = 0;
    for shape0_composition_idx = 1:length(shape0_composition_list)
        fn = strcat(shape0_composition_path,shape0_list(shape0_composition_idx).name);
        if strcmp(fn(end-2:end),'png') 
            shape0_composition_img = im2double(rgb2gray(imread(fn)));
            ishape0_composition = ishape0_composition+1;
        else
            continue
        end
        
    ishape1 = 0;
    for shape1_idx = 1:length(shape1_list)
        fn = strcat(shape1_path,shape1_list(shape1_idx).name);
        if strcmp(fn(end-2:end),'png') 
            shape1_img = im2double(rgb2gray(imread(fn)));
            ishape1 = ishape1+1;
        else
            continue
        end
    
    ishape1_composition = 0;
    for shape1_composition_idx = 1:length(shape1_composition_list)+1
        if shape1_composition_idx<=length(shape1_composition_list)
        	fn = strcat(shape1_composition_path,shape1_composition_list(shape1_composition_idx).name);
            if strcmp(fn(end-2:end),'png') 
                shape1_composition_img = im2double(rgb2gray(imread(fn)));
                ishape1_composition = ishape1_composition+1;
            else
                continue
            end
            shape1_scatter = 0;
        else
            fn='XXX';
            ishape1_composition = 6;
            while ~strcmp(fn(end-2:end),'png') 
                shape1_composition_random_idx = ceil(rand*length(shape1_composition_list));
                fn = strcat(shape1_composition_path,shape1_composition_list(shape1_composition_random_idx).name);
            end
            shape1_composition_img = im2double(rgb2gray(imread(fn)));
            shape1_scatter = 1;
        end

        
        
        [img_out,shape0_region_map, shape1_region_map]  =...
                    ...
                    generate_img(window_size, pad_thickness, shrinkage_rate, shrinkage_base, orientation_randomize,...
                                 shape0_density, shape1_density,...
                                 shape0_force, shape1_force,...
                                 shape0_img, shape1_img,...
                                 shape0_scale, shape1_scale, ...
                                 shape0_composition_img, shape1_composition_img,...
                                 shape0_composition_scale, shape1_composition_scale,...
                                 shape1_scatter);
                            
    %subplot(1,3,1);imagesc(img_out);
    %subplot(1,3,2);imagesc(shape0_region_map);title('shape0_regionmap')
    %subplot(1,3,3);imagesc(shape1_region_map);title('shape1_regionmap')
    %pause()
    
    % SAVE INTO A FILE
    save_path_full = strcat(save_path, num2str(ishape0_composition), num2str(ishape0), ...
                                num2str(ishape1_composition), num2str(ishape1));
    mkdir(save_path_full);
    save_fn = strcat(save_path_full, '/',num2str(i_img),'.png');
    imwrite(img_out,save_fn);
    num_total_imgs = num_total_imgs+1;
    
    if mod(num_total_imgs,1)==0
        fprintf(strcat('     Number of total images saved: ',num2str(num_total_imgs),'\n'));
    end
    
    end
    end
    end
    end
end
                            