# Monolayer
Analysis code for myxo monolayers

# Director field 

   * =alldfields(datapath)=
      * Note: Will take a while to run.
      * Select an experiment from the datapath set initially and run dfield function (below) on all frames in that experiment.
      * Uses &sigma; = 13 gaussian filter for smoothing image gradients.
   * =dfield(fpath,t,n)=
      * *Inputs:*
         * fpath - path to an experiment.
         * t - time point to calculate the director field at.
         * n - value of &sigma; for gaussian smoothing of image gradient.
      * *Outputs:*
         * Saves the director field for the input experiment folder (fpath) and time to the analysis/dfield folder inside of the experiment folder as an array of floats.
---
   * =dcorr(datapath)=
      * Calculates the correlation between randomly selected points for all expts and times.
      * Plots it vs x,y or vs r, or for each experiment separately.
---
   * =allorder(datapath)=
      * Calculates and saves order field for all frames of all experiments.
      * Order is 2*&Delta;&theta; - 1, where &Delta;&theta; is the angle between all directors within 0.5&mu;m of the center and the preferred direction at each pixel.
   * =S = findS(fpath,t,r)=
      * Calculates local order field of fpath experiment at time t with a box size of r. 
      * Finds the smallest eigenvalue of a structure tensor.
---
   * =Sbulk(datapath)=
      * Calculates the average local order parameter in the bulk of the monolayer (away from defects).
      * Plots it with different box sizes.

---
   * =save_defs(datapath)=
      * Finds and track all defects in all experiments using =adefs = alldefects(fpath)=
      * Saves them as structures in a =adefs.mat= file for each experiment.
   * =adefs = alldefects(fpath)=
      * Uses =defs = finddefects(fpath,t)= to find defects within each frame of experiment fpath.
      * Tracks all defects in the given experiment through the experiment, and returns it in a structure adefs.
   * =defs = finddefects(fpath,t)= 
      * Locates all defects in =fpath= at time =t=.
      * Calculates their centers, charges, and symmetry axes, and returns it in structure =defs=.
---
   * =allorder=
      * Select experiment folder.
      * Runs nemorderfield function (below) for all time points in the experiment.
   * =nemorderfield(fpath, t)=
      * *Inputs:*
         * fpath - path to folder with experiment in it.
         * t - time to calculate order at.
      * *Outputs:*
         * Saves local order field into experiment folder /analysis/order/ as an array of floats.
---
   * =mS = calcS(A)=
      * *Inputs:*
         * A - array to calculate order of.
      * *Outputs:*
         * mS - average order of the array in A.
---

   * =S = Sfield(dfield,a)=
      * *Inputs:*
         * dfield - director field to calculate the order field of.
         * a - size of box around each pixel to use for order calculations.
      * *Outputs:*
         * S - order field of =dfield= with box size =a=.
   * =S0 = SPhysLC(dfield,a)=
      * *Inputs:*
         * dfield - director field to calculate the order field of.
         * a - size of box to break image into before calculating order of each box.

---

   * =defSprofile=
      * Calculates average S around all defects of each charge.

---

   * =Svideo=
      * Creates a movie of S for different box sizes.

# Defects
   * =defs = finddefects(fpath,t)=
      * *Description:*
         * Finds the x, and y coordinates, charges and directions of defects in the experiment at time t.
      * *Inputs:*
         * fpath - experiment location
         * t - time point
      * *Outputs:*
         * defs - structure of all the defects at time t contains the following for each defect:
            * x - x coordinate of defects.
            * y - y coordinate of defects.
            * q - defect charge
            * d - 2 element array with x and y components of defect direction.
   * =adefs = alldefects(fpath)=
      * *Description:*
         * Uses the finddefects function for all time points in the experiment and tracks defects between frames.
      * *Inputs:*
         * fpath - experiment location
      * *Outputs:*
         * adefs - structure with the following properties for all defects in the experiment:
            * x, y, q, d - see above, location, charge, and direction of defects.
            * tt - actual time into the experiment where the defect existed (in seconds).
            * ts - time point in experiment where the defect exists (in frames).
            * id - tracking id for defects connecting defects them across frames.
---
# Defect Analysis

   * =[dt, dr, qq] = defmsd(datapath)=
      * *Description:*
         * Calculated the displacement of defects over all times along it's path.
      * *Inputs:*
         * datapath - path to the folder with all of the experiments in it (from =setup=).
      * *Outputs:*
         * dt - time difference associated with each dr, calculated for every pair of frames for each defect.
         * dr - the distance that the defect moved between each pair of frames with time given by dt.
         * qq - the charge of each defect with each dt, and dr.
   * =plotdefsdheatmap(datapath)=
      * *Description:*
         * Plots a heat map of all of the dr vs. dt values calculated for positive and negative defects.
      * *Inputs:*
         * datapath - path to the folder with all of the experiments in it (from =setup=).
      * *Outputs:*
         * Plot of the heat map of dr vs dt on a log log scale for both positive and negative defects.
   * =defectvelcorr(datapath)=
      * *Description:*
         * Plot the rotational correlation function of defect directions.
      * *Inputs:*
         * datapath - path to the folder with all of the experiments in it (from =setup=).
      * *Outputs:*
         * Mean square angular deviation with variance as error bars, on log log scale with example lines at slope of 1/2 and 1.
         * Angular correlation function (mean of the dot product between defect direction at _t_ and _t+&tau;_. Again with variance as errorbars.
         * Plot of the distribution of angular deviation after time &tau; in the grayscale as a probability, over a range of &tau; values, for positive defects.
         * Plot of the distribution of angular deviation of positive defects (red) and negative defects (blue) after 1 frame and 30 frames.
   * =defectvelcorrall(datapath)=
      * *Description:*
         *  Plot the angular deviation over different time intervals, for different amounts of averaging, and velocity as well as direction.
      * *Inputs:*
         * datapath - path to the folder with all of the experiments in it (from =setup=).
      * *Outputs:*
         * Lots of plots of the deviation of the direction averaged over different numbers of frames, also with the mean fitted to a line.
         * Lots of plots of the change in defect velocity direction same as above but for movement of defects not directions.
   * =[ppr,pnr,nnr,dr] = defectinteractions(datapath)=
      * *Description:*
         * Calculate and plot the pair correlation function (distribution of distances between defect pairs) of different types of pairs.
      * *Inputs:*
         * datapath - path to the folder with all of the experiments in it (from =setup=).
      * *Outputs:*
         * Plot of the pair interaction energy between +/+ +/-, and -/- defect pairs.
         * ppr - all distances between +/+ defect pairs
         * pnr - all distances between +/- defect pairs
         * pnn - all distances between -/- defect pairs
         * dr - distances between randomly generated pixel points for normalization.

  * =numbers=
      * Prints out the total number of tracked defect of each charge.
      * Also the total number of frames within all defect tracks.

---

   * =defectinteractions_angles(datapath)=
      * Calculate and display orientational relationship between all pairs of defects.
   * =[ppr,pnr,nnr,dr] = defectinteractions_distance(datapath)=
      * Calculates g(r) the distribution of distances between pairs of defects of each charge combination.
      * Plots the interaction energy from that for each type of pair (like, or opposite charges).
   * =defsarounddefs=
      * Plots cartoon of defect orientation between oppositely charged pairs at different location around eachother.
    
---

   * =[dt,dr,dq] = defmsd(datapath)=
      * *Inputs:*
         * datapath - path to all experiments.
      * *Outputs:*
         * dt - time change.
         * dr - square displacement.
         * qq - defect charge.
      * Each i-th entry in the three outputs go together.
   * =plotmsd=
      * Runs =defmsd= and plots the output.
   * =plotdefsdheatmap=
      * Similar to =plotmsd= but plots a heatmap of all square displacements instead of the mean.
   * =directedmotion(datapath)=
      * Plots distributions of the angle between the direction a defect moves and it's axis of symmetry.
      * Also plots a histogram of the defect speed.
   * =defectvelcorr=
      * Autocorrelation of defect symmetry axes vs time.
   * =defectvelcorrall=
      * Autocorrelation of defect symmetry axes as well as defect velocity.
      * Averaged over different time windows and plotted.

---

   * =defectSprofile(datapath)=
      * Calculates the average order around each type of defect.
      * Plots the average order profile around each type of defect, or averaged over angles (S vs. r).
   * =defectshape=
      * Uses the average director field around each type of defect to find the average deviation from perfectly oriented defects.
---
# Layers

   * =edgevals(fpath)=
      * *Inputs:*
         * fpath - path to experiment.
      1 Select a point on the graph
      1 Look at displayed edges calculated from selected point.
      1 Answer the question in the menu - The goal is to have all layer edges marked with no gaps, and not too much extra crap on the image.
      1 It will now display the selected point on the scatter plot:
         * Red - Didn't work
         * Blue - Worked
         * Green - Worked really well - size scales with number of layered regions found.
      1 Repeat until you have a good idea of what parameter values work well.
   * =ed = layeredges(fpath, t, sfactor, clsize)=
      * *Inputs:*
         * fpath - experiment location.
         * t - time.
         * sfactor - Threshold for edge detection.
         * clsize - Size of the disk element for imclose function on edges.
      * *Outputs:*
         * ed - binary image of edge locations.
   * =alldifs = labellayers(fpath,sf,cl)=
      * *Description:* Displays and high lights neighboring layers. Select the one that is higher up or even. Uses the edge detection found in previous steps.
      * *Inputs:*
         * fpath - experiment location.
         * sf - threshold for edge detection.
         * cl - size of disk for imclose function on edges.
      * *Outputs:*
         * alldifs - 4 lists of height changes as cells (alldifs{i} to get at i<sup>th</sup>list):
            1 List of height changes for step ups.
            1 List of height changes for same layer (no change).
            1 List of height changes for step downs.
            1 List of height changes for ambiguous steps.
   * =[mask, surrs] = surrlays(P,layer,XYcal)=
      * *Description:* Takes in a region (=P=) of connected pixels generated from regionprops (for a particular layer) and returns a mask of that region as well as a mask of the 5 microns around that region.
      * *Inputs:*
         * P - Region to get a mask for.
         * layer - Image of the layer (used just for finding size for the masks to return).
         * XYcal - XY calibration factor for converting surrounding pixels to &mu;m (to return a 5&mu;m surrounding area mask).
      * *Outputs:*
         * mask - mask of region defined in P.
         * surrs - mask of 5&mu;m wide region around the input region P.
   * =dhs = finddh(fpath,sf,cl,dt)=
      * *Description:* Calculates a list of height changes that exist across layer edges with given parameters.
      * *Inputs:*
         * fpath - experiment location
         * sf - threshold for layer edge detection.
         * cl - disk radius for imclose function on edges.
         * dt - time steps to skip over (1 will result in the most data and take the longest to run.
      * *Outputs:*
         * dhs - a list of many height changes that are found across layer edges.
   * =findlayers(fpath, t, hl, sf, cl)=
      * *Description:* Calculates the layers for experiment in fpath at time t with the given parameters and saves it.
      * *Inputs:*
         * fpath - experiment location
         * t - time point
         * hl - average step size between layers/ threshold for labeling layer differences across edges.
         * sf - edge detection threshold.
         * cl - disk radius for imclose function on edges.
      * *Outputs:*
         * Saves image as a binary file into the fpath/analysis/layers/ folder with the name from the time t, size 768x1024 of type int8
   * =[laylab, dhs] = layersbystep(mask, surrs, layer, h, XYcal, hl)=
      * *Description:* Calculates the average layer count of a mask based on the labeled layers around it and the height differences.
      * *Inputs:*
         * mask - mask of layer that we want a label for
         * surrs - mask of already labeled surrounding areas.
         * layer - layer labels for all the layers that have already been labeled.
         * h - height map for the entire image.
         * XYcal - XY calibration factor
         * hl - average step size between layers / threshold for labeling layer differences across edges.
      * *Outputs:*
         * laylab - most likely layer count based on step sizes between the layer and the surrounding areas and labels of surrounding areas.
         * dhs - step sizes between mask and all its neighboring regions.
   * =medianlayers(fpath)=
      * *Description:* Does a median filter of layer counts across times.
      * *Inputs:*
         * fpath - experiment location
      * *Outputs:*
         * Saves medianed layers to fpath/analysis/mlays as a array that is 768x1024 of 'int8' s.
   * =laych = !LayerChanges(fpath,t)=
      * *Description:* Checks for any new layer or holes that are present at time t, but not in the previous frame.
      * *Inputs:*
         * fpath - experiment location
         * t - time point
      * *Outputs:*
         * laych - structure array with the following properties for each layer change that occurs in the current frame:
            * t - time
            * fpath - experiment location
            * x - x coordinate of layer centroid.
            * y - y coordinate of layer centroid.
            * type - 
               * 'create' - a new layer or hole forming 
               * 'destroy' - a hole closing or a layer reabsorbing
            * n - the new layer count after the change happens (i.e. n = 0, o = 1, 'create' is a new hole opening in the monolayer)
            * o - the old layer count before the change happens
            * idx - Index list of pixels in the layer change region.
---
 # Misc. Functions
---
   * =mang = angularmean(thetas)=
      * *Inputs:* 
         * thetas - Array of angles [0 2&pi;]
      * *Outputs:* 
         * mang - average angle, calculated vectorially.
---
   * =fpaths = getfold(datapath)=
      * *Inputs:*
         * datapath - path to folder containing all experiments.
      * *Outputs:*
         * fpaths - structure where each element is the name of an experiment folder.
---
   * =ts = getts(fpath)=
      * *Inputs:*
         * fpath - path to experiment in question.
      * *Outputs:*
         * ts - array of times for the frames in the input experiment.
---
   * =l = laserdata(fpath,t)=
      * *Inputs:*
         * fpath - Path to experiment.
         * t - time point.
      * *Outputs:*
         * l - array (image) of raw laser data.
---
   * =h = heightdata(fpath,t)=
      * *Inputs:*
         * fpath - Path to experiment.
         * t - time point.
      * *Outputs:*
         * h - array (image) of raw height data, calibrated by Z Calibrations in 'info.txt' file in the experiment folder.
---
   * =x = loaddata(fpath, t, dataname, datatype)=
      * *Inputs:*
         * fpath - Path to experiment.
         * t - time point.
         * dataname - name of the data to load (must have a matching folder in the fpath/analysis folder).
         * datatype - the type of data (float, int8, etc... ) of the data to load.
      * *Outputs:*
         * x - an array (image) of the data in experiment fpath at time t, stored in the dataname folder.
---
   * =XYcal = getXYcal(fpath)=
      * *Inputs:*
         * fpath - path to experiment in question.
      * *Outputs:*
         * XYcal - XY calibration factor read from the fpath/info.txt file.
---
   * =n = normalise(im)=
      * *Inputs:*
         * im - grayscale image array.
      * *Outputs:*
         * n - normalized image array between 0 and 1.
---
   * =overlaymaskimr(im,maskg,maskr)=
      * *Inputs:*
         * im - grayscale image
         * maskg - BW mask image to be overlayed in green.
         * maskr - (optional) BW mask to be overlayed in red.
      * *Outputs:*
         * Displays image with masks overlayed on screen.
---
   * =playmovie(F)=
      * *Inputs:*
         * F - matlab movie object / list of frames (from getframe()).
      * *Outputs:* 
         * Opens a gui for playing movie F with a few controls.
   * =playmovie.fig= 
      * Figure object used for playmovie gui (opened when playmovie(F) is called)
---
   * =Zi = quinterp2(X,Y,Z,xi,yi,methodflag)=
      * *Inputs:*
         * X - Input x data.
         * Y - Input y data.
         * Z - Input z data.
         * xi - x data of points to be interpolated to.
         * yi - y data of points to be interpolated to.
         * methodflag - 0 - nearest-neighbor, 1 - triangular-mesh linear interpolation, 2 - Bilinear
      * *Outputs:*
         * Zi - Interpolated z data of X, Y, Z at the points xi, yi.
---
   * =h = xcorr_fft(a, b)=
      * *Inputs:*
         * a - input array.
         * b - input array.
      * *Outputs:* 
         * h - cross correlation of a and b, calculated by fft.
---
   * =p = xcorrpeak(h)=
      * *Inputs:*
         * h - input cross correlation array (output of xcorr_fft(a,b)).
      * *Outputs:*
         * p - peak location of h, found as the peak of a gaussian fit to the brightest pixel and 4 pixels neighboring pixels.
