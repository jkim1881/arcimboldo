function [] = stimgen_ccv_task1_noncomp(i_machine,n_machines,save_path_base)

window_size = 256;
pad_thickness = 0;
shrinkage_rate = 0;%0.15
shrinkage_base = 15;
orientation_randomize = 15;
num_image_per_condition = 50000;


num_elements = 3;
num_compositions = 3;


shape0_composition_path     = './composition_shapes/setA/';
shape0_path                 = './element_shapes/setX/';
shape1_composition_path     = './composition_shapes/setA/';
shape1_path                 = './element_shapes/setY/';
save_path = strcat(save_path_base,'AX_Y/'); %target_composition - target_element - distractor_composition - distractor_element

    
    


    
    
num_total_imgs_generated = 0;
num_image_per_machine = floor(num_image_per_condition/n_machines);
if i_machine<n_machines
    upper_limit = num_image_per_machine*i_machine;
else
    upper_limit = num_image_per_condition;
end
for i_img = (num_image_per_machine*(i_machine-1)+1):upper_limit
    
    fprintf(strcat('i_img: ',num2str(i_img),'\n'));
    shape0_list = dir(shape0_path);
    shape1_list = dir(shape1_path);
    shape0_composition_list = dir(shape0_composition_path);
    shape1_composition_list = dir(shape1_composition_path);

    ishape0_composition = 0;
    ishape0_composition_idx = 1;
    
    
    while ishape0_composition < num_compositions % num_compositions TARGET COMPOSITIONS
        fn = strcat(shape0_composition_path,shape0_composition_list(ishape0_composition_idx).name);
        if strcmp(fn(end-2:end),'png') 
            shape0_composition_img = im2double(rgb2gray(imread(fn)));
            ishape0_composition = ishape0_composition+1;
            ishape0_composition_idx = ishape0_composition_idx+1;
        else
            ishape0_composition_idx = ishape0_composition_idx+1;
            continue
        end
    
        
    ishape0 = 0; 
    ishape0_idx = 1;
    while ishape0 < num_elements  % num_elements TARGET SHAPES
        fn = strcat(shape0_path,shape0_list(ishape0_idx).name);
        if strcmp(fn(end-2:end),'png') 
            shape0_img = im2double(rgb2gray(imread(fn)));
            ishape0 = ishape0+1;
            ishape0_idx = ishape0_idx+1;
        else
            ishape0_idx = ishape0_idx+1;
            continue
        end
    
        
    fn='XXX';
    ishape1_composition = 6; % 1 DISTRACTOR COMPOSITION (RANDOM)
    while ~strcmp(fn(end-2:end),'png') 
        ishape1_composition_random_idx = max(min(ceil(rand*length(shape1_composition_list)),length(shape1_composition_list)),1);
        fn = strcat(shape1_composition_path,shape1_composition_list(ishape1_composition_random_idx).name);
    end
    shape1_composition_img = im2double(rgb2gray(imread(fn)));
    shape1_scatter = 1;

    
    ishape1 = 0; 
    ishape1_idx = 1;
    while ishape1 < num_elements % num_elements-1 DISTRACTOR SHAPES
        fn = strcat(shape1_path,shape1_list(ishape1_idx).name);
        if strcmp(fn(end-2:end),'png') 
            shape1_img = im2double(rgb2gray(imread(fn)));
            ishape1 = ishape1+1;
            ishape1_idx = ishape1_idx+1;
        else
            ishape1_idx = ishape1_idx+1;
            continue
        end
        if ishape1 == ishape0
            continue
        end
        
    shape0_composition_scale    = window_size/1.8 + (rand-0.5)*window_size/3;
    
    shape0_scale                = shape0_composition_scale*1/8 + (rand-0.5)*shape0_composition_scale*1/20;
    shape0_density              = 50*15/shape0_scale;
    shape0_force                = 2;

    shape1_composition_scale    = window_size/1.8 + (rand-0.5)*window_size/3;

    shape1_scale                = shape1_composition_scale*1/8 + (rand-0.5)*shape1_composition_scale*1/20;
    shape1_density              = 50*15/shape1_scale;
    shape1_force                = 2;
    
    tic
    [img_out,~, ~]  =...
                ...
                generate_img(window_size, pad_thickness, shrinkage_rate, shrinkage_base, orientation_randomize,...
                             shape0_density, shape1_density,...
                             shape0_force, shape1_force,...
                             shape0_img, shape1_img,...
                             shape0_scale, shape1_scale, ...
                             shape0_composition_img, shape1_composition_img,...
                             shape0_composition_scale, shape1_composition_scale,...
                             shape1_scatter);
    toc
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
    num_total_imgs_generated = num_total_imgs_generated+1;
    
    if mod(num_total_imgs_generated,1)==0
        fprintf(strcat('     Number of total images saved: ',num2str(num_total_imgs_generated),'\n'));
    end
    
    
    end
    end
    end
end
end
                            
