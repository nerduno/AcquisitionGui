This is the readme file for the matlab implementation of the online spike
sorting algorithm

version: 1.00

Copyright (c) 2006 by Ueli Rutishauser. urut (---at---) caltech.edu

This software runs both on linux as well as windows. This release is tested
under linux, but should run under windows with minor modifications (pathnames
and neuralynx dlls, see below). My experience is that the memory
management of matlab is much worse under windows, which naturally leads to
''out of memory'' messages even for loading rather small data files.

1) Pre-requisites
=================

1. Matlab, including the statistics and signal processing toolbox. This release is tested with R14-SP3
2. To read Ncs (neuralynx data) files, you need the binaries to read neuralynx files. 
Only the linux version is included in this release; download the windows version from neuralynx.com


2) Introduction
===============

There are two types of files you can process: simulated data and real (neuralynx) data. Other data types
can easily be incorporated by changing the read routines. 

There is no user interface - this software was created to allow automatic processing of
large numbers of files (also, we are working on a realtime version in c++). To facilitate this, all parameters 
are set in a textfile and the results of the sorting (figures) are written as png files for later viewing.
Plotting to png files is much faster than to the screen (when you start matlab without the GUI). If you 
would like to see the figures as the program runs simply start matlab with the GUI and remove the commands 
that close the figures immediately after producing them. There are also a few matlab scripts that allow you to 
later discard, merge and accept clusters after viewing the files.


3) How to get started
=====================

Best thing is to work with the simulated data first. We are providing a file that allows you to reproduce all the figures
for the simulations without changing anything (see below).

First: change the setpath.m file to the directory where you unpacked the code to. After you start matlab, execute this file
first.				

3.1) How to process the simulated data files
============================================

1. modify sortingNew/model/runSimulations.m to point to the correct path for the datafiles.

2. Run runSimulations.m with the default parameters - it will run the first simulation ("simulation 1" in paper) with the 3rd noiselevel
and the approximate method of choosing the threshold. It will plot a number of figures illustrating the result
(Figs 3, 4, 5).

		
3.2 How to process real data files
==================================

Included in this package is a demo data file 'A12.Ncs'. This is a stretch of data (~7min) recorded from a
single microwire implanted in the right amygdala of an epilepsy patient. The data was recorded while the patient
conducted a spatial memory task in a virtual world (see the paper for details). This data is partially the
same as in Figure 7 of the paper, although there the entire 1h segment is included (this file would be too big to include).

1. modify miniGUI/Standalone_textGUI.m to adjust the path parameters. All other parameters can be set in this file. The default parameters
are set such that figures are displayed and not exported (exportFigures setting). However, for real usage, it is advisable to set this
parameter to true and start matlab without the GUI. This is much faster. Also, the stages of the sorting can be run separately (doSorting, doDetection, doFigures). 
Files are stored such that sorting can use a previous detecting stage. Same for production of figures. 


2. run miniGUI/Standalone_textGUI.m . The result will be stored in data/sort and data/figs

4) How to get it running for your own data
==========================================

To get an intuition for the algorithm and the evaluation plots it produces, try playing with the parameters in Standalone_textGUI.m . This is the
main file for changing parameters. One of the critical parameters is the extraction threshold,which,based on noise levels, has to be changed.
For example, if you set a certain extraction level and get strong 60Hz noise in your clusters, it is probably too low. Also if the clusters become
non-separable because of MUA activity. For example, for the demo data file, try setting the extraction threshold to 4 instead of 5.5 as in the
default configuration. You will notice how "sinus-wave" like waveforms start to appear and how you can detect them in the projection plots.

The algorithm produces a substantial amount of debugging output. Also the plotting of all the figures takes time. 
In a real production environemnt it is advisable to export the figures to files and start matlab in textmode only (matlab -nojvm).
After processing is finished, look at the figures in a graphics file viewer like png to evaluate which clusters are good.
This speeds up processing substantially.

5) Copyright
============

We make this source code freely available in the spirit of academic freedom and reproducability of research.
However, it comes with no warranties whatsoever. Use at your own risk. Backup your data before you use it with this
software. We can't guarantee support.

Copyright (c) by Ueli Rutishauser and the California Institute of Technology.
This Research was conducted in collaboration with E.M. Schuman and A.N. Mamelak and funded by the
Gimbel Discovery Fund as well as the Howard Hughes Medical Institute, through the laboratory of E.M. Schuman at
Caltech.

====
