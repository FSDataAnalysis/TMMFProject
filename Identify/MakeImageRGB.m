

%%% Chemical_Number_vector   0.5 is ambiguous , 1 ..N is the chemical
%%% identified
rotate_image_deg=45;

Number_of_pixels_total=length(Chemical_Number_vector);

matrix_chemistry_1=reshape(Chemical_Number_vector, sqrt(Number_of_pixels_total), sqrt(Number_of_pixels_total));

matrix_chemistry_1_norm=matrix_chemistry_1/range(matrix_chemistry_1(:));


matrix_chemistry_1_norm_rot=rot90(matrix_chemistry_1_norm, rotate_image_deg);
imshow(matrix_chemistry_1_norm_rot)

this=0;

