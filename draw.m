function [ new_img, new_mask ] = draw( img, old_mask, region_map, window_size, ...
                                       template0_img, template0_mask, template1_img, template1_mask, ...
                                       template0_density, template0_force,... 
                                       template1_density, template1_force,...
                                       orientation_randomize)
                    
new_mask = old_mask;

% DRAW TARGETS and then DISTRACTORS

num_drawn_template = zeros(1,2);
num_failed_template = zeros(1,2);

if template0_force==0
    template0_force = template0_density*20;
end
if template1_force== 0
    template1_force = template0_density*20;
end

% TARGETS
    draw_which = 2; % targets
    [rows,cols] = find(region_map==1);
while ((num_drawn_template(2) < template1_density) && (num_failed_template(2) < template1_density*template1_force))

    % fprintf(strcat('num drawn targets',num2str(num_drawn_template(2)),' num failed targets',num2str(num_failed_template(2)),'\n'))
    % fprintf(strcat('num target',num2str(template1_density),' num failure tolerated',num2str(template1_density*template1_force),'\n'))
    
    if orientation_randomize~=0
        angle = (rand-0.5)*2*orientation_randomize;
        current_img = imrotate(template1_img,angle,'crop','bilinear');
        current_mask = ceil(imrotate(min(ceil(template1_mask),1),angle,'crop'));
    end
    
    seed = max(min(ceil(rand*length(rows)),length(rows)),1);
    placement_start = [rows(seed) cols(seed)];
    placement_end = [placement_start(1)+size(current_mask,1)-1 placement_start(2)+size(current_mask,2)-1];

    if placement_end(1) <= size(old_mask,1) && placement_end(2) <= size(old_mask,2) 
        new_mask(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) = ...
            old_mask(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) + current_mask;
        if numel(find(new_mask>1))>0
            new_mask = old_mask;
            num_failed_template(draw_which) = num_failed_template(draw_which) + 1;
            % disp(['Shape ',num2str(draw_which),' not drawn ', num2str(num_failed_template(draw_which)) ,' times.'])
        else
            old_mask = new_mask;
            img(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) = ...
                img(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) + current_img;
            num_drawn_template(draw_which) = num_drawn_template(draw_which) + 1;
            % disp(['Shape ',num2str(draw_which),' drawn ', num2str(num_drawn_template(draw_which)) ,' times.'])
        end
    else
        continue
    end
end

% DISTRACTORS
    draw_which = 1; % distractor
    [rows,cols] = find(region_map==0);
while ((num_drawn_template(1) < template0_density) && (num_failed_template(1) < template0_density*template0_force))
    
    if orientation_randomize~=0
        angle = (rand-0.5)*2*orientation_randomize;
        current_img = imrotate(template0_img,angle,'crop','bilinear');
        current_mask = ceil(imrotate(min(ceil(template0_mask),1),angle,'crop'));
    end
    
    seed = ceil(rand*length(rows));
    placement_start = [rows(seed) cols(seed)];
    placement_end = [placement_start(1)+size(current_mask,1)-1 placement_start(2)+size(current_mask,2)-1];
    
    if placement_end(1) <= size(old_mask,1) && placement_end(2) <= size(old_mask,2) 
        new_mask(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) = ...
            old_mask(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) + current_mask;
        if numel(find(new_mask>1))>0
            new_mask = old_mask;
            num_failed_template(draw_which) = num_failed_template(draw_which) + 1;
            % disp(['Shape ',num2str(draw_which),' not drawn ', num2str(num_failed_template(draw_which)) ,' times.'])%%%%%%%%
            % disp(['MAX failure = ', num2str(template0_density*template0_force) ,' times.'])%%%%%%%%
            if num_failed_template(draw_which)==template0_force
                disp('draw: WARNING! NO DISTRACTOR CAN BE DRAWN')
            end
        else
            old_mask = new_mask;
            img(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) = ...
                img(placement_start(1):placement_end(1),placement_start(2):placement_end(2)) + current_img;
            num_drawn_template(draw_which) = num_drawn_template(draw_which) + 1;
            % disp(['Shape ',num2str(draw_which),' drawn ', num2str(num_drawn_template(draw_which)) ,' times.'])
        end
    else
        continue
    end
end


new_img = img;

end

