
# Model code for: Short-range interactions govern the dynamics and functions of microbial communities 
## A. Dal Co[a*], S. van Vliet[a,b], D. J. Kiviet[a],  S. Schlegel[a], M. Ackermann[a]

[a] Department of Environmental Systems Science, ETH Zurich, and Department of Environmental Microbiology Eawag, Ueberlandstrasse 133PO Box 611, 8600 Duebendorf, Switzerland

[b] Department of Zoology, University of British Columbia, 4200-6270 University Blvd., V6T 1Z4 Vancouver, Canada 

[*] Corresponding author: alma.dalco@gmail.com


## Description of main solver functions 

### SteadyState_2D_SOR_Solver_2018_CORE[_C_mex]
Core solver of boundary value problem, implements SOR algorithm. 
Code is provided in Matlab format and as MEX function (C implementation of Matlab code, made with CodeBuilder).
The MEX function is called whenever the BVP needs to be solved.

### SteadyState_2D_SOR_Solver_2018 
Parses BVP: sets-up BVP in correct format to be passed on to core solver. 
All routines that solve steady state for defined grid size call this function.

Calls SteadyState_2D_SOR_Solver_2018_CORE_C_mex to solve BVP

### SteadyState_2D_RefineGrid_2018 
Performs grid refining procedure: solves BVP on course grid, then the grid size is doubled in all dimensions and BVP is solved again.
Input from coarse grid is upscaled and used as initial guess for finer grid size.
Procedure is repeated till the calculated growth rates change less than a threshold value.

Calls SteadyState_2D_SOR_Solver_2018 to parse BVP problem

### SteadyState_2D_SingleRun_2018 
Main caller, use to run single simulation and plot output.

Calls SteadyState_2D_RefineGrid_2018

### [...]_ClosedBoundary variants of solver functions 
The following functions have an alternative implementation where all four grid boundaries are closed (von Neumann boundary condition) to implement a fully closed growth chamber where no amino acids are lost. 
- SteadyState_2D_SOR_Solver_2018_CORE_ClosedBoundary
- SteadyState_2D_SOR_Solver_2018_ClosedBoundary
- SteadyState_2D_RefineGrid_2018_ClosedBoundary

These functions are identical to the ones described above, except for the implemented boundary condition.
(Default boundary condition has Dirichlet boundary condition on lower boundary to reflect presence of flow-channel). 


## Description of main helper functions

### SteadyState_2D_SettingsRevision
Contains default parameter values

### SteadyState_2D_InitGrid_2018 
Creates grid of cell types based on input (experimental measured arrangement or on of the default arrangements).
Makes initial guess of I and E based on cell type at grid location.


## Description of auxiliary functions

### estimate_rl
Code used to estimate rl parameter value from experimentally measured maximum growth rate.

### characterizeGrowthProfileSplitWorld
Extract growth profile of both types when both cells occupy half the grid meeting at straight-interface in middle.

### plotGrowthCurveSplitWorld
Plot growth profile of both types when both cells occupy half the grid meeting at straight-interface in middle.

### SteadyState_2D_Calc_CalibrationImagesRealData
Code used to load segmented images of real chambers and convert them to default model grid of 40x40 cells.

Code provided for illustration purposes only, will not run without access to raw data.
Output of code is stored in MeasuredSpatialArrangements.mat file.


### SteadyState_2D_Calc_CalibrationImagesArtificial
Code creates artificial spatial arrangement to run model on.
Can be used to create random spatial arrangement with varying patch sizes.

### SteadyState_2D_Calc_GrowthCurves
Extracts for model data for each cell the calculated growth rate and a vector of the fraction of other cells as function of distance from cell.

### SteadyState_2D_Calc_InteractionGrowthRange
Runs model on experimentally measured spatial arrangements and calculates growth range and interaction range with model

### SteadyState_2D_Calc_GrowthRangeSplitWorld
Calculates growth range from model run where two cell types occupy half of space and meet and straight interface

### fitLinRegressionUltraFastV2
A faster implementation of the Matlab polyfit function for a linear fit (reduced overhead). 

### GR_analytical
Calculates analytical prediction for growth range.

### GR_analytical_fromSettings
Calculates analytical prediction for growth range.
Parses settings structure and calls GR_analytical. 

### find_ru_toUse
Calculates needed uptake rate to obtain desired growth range.

### createConfInterval
Calculates 95% confidence interval for vector data.

### findSignificanceGroupsMultiComp
Helper function to analyse post-hoc multiple comparison test.
Creates groups of observations that are not significantly different. 


## Description of figure generating code
### RunModel_FigX
Code that runs model and stores data file for Figure X.
Each figure panel has its own script.
Output stored in dataFigX.mat files.
These files can be plotted with makeFigX code.

### makeFigX
Reads dataFigX.mat files and reproduces figure panels as shown in manuscript.

### myColors
helper script containing plot colors.

## Description of data files

### experimentalCorrelationAnalysis.mat
Matlab datafile.

Contains correlation as function of radius of experimental data.

### experimentInteractionRange.mat
Matlab datafile.

Contains experimentally measured interaction range.

### experimentalBinnedGrowthRate.mat
Matlab datafile.

Contains experimentally measured binned growth rates.

### experimentalSpatialArrangements.mat
Matlab datafile.

Contains measured spatial arrangements converted to model grid.

### dataFigX.mat
Matlab datafile.

Contains data needed to plot FigX.
Files can be recreates by running RunModel_FigX code.





