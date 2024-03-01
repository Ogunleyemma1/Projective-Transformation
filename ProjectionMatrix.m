
%Function to compute the projection matrix of Object and Image Points
function ProjectionMatrix

%Enter the object coordinate 6 points

ObjectX1 = [100, 200, 0];
ObjectX2 = [300, 200, 0];
ObjectX3 = [300, 0, 200];
ObjectX4 = [100, 0, 200];
ObjectX5 = [0, 200, 200];
ObjectX6 = [0, 200, 100];

%Enter the Image Coordinate point

Image = imread("a1.jpg");
figure, imshow(Image);
[ImageX, ImageY] = ginput(6);

%Computing the midpoint of the object

Obj1 = [ObjectX1(1,1), ObjectX2(1,1), ObjectX3(1,1), ObjectX4(1,1), ObjectX5(1,1), ObjectX6(1,1)];
Obj2 = [ObjectX1(1,2), ObjectX2(1,2), ObjectX3(1,2), ObjectX4(1,2), ObjectX5(1,2), ObjectX6(1,2)];
Obj3 = [ObjectX1(1,3), ObjectX2(1,3), ObjectX3(1,3), ObjectX4(1,3), ObjectX5(1,3), ObjectX6(1,3)];
ObjectMean = [mean(abs(Obj1)), mean(abs(Obj2)), mean(abs(Obj3))];
disp("The mean of the object is");
disp(ObjectMean);

% Computing the midpoint of the image

ImageMean = [mean(abs(ImageX)), mean(abs(ImageY))];
disp("The mean of the Image is");
disp(ImageMean);

% Making the midpoint as origin for the for the Object

ObjectTranslated = [Obj1-ObjectMean(1,1); Obj2-ObjectMean(1,2); Obj3-ObjectMean(1,3)];
disp("The Object Translated Points are");
disp(ObjectTranslated);


% Making the midpoint as origin for the for the Image

ImageTranslated = [ImageX-ImageMean(1,1), ImageY-ImageMean(1,2)];
disp("The image translated points are");
disp(ImageTranslated);

%Computing the the mean of the translated object

ObjectScaled = [mean(abs(ObjectTranslated(1,:))), mean(abs(ObjectTranslated(2,:))), mean(abs(ObjectTranslated(3,:)))];
disp("The value of the Object scaling is");
disp(ObjectScaled);

%computing the mean of the translated image

ImageScaled = [mean(abs(ImageTranslated(:,1))), mean(abs(ImageTranslated(:,2)))];
disp("The value of the image scaling is");
disp(ImageScaled);


%Computing the Object TRanslated and Scaled Matrix  

ObjectTranslatedMatrix = [1, 0, 0, -ObjectMean(1,1);
                          0, 1, 0, -ObjectMean(1,2);
                          0, 0, 1, -ObjectMean(1,3);
                          0, 0, 0, 1              ];



ObjectScaledMatrix = [1/ObjectScaled(1,1), 0, 0, 0;
                         0, 1/ObjectScaled(1,2), 0, 0;
                         0, 0, 1/ObjectScaled(1,3), 0;
                         0,  0,   0,               1];

disp("The object translated matrix is");
disp(ObjectTranslatedMatrix);

disp("The object scaled matrix is");
disp(ObjectScaledMatrix);

%Computing the Transformation matrix of the object


ObjectT = ObjectScaledMatrix * ObjectTranslatedMatrix;


disp("The object Transformation matrix is");
disp(ObjectT);



%Computing the Image TRanslated and Scaled Matrix 

ImageTranslatedMatrix = [1, 0,  -ImageMean(1,1);
                          0, 1, -ImageMean(1,2);
                          0, 0, 1             ];



ImageScaledMatrix = [1/ImageScaled(1,1), 0, 0;
                     0, 1/ImageScaled(1,2), 0;
                     0,  0,               1];


disp("The Image translated matrix is");
disp(ImageTranslatedMatrix);

disp("The Image scaled matrix is");
disp(ImageScaledMatrix);

%Computing the Transformation matrix of the Image

ImageT = ImageScaledMatrix * ImageTranslatedMatrix;

disp("The Image Transformation matrix is");
disp(ImageT);


%Computing the object conditioned Coordinates

Obj1Conditioned = ObjectTranslated(1,:) *  ObjectT(1,1);
Obj2Conditioned = ObjectTranslated(2,:) * ObjectT(2,2);
Obj3Conditioned = ObjectTranslated(3,:) * ObjectT(3,3);

ObjectConditioned = [Obj1Conditioned; Obj2Conditioned; Obj3Conditioned];

disp("The object Transformed coordinates are");
disp(ObjectConditioned);

%Computing the Image Conditioned Coordinates

ImageConditioned = [ImageTranslated(:,1) * ImageT(1,1), ImageTranslated(:,2) * ImageT(2,2)];

ImageConditioned = transpose(ImageConditioned);

disp("The image Transformed coordinates are");
disp(ImageConditioned);

%Computing the Design Matrix

A = zeros(2 * size(ObjectConditioned, 2), 12);

for i = 1:size(ObjectConditioned,2)
    
    A(2 * i-1, :) = [-ObjectConditioned(1, i), -ObjectConditioned(2, i), -ObjectConditioned(3, i), -1, 0, 0, 0, 0, ObjectConditioned(1, i) * ImageConditioned(1, i), ObjectConditioned(2, i) * ImageConditioned(1, i), ObjectConditioned(3, i) * ImageConditioned(1, i), ImageConditioned(1, i)];
    A(2 * i, :) = [0, 0, 0, 0, -ObjectConditioned(1, i), -ObjectConditioned(2, i),-ObjectConditioned(3, i), -1, ObjectConditioned(1, i) * ImageConditioned(2, i), ObjectConditioned(2, i) * ImageConditioned(2, i), ObjectConditioned(3, i) * ImageConditioned(2, i), ImageConditioned(2, i)];
   
    disp(A);
   
end


[U, D, V] = svd(A);

disp("The value of V is");
disp(V);

P = transpose(V(:,end));

% Computing the projection matrix

P = reshape(P, 4, 3)';

%Performing reverse conditioning 

Pmatrix = inv(ImageT) * P * ObjectT;

Pmatrix = Pmatrix(:,:)/Pmatrix(end,end);

disp("The projection matrix is obtained as:");
disp(Pmatrix);


PMatrixInterpretation(Pmatrix);

end






function PMatrixInterpretation(Pmatrix)

%converting the Projection matrix PMatrix into Matrix M

M = [Pmatrix(1,1:3); Pmatrix(2,1:3); Pmatrix(3,1:3)];


%Normalization of the matrix M we use the sign of the Determinant and
%Magnitude of the last row

Determinant = det(M);

disp(Determinant);

LastRow = M(end,:);

Magnitude = norm(LastRow) * sign(Determinant);

normalizedM = M/Magnitude;

disp(normalizedM);


%Applying the QR Theorem to obtain the callibration and rotation matrix

[Q, R] = qr(inv(normalizedM));

RMatrix = inv(Q);
KMatrix = inv(R);

for i = 1:min(size(KMatrix))

    if KMatrix(i, i) < 0;

        KMatrix(i, i) = -KMatrix(i,i);

        RMatrix(:, i) = -RMatrix(:, i);
    end
end


disp("The Rotation Matrix is:");
disp(RMatrix);

disp("The Calibration Matrix is:");
disp(KMatrix);


%Calculation of the Objecct Projection Center C applying SVD

[U, D, V] = svd(Pmatrix);


C = V(:,end);

C = transpose(C)/C(end,end);

disp("The Projection Center of the Object is:");
disp(C);


end





