# Joint Embedding Basics

+ gives us a combination of factor (orthogonal matrix similar to U), loading (diagonal matrix similar to S), factor ( orthogonal matrix analogous to V*)
+ let each matrix analyzed share factors; vary the loadings
+ r: variable indicating the rank desired of the loadings
  + adjusting r puts us at variable locations in the bias/variance tradeoff
+ feed matrices into JE algorithm given an r to get combination of factors for the entire dataset, and a unique loading for each graph

# How to use
+ use code and example provided by Leo to compute factors/loadings
+ feed factors/loadings through an estimator of p, the parameters for each graph
+ use p to describe each matrix and ignore the individual matrix from that point onwards
+ requires binarized matrices

# Approaches to Consider
+ pass all of subjects' graphs for each condition separately; that is, unique embedding space per class of our data
  + compare factors and loadings between conditions
+ try passing graphs all together and receive a single embedding space for all of the classes, but unique loadings for each graph
  + compare loadings between conditions
+ GLasso:
  + estimates binarized graph from covariance matrix
  + try feeding in task-dependent covariance matrices and see if the binarized matrices given by GLasso compare to those we estimate by simple thresholding
+ parameters to explore
  + graphs embedded by class vs all at once
  + changing r
  + thresholded-binarized correlation matrices as graphs vs. GLasso estimation on covariance matrices
