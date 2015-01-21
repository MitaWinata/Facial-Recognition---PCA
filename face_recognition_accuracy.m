function accuracies = face_recognition_accuracy(k_pca,testImage,similar_images,testData,trainData)

% Projection matrix from traing datbase
[Proj_tarinData, Labels, firstKEig_vec, mean_train] = MyPca( k_pca ,trainData );
% Face recognition%%
%test image's principal component

phi_j = (double(testImage(:)') - mean_train) * firstKEig_vec;

%on the basis of eucladian distance finding the most similar face in the
%traing database

% finding most similar image from training set
        for j=1:size(Proj_tarinData,1)
            euc_dis(j) = sqrt(sum((Proj_tarinData(j,:)-phi_j).^2));
        end
sorteuc_dis = sort(euc_dis);
        
%find m most similar images to test one
face_index = find(euc_dis <= sorteuc_dis(similar_images));
selected_images = Labels(face_index);

recognised_images = [];

for i = 1:length(selected_images)
    Image = char(selected_images(i));
    similarImg = fullfile(trainData,Image);
    recognised_images = [recognised_images imread(similarImg)];
end

% Sex recognition using Nearest neighbour we craete two sets male and
% female
set_F = {'Flavia','Richa', 'Pramita'};
f_index = [];

for i = 1:length(set_F)
    f_index = [f_index, strmatch(char(set_F(i)), Labels)];
end

female_set = Proj_tarinData(f_index, :);
% male_set = Proj_tarinData(setdiff(1:size(Proj_tarinData, 1), f_index), :);
index_set=1:length(Labels);
index_set(f_index)=[];
male_set = Proj_tarinData(index_set,:)
%finding average distance between test image and male/female
%training set
for k=1:size(female_set,1)
            euclDisF(k) = sqrt(sum((female_set(k,:)-phi_j).^2));
end 
        
for l=1:size(female_set,1)
            euclDisM(l) = sqrt(sum((female_set(l,:)-phi_j).^2));
        end 
             
dis_fem = mean(mean(euclDisF))
dis_m = mean(mean(euclDisM))

sex = 'male';
if (dis_fem < dis_m)
    sex = 'female';
end

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(3, 1, 1);
imshow(testImage);
title('Original image');

subplot(3, 1, 2);
imshow(recognised_images);
title('Similar images');xlabel(sex);

accuracies = [];
for n_images = 1:5
        
    files_read = dir(testData);

Errors = 0;

%to read all the traing images and test images similar to above
%procedure...
for k = 1:length(files_read)
    readFile = files_read(k).name;
    
    if (isempty(strfind(readFile, 'jpg'))) == 0 || (isempty(strfind(readFile, 'png'))) == 0
        imagek = fullfile(testData,readFile);
        test_image = imread(imagek);
        
        phij = (double(test_image(:)') - mean_train) * firstKEig_vec;
         for j=1:size(Proj_tarinData,1)
            eucliDist(j) = sqrt(sum((Proj_tarinData(j,:)-phi_j).^2));
        end
        sortedeucliDist = sort(eucliDist);
        
        ind = find(eucliDist <= sortedeucliDist(n_images));
        
        rec_image = Labels(ind);
        
        p1 = strfind(readFile, '.') - 2;
        
        matched = 0;
        for i = 1:length(rec_image)
           read_im = char(rec_image(i));
           p2 = strfind(read_im, '.') - 2;
           
           if strcmp(readFile(1:p1),read_im(1:p2)) == 1
               matched = 1;
           end
        end
        
        if matched == 0
            Errors = Errors + 1;
        end
    end
end

accuracy = (1 - Errors/size(Proj_tarinData, 1)) * 100;

accuracies = [accuracies accuracy];
    
end

