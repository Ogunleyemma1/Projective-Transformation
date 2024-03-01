The three-dimensional reconstruction of objects from images requires that the interior and exterior orientation of the cameras are known.
Acquire one image from an object of your choice and determine the projection matrix using a DLT to reconstruct the geometry of image formation.
Image acquisition: Take one picture of an appropriate calibration object and transfer this image into the computer.
a.) Describe the acquired calibration object in brief.
b.) Specify important technical information of the used camera (i.e. type, resolution, etc.)
Control point measurements: Determine the three-dimensional object coordinates of at least 6 known control points (e.g. by using a folding rule) and their two-dimensional image coordinates.
a.) How did you define the axes of the object coordinate system?
b.) How precise where the object coordinates measured?
Computation of the projection matrix: Implement a function in MATLAB/Octave for spatial resection using the direct linear estimation method of the projection matrix with help of the singular value decomposition.
Interpretation of the projection matrix: Factorize the projection matrix using a RQ-decomposition (norm, qr) and derive all eleven parameters of the interior and exterior orientation.
a.) Explain the meaning of the extracted parameters in brief.
b.) Comment the whole calibration process. How precise is the camera orientation determined and where does the quality depend on?
