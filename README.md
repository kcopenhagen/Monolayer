# Monolayer
Analysis code for myxo monolayers



   * Location: Monolayer/Misc. functions
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
