# MGC Overview
### Eric Bridgeford

## Motivation
* determine scenarios in which one property of data is related to another (simple)
* Features of "Modern" Data
    * Exponentially growing dimensionality of samples
    * structured representations of the data (ie, images, networks, shapes, etc)
    * number of samples does not increase relative the dimensionality of the data
    * non-linear dependencies between properties of the data
    * enormous data requires being acutely aware of computational efficiency
* Failures of Existing Methods
    * require enormous, unrealistic sample sizes to operate on high dimensional data
    * must make tradeoff between local vs global assumptions about the data (ie, is a property going to be necessarily globally consistent? Or can some properties be only locally consistent?)
    * existing local methods require premonition about the scale of the data (must give the metric some insight as to the scale, and results will be highly dependent on this choice)
      * cannot necessarily make direct comparisons or inferences about the impact of the scaling (doesn't give any insight as to which is the "correct" scale to choose)

## Multiscale Generalized Correlation
### Overview
* computes test statistic of interest at ALL scales
  * statistic built to allow direct comparison of statistic at one scale to another
  * easily identify the "optimal" scales 
* takes a K-Nearest Neighbor approach
  * consider scales operating on range of 1:N for N samples
  * smaller scale allows us to optimize for highly nonlinear properties: consider a small locality when computing test statistic
  * larger scale allows us to optimize for more linear properties: compute test statistic considering relationship between properties over entire sample set
* gives us a map of the strength of relationships as a function of scaling
  * allows us to see how the test statistic is dependent on the scale
  * gives flexibility of choosing to optimize for different scales
  * opens the door to comparing global vs local inferences about data
  
### Algorithm Overview (Basic overview; see paper for more in depth reference)
###### Given: two properties measured over entire dataset
###### H<sub>0</sub>: f<sub>xy</sub> = f<sub>x</sub>f<sub>y</sub> (x and y are independent)
###### H<sub>A</sub>: f<sub>xy</sub> != f<sub>x</sub>f<sub>y</sub> (some dependency between x and y exists)
1. Compute distances between all pairs of points for each property
  * "Kernel Trick": allows us to make operations that are natively nonlinear on the given data in a linear fashion
  * choice of kernel function: euclidian distance
2. Center the distance matrices computed in (1)
  * removes dependence of statistic on outliers (otherwise, points far from other points could radically shift our statistic by nature of the distance)
  * standard approach: subtract out the row and column means of each distance matrix
3. Compute a local variant of the distance correlation test
  * K-NN approach discussed above
  * consider correlation over only a fixed number of points (not necessarily the entire sample)
  * Possible Expansion: consider some way to choose an Epsilon-ball approach (ie, determine what an "outlier" actually is and fix yourself to look less than that)
4. Use a nested algorithm to compute local tests
  * allows us to just build on computations we have computed already, as processor time is valuable but memory/hard drive is cheap
  * compute all scales efficiently, which is not necessarily something that was previously possible
5.  Compute p-values and optimal scales
  * For each scale, determine the "power" of that scale (probability of correctly rejecting a false null hypothesis)
  * pick the scales that maximize the power of the test
  * Sample MGC: unknown source distribution
  * Oracle MGC: known source distribution

### Interesting Theorems (Again, just a basic overview of some of the logic)
#### If x is linearly dependent on y, then the global scale is the optimal scale
* makes sense logically, as linear dependencies between x and y means that we won't have any local effects, and therefore we can maximize power by maximizing the size of our clusters, and the largest cluster is obviously the global scale

#### The global scale is not necessarily the best scale
* follows from the previous, under cases of nonlinearity, it will often be the case that a local scale will have higher power than the global scale
* nonlinear relationships means we can potentially gain power by looking at smaller clusters of the data

#### Oracle MGC Dominates its global counterpart
* by the previous two theorems, clear that making a choice between global and local scales is the best option
* want to use more global scales when our relationship we are looking at is more linear; local scales when our relationship we are looking at is more nonlinear
* MGC is the only approach that allows effective selection between the two
  * since MGC considers global and all local scales, it therefore can pick which is best for a particular situation
  * if global is best, it will pick the global
  * if a local option is best, it will pick the best local scale
 
