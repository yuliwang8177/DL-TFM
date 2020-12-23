**Deep Learning Traction Force Microscopy**

**Table of Content**

[Introduction](#Introduction)

[Citation](#Citation)

[References](#References)

[User Guide](#UserGuide)

[Requirements](#Requirements)

[Repositories](#Repositories)

[Representation of Vector Fields](#Representation)

[Data Files](#DataFiles)

[Preprocessing of Measured Displacement Fields](#Preprocessing)

[Calculation of Traction Stress from Measured Displacements](#Calculation)

[Folders Containing Data](#DataFolders)

[Folders Containing Functions and Scripts](#FunctionFolders)

**Introduction**

Mechanobiology examines the input and output of mechanical forces by cells. Contractile forces generated by the actin-myosin cytoskeleton are transmitted to the exterior environment via associated trans-membrane proteins such as integrins (1). Referred to as traction forces, these forces are detected predominantly near cell periphery or front in an orientation towards cell center (2). Active forces are located at nascent or maturing focal adhesions near the front while resistive forces are located at mature focal adhesions near the rear (3, 4).

In addition to propelling cell migration, traction forces are believed to perform important functions such as organizing the extracellular matrix (5), probing mechanical properties of the environment (6), and sensing the state of the cell itself such as shape and size (7). Adhesive cells are also keenly sensitive to mechanical forces transmitted via the surrounding matrix (8), fluid shear (9), or cell-cell contact (10). These mechanical signals elicit many profound responses to affect cell migration (11), growth (12), and differentiation (13).

Methods for mapping cellular traction forces, referred to in general as traction force microscopy (TFM; 2, 14, 15, 16), represent a fundamental tool for mechanobiology. TFM is commonly performed by culturing cells on a substrate of elastic material such as polyacrylamide embedded with particle markers for mapping force-induced strains, which are then used for calculating the distribution of stresses. However, while the calculation of strain from stress is straightforward, the inverse calculation is known mathematically as an ill-posed problem, where a unique solution may not exist and the results are prone to artifacts from measurement noise if one simply tries to optimize the fitting between predicted and measured strains (17). To mitigate these problems, most conventional approaches include in the fitting function a regularization term, which is generally a function of the magnitude of traction stress such that minimizing the fitting function balances the accuracy of fitting against noise-induced artifacts and complexity of the solution (2, 17). However, in addition to the compromise in accuracy and resolution, it is difficult to define the weight factor for regularization, represented by a parameter ?, which determines the balance between accuracy and artifacts (18).

Neural network-based deep learning has been deployed as a powerful method for solving ill-posed problems (19). It involves the optimization of a cascade of convolutional operations, with the goal of transforming the input (e.g. the distribution of strains) into the targeted solution (e.g. the distribution of stresses; 20). As an approach fundamentally different from conventional methods, it can avoid the use of regularization and associated compromises.

To deploy deep learning for TFM, we have adapted a neural network for processing images to process the vector fields of stresses and strains. We generated a large set of strain and ground truth stress fields by computer simulation for training the network. By comparing the performance of the resulting neural network and a conventional implementation of TFM, we found that deep learning based TFM are capable of mapping traction stress at a high speed, accuracy, and resolution.

**Citation:** https://www.biorxiv.org/content/10.1101/2020.05.20.107128v1

**References:**

1. Sun, Z., Guo, S.S. &amp; Fassler, R. Integrin-mediated mechanotransduction. _J. Cell Biol._ **215** , 445-456 (2016).
2. Dembo, M. &amp; Wang, Y.-l. Stresses at the cell-to-substrate interface during locomotion of fibroblasts. _Biophys. J._ **76** , 2307-2316 (1999).
3. Beningo, K.A., Dembo, M., Kaverina, I., Small, J.V. &amp; Wang, Y.-l. Nascent focal adhesions are responsible for the generation of strong propulsive forces in migrating fibroblasts. _J. Cell Biol._ **153** , 881-888 (2001).
4. Stricker, J., Aratyn-Schaus, Y., Oakes, P.W. &amp; Gardel, M.L. Spatiotemporal constraints on the force-dependent growth of focal adhesions. _Biophys. J._ **22** , 2883-2893 (2011).
5. Lemmon, C.A., Chen, C.S. &amp; Romer, L.H. Cell traction forces direct fibronectin matrix assembly. _Biophys. J._ **21** , 729-738 (2009).
6. Wong, S.A., Guo, W.-H. &amp; Wang, Y.-l. Fibroblasts probe substrate rigidity with filopodia extensions before occupying an area. _Proc. Natl. Acad. Sci. USA_ **111** , 17176-17181 (2014).
7. Rape, A.D., Guo, W.-H., Wang, Y.-l. The regulation of traction forces in relation to cell shape and focal adhesions. _Biomaterials_ **32** , 2043-2051.
8. Maruthamuthu, V., Sabass, B., Schwarz, U.S. &amp; Gardel M.L. Cell-ECM traction force modulates endogenous tension at cell-cell contacts. _Proc. Natl. Acad. Sci. USA_ **108** , 4708-4713.
9. Baeyens, N., Bandyopadhyay, C., Coon, B.G. &amp; Schwartz, M.A. Endothelial fluid shear stress sensing in vascular health and disease. _J. Clin. Invest._ **126** , 821-828 (2016).
10. Mui, K.L., Chen, C.S. &amp; Assoian, R.K. The mechanical regulation of integrin-cadherin crosstalk organizes cells, signaling and forces. _J. Cell Sci._ **129** , 1093-1100.
11. Lo, C.-M., Wang, H.-B., Dembo, M. &amp; Wang, Y.-l. Cell movement is guided by the rigidity of the substrate_. Biophys. J._ _ **79** __, 144-152 (2000)._
12. Wang, H.B., Dembo, M. &amp; Wang, Y.-l. Substrate flexibility regulates growth and apoptosis of normal but not transformed cells. _Am. J. Physiol. Cell Physiol._ **279** , C1345-C1350 (2000).
13. Engler, A.J., Sen. S. Sweeney, H.L. &amp; Discher, D.E. Matrix elasticity directs stem cell lineage specification. _Cell_ **126** , 677-689 (2006).
14. Sabass, B., Gardel, M.L., Waterman, C.M. &amp; Schwarz, U.S.. High resolution traction force microscopy based on experimental and computational advances. _Biophys. J._ **94** , 207-220 (2008).
15. Schwarz, U.S. &amp; Soin�, J.R.D. Traction force microscopy on soft elastic substrates: a guide to recent computational advances. _Biochim. Biophys. Acta_ **1853** , 3095-3104 (2015).
16. Colin-York, H. &amp; Fritzsche, M. The future of traction force microscopy. _Curr. Opin. Biomed. Eng._ **5** , 1-5 (2018).
17. Schwarz, U.S., Balaban, N.Q., Riveline, D., Bershadsky, A., Geiger, B. &amp; Safran, S.A. Calculation of forces at focal adhesions from elastic substrate data: the effect of localized force and the need for regularization. _Biophys. J._ **83** , 1380-1394 (2002).
18. Huang, Y., Schell, C., Huber, T.B., ?im?ek, A.N., Hersch, N., Merkel, R., Gompper, G. &amp; Sabass, B. Traction force microscopy with optimized regularization and automated Bayesian parameter selection for comparing cells. _Scientific Reports_ **9** , 539 (2019).
19. Adler, J. &amp; Oktern, O. Solving ill-posed inverse problems using iterative deep neural networks. _Inverse Problems_ **33** , 124007 (2017).
20. Goodfellow, I., Bengio, Y. &amp; Courville, A. _Deep Learning_ (MIT Press, Cambridge, 2016).

**User Guide**

**Requirements:** MATLAB 2019b or later capable of performing 3D convolution for neural networks. In addition, installation of the FTTC plugin for ImageJ is recommended for the analysis of substrate strain and for the comparison of deep learning method with a widely used conventional method ([https://sites.google.com/site/qingzongtseng/tfm](https://sites.google.com/site/qingzongtseng/tfm)).

**Repositories:** all the MATLAB programs are distributed via GitHub. Due to the sheer size of the dataset, training and testing data are distributed via Box, using the same folder structure, at [https://cmu.box.com/s/n34hbfopwa3r6rftvtfn4ckc403hk43d](https://cmu.box.com/s/n34hbfopwa3r6rftvtfn4ckc403hk43d). Folders in the data repository should be copied to the corresponding folder locations for the programs. For example, test/elasticity/testData should be moved into the folder test/elasticity as downloaded from GitHub.

**Representation of Vector Fields** : Traction Stress and Resulting Displacements are as tensors of S by S by 2, where S must be 104, 160, or 256. The two channels carry the x and y component of stress or displacement vectors. Displacements are measured in pixels.

**Data Files:** Data files of simulated cells are placed in subfolders named either trainData or testData, in .mat format. These files contain either the stress or displacement field tensors, named as trac and dspl respectively, and x and y coordinates of the cell border, as arrays named brdx and brdy compatible with the MATLAB plot function. Sample experimental data files for NIH 3T3 cells are located in the folder of cells.

**Preprocessing of Measured Displacement Fields:** Pairs of bead images before and after cell removal are first cropped/scaled to form a square image of 104, 160, or 256 pixels, before analyzing the displacements using the PIV plugin of ImangJ (or FiJi). See PIV\_parameters 104.pdf for the parameters for processing 728x728 bead images to generate a text file with a displacement vector every 7 pixels. The resulting .txt file is processed with the command dspl = pivToDspl(pivFn,728,7) to generate the displacement field tensor dspl of 104x104x2, where pivFn is the full path of the .txt file. Coordinates of cell border, brdx and brdy, are generated with the command [brdx,brdy] = txtToBrd(brdFn) where brdFn is the full path of a text file with a single row of text of alternating x and y coordinates separated by spaces. Sample experimental data files for NIH 3T3 cells are located in the folder of cells/processedDataFiles.

The displacement field likely requires additional filtering using the command filtDspl to reduce the noise and residual alignment errors. Type &quot;help filtDspl&quot; for the documentation.

**Calculation of Traction Stress from Measured Displacements:** Apply the functiontrac = predictTrac(dspl,E) where dspl is the displacement field tensor as described above and E is Young&#39;s Modulus of the substrate in the unit of Pascals. The function loads pretrained neural networks in files named tracnet104.mat, tracnet160.mat, or tracnet256.mat, for three difference tensor sizes. Output traction stress is in the unit of Pascals. Neural networks as provided were trained for a Poisson ratio of 0.45.

**Folders Containing Data:**

**cells:** contains experimental data of NIH 3T3 cells, including text files used for generating the displacement fields and cell border. The folder dspl contains displacement generated by PIV then filtered with filtDspl.m.

**test:** contains data of simulated cells for testing the ability of tracnet to predict the traction stress of simulated cells of different shapes, including generic, keratocyte, and neuron. In the subfolder for each shape, cutoff.xlsx contains the percentile traction stress responsible for generating 90% of the total strain energy for each cell, as generated by the script calcCutoff.m. For example, 95 means top 5% of the traction stresses are responsible for generating 90% of the total strain energy. The script calcError.m calculates normalized error against ground truth under no-noise and noisy conditions.

Additional tests are performed under other subfolders:

**elasticity:** simulated generic cells placed on substrates of a Young&#39;s Modulus of 2,500, 5,000, 10,000 20,000, or 40,000 Pascals

**magnification:** traction stresses and corresponding displacements for simulated generic cells are either enlarged or reduced by 25% to simulate the use of different microscope lenses

**sizeScale:** traction stresses and corresponding displacements for simulated generic cells are sampled for an image size of 104x104, 160x160, or 256x256

**tracScale:** traction stresses and corresponding displacements for simulated generic cells are scaled to generate a maximal magnitude of 1,000, 2,000, 4,000, or 8,000 Pascals

**train:** contains data of simulated cells and radial stress patterns used for training the neural network. Each cell is augmented with 8 rotation angles. .m files used for building the network architecture and training the neural network are also included.

**Folders Containing Functions and Scripts (use the help command to retrive documentation):**

**main**

calcDspl.m: calculate displacement field generated by a traction stress field

calcEnergy.m: calculate strain energy of a traction stress field and the resulting displacements

errorDisp.m: calculate normalized error of a displacement field against measured displacements

errorTrac.m: calculate normalized error of a traction stress field against ground truth

filtDspl.m: filter a displacement field to remove alignment errors, apply median filter to exterior vectors, and replace vectors that deviate too much from neighbors

filtTrac.m: filter a traction stress field to remove vectors outside the border (and optionally noise vectors)

plotDspl.m: generate quiver plot and heat map of a displacement field

plotError.m: plot the error of a field against ground truth

plotTrac.m: generate quiver plot and heat map of a traction stress field

predictTrac.m: predict traction stress field from a displacement field

tracCutoff.m: determine the threshold traction stress for generating a specified percentage of strain energy

txtToBrd.m: generate x and y border coordinates from a text file

**piv-fttc**

dsplToTxt.m: convert a displacement field tensor into a text file for input into FTTC ImageJ plugin

fttcToTrac.m: convert the output from FTTC ImageJ plugin into a traction stress field tensor

pivToDspl.m: convert the output from PIV ImageJ plugin into a displacement field tensor

**train**

createTracnet.m: create the neural network architecture for tracnet

plotTrain.m: view training dataset as quiver plots and heat maps

retrainTracnet.m (script): complete training or apply transfer learning to an existing tracnet

trainTracnet.m (script): train tracnet from scratch

**test**

addNoise.m: apply Gaussian noise to a displacement field

(In various subfolders)

calcError.m (script): calculate the normalized root mean squared error of prediction relative to the ground truth, generate an error table TError in the workspace for simulated cells in testData

calcCutoff.m (script): calculate the percentile traction stress responsible for generating 90% of the total strain energy, in subfolders of generic, keratocyte, and neuron. Generate a table of TCutoff in the workspace for simulated cells in testData.

**Cells**

Subfolder data: txt files for cell border and output from the PIV plugin of ImageJ, both over a surface of 728x728 pixels with vectors spaced every 7 pixels. Apply the script dsplGen.m to scale the data down by 7x to generate tightly packed displacement vectors over an area of 104x104

Subfolder dspl: Data generated from the data folder, .mat files of displacement fields and border coordinates of a collection of cells

dsplGen.m (script): process the data folder to generate the files in folder dspl, scaling down the area to 104x104 pixels then filtering the displacement field with filtDspl.m

calcError.m (script): first predict traction stress field from measured displacement field, then use the predicted stress field to generate predicted displacement field and compare against the measured displacement field, calculate normalized mean squared error for each cell in the collection, generate an error table of TError in the workspace

showTrac.m: generate and render the traction stress field of specific cells based on the displacement field found in the dspl folder, also render the magnitude error between predicted and measured displacements
