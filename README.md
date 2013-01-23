indoor-tracking
===============

This is the code and experimental data behind the paper [_Tracking Moving Devices with the Cricket Location System_](http://scholar.google.com/scholar?q=Tracking+moving+devices+with+the+cricket+location+system) (Smith et al, Mobisys 2004).


#### Brief Summary
GPS doesn't work indoors, so in the year 2000 MIT created a project called [Cricket](http://cricket.csail.mit.edu).  It's a system where a device can send ultrasound and radio signals at the same time, so that any receiver can measure its distance to the sender based on the time difference of arrival of the two signals.  (Sound travels about one foot per millisecond, and you can assume here that radio travels instintaneously.)

So the idea is you put a bunch of transmitters at fixed points, and a mobile device can know where it is based on these measurements.  OR you can invert the system and have the moving devices send signals which get collected at the fixed nodes.  Each of these "architectures" present different challenges and tradeoffs.

I implemented a Kalman filter for each of these architectures and introduced a third architecture: a hybrid system that can switch between the _active mobile_ and _passive mobile_ architectures dynamically to take advantage of both.


### The Experiments
We needed experiments that were repeatable and where there was true-north location knowledge so we could measure the error of our systems.  Our team built a train that ran around on a track that had both turns and straight-ways.  The true location of the train was measured using a track counter -- an infared optical sensor that watched each track as it went by.

There's a _lot_ of work in getting a system like this going.  You have to set up your coordinate system, including knowing the location of the fixed nodes, and each train track position.  Each day you have to make sure something didn't get moved overnight by the cleaning staff, etc.  We ran 18 individual trials while writing this paper.  I got pretty good at it!

<img src="http://adamsmith-public.s3.amazonaws.com/Mobisys%202004/Picture%20of%20Cricket%20on%20train.jpg" />

Here's a video of the train running [successfully](http://www.youtube.com/watch?v=ftG3z4EnrD0), and another one of it running [unsuccessfully](http://www.youtube.com/watch?v=gvrx-wPDfaE) : ).

Notes about these videos:
* The wires hanging down from the ceiling are coming from the fixed nodes on the ceiling, down into computers with serial port interfaces that pipe the data over to the laptop.  We took measurements using the wired and with radio-based connections because the RF channel was lossy.
* We ran the train at various speeds.  If you download the data (below), `exp1` was the first set of experiments we did when submitting the paper, and `exp2` was the higher quality set of experiments we did for the camera-ready version.  `exp2` went up to higher speeds, on up to where the train would sometimes fall off the track, as in the video above.


#### Links to the Data
The code in this repo doesn't include the `mat` MATLAB data files that contain the experimental data.  You can download a two different versions of the experimental data:
* [Barebones Data.zip](http://adamsmith-public.s3.amazonaws.com/Mobisys%202004/Mobisys%202004%20Barebones%20Data.zip) (< 1 MB)
* [Full Code and Data.7z](http://adamsmith-public.s3.amazonaws.com/Mobisys%202004/Mobisys%202004%20Code%20and%20Data.7z) (350 MB compressed, 2 GB uncompressed)


#### Getting Started With the Code
* Everything starts with `p.m` (with apologies for the rather undescriptive file name)
* You'll find several different parameters for what gets ran.
* For example, `mode` can be `batchmode` or `simmode`.  Batch mode is for processing data as fast as possible, and sim mode is for visualizing positions, measurements, and estimates.
* Many models are defined (see `modeltype`), as well.
* To get started, change the path of the first line of code to reflect the full path to your download of the Full Code and Data file.
* Then, hit `Run`!

<img src="http://adamsmith-public.s3.amazonaws.com/Mobisys%202004/cricket-visualizer.png" />

* What you see here is the `simmode` running through some experimental data.
* Peruse `p.m` and try tweaking the various options.  Hopefully it becomes somewhat self-explanity from there.


#### Some Notes About the Code
* File and function names are based on the _fixed nodes_.  `min_kalman_passive` is the Kalman filter for the passive-fixed, active-mobile architecture, and `min_kalman` is the Kalman filter for the active-fixed, passive-mobile architecture.
* Notice that in `min_kalman` when the filter reaches a bad state we use multiple distance samples.  This is the hybrid data.
* All operations are _scalars_ operations.  We did this so we could reliably measure the number of multiplications and additions (for figure 19 of the paper), and so we could implement these algorithms in embedded C (which we ended up doing and is in the <a href="http://cricket.csail.mit.edu">latest Cricket code</a>).
* It's been too long for me to remember the exact layout of the code, but some of the things you'll find if you browse it include importing raw experimental data into MATLAB (that's already been done for you), doing grid searches to find the right tuning parameters for the Kalman filters, simulating tracking a moving node in 3D space (this was built before any real-world experiments were done), and I'm sure a bunch of other goodies.


#### Pointers About Data Representations
Load up `code/exp2/post_everything.mat`, as from `p.m` above.  The workspace variable `meta_exp_data` has all of the measurement data that was used for the second round of experiments.

```matlab
>> size(meta_exp_data)
 
ans =
 
           6        3600           6           5
```

The first dimension is the speed of that data, 1-6 ticks.  From there, each element in the second dimension is one period of data.
 
```matlab
>> squeeze(meta_exp_data(3,768,:,:))
 
ans =
 
  1.0e+006 *
 
    2.4203    0.0015    0.0002    0.0000    0.0000
    2.4203    0.0015    0.0002    0.0000    0.0000
    2.4203    0.0015    0.0003    0.0000    0.0000
    2.4203    0.0015    0.0004    0.0000    0.0000
    2.4203    0.0015    0.0003    0.0000    0.0000
         0         0         0         0         0
```

This gives us the 768th record at speed 3.  Each row here is a different measurement from a different fixed node, all of which were made at the same time.  (All of this is active mobile.)  The columns are:
 
`Time, Track Counter Value, Distance (cm), Infra. Node ID, Mobile ID`
 
To get a better look, we can squeeze out the first column (time):

```matlab
>> squeeze(meta_exp_data(3,768,:,2:5))
 
ans =
 
  1.0e+003 *
 
    1.4850    0.2408    0.0010    0.0090
    1.4850    0.2330    0.0020    0.0090
    1.4850    0.2707    0.0030    0.0090
    1.4850    0.3535    0.0040    0.0090
    1.4850    0.3387    0.0060    0.0090
         0         0         0         0
```

The mobile node ID is 9 through all of these experiments, and is stored in the variable `MNid`.  Each fixed node ID is given in `FNid`, and its coordinates is the corresponding row in the variable `c`.  Therefore, if we do:

```matlab
>> [FNid, c]
 
ans =
 
    1.0000   -8.1493  156.4806  226.5947
    2.0000   41.2733   46.1848  226.4765
    3.0000  -42.8013  -14.2321  227.0080
    4.0000 -201.0989   -2.6312  227.5513
    5.0000 -281.3157   48.5801  227.2851
    6.0000 -197.2754  152.1316  226.8116
```

Then we get the ID in the first column and its corresponding `x`, `y`, and `z` in the third column.
 
`counter_max` (256) holds the number of tracks in one orbit, so that we end up mod'ing the counter values with `counter_max`.  `pdata` holds the coordinates of each track counter value (plus one, since MATLAB doesn't do zero-indexing).

`meta_single_exp_data` was used to test the passive mobile architecture.  One random non-zero entry from every period in `meta_exp_data` was chosen to represent that period in `meta_single_exp_data`.  Its structure is therefore the same as `meta_exp_data`, but it does not have the third dimension.