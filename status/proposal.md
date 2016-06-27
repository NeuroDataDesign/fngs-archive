## Proposal Questionnaire
_______________________________________________________

### Problem Statement

##### What is the broadly important real-world problem (or class of problems) we are going to solve?

The twenty first century has seen the rapid ascent of technology into everyday life. From high performance desktops, to smart phones, to super computers, many industries rely on the power and consistency of computing. Machine learning has furthered their applicability, as computers can be trained to recognize nearly invisible (to the human eye) patterns  In the medical fields, however, many doctors continue to hinge on human power. The psychiatry field, for instance, continues to rely on psychological examinations almost exclusively when determining factors such as rate of development, mental disorder, and overall mental health in millions of patients each year. Standards of care and diagnosis vary widely between psychiatrists, and no quantiative tools exist to aid in their tasks. The brain, while superficially elegant, is an ovewhelmingly complex device consisting of billions of microscopic cells firing in unique patterns to create what we observe as thought. Imaging techniques such as functional Magnetic Resonance Imaging (fMRI) allow us to see these activation patterns in real time at a fine spatial resolution. Unfortunately, processing these graphs is a complex and expensive procedure. Through the Functional Neurodata Graph Service, we will provide a web processing and visualization service to allow researchers to upload their fMRI scans and have them processed with our optimized pipeline using our infrastructure. We will collect graphs and organize them in an easily accessible and visualizable database that is open source for outside investigators. Finally, we will continue the development of analysis methods that will enable computing to become a tool used in the psychological diagnostic sector. 

##### What will be required to solve that problem?

- Data: fMRI resting state scans, fMRI task based scans, patient mental state logs
- Technology: high performance computers/clusters, numerous languages (R, python, HTML, CSS, etc)
- Funding: SIMPLEX
- Societal stuff?: No special needs for adoption

##### What scientific questions will be answered?

How can we maximize pipeline reliability and discriminability while maintaining high performance and memory efficiency?

How many scans does it take and what types of scans (1 rsfMRI, 1 task fMRI, 2 task fMRI and 1 rsfMRI, etc) to reliably diagnose psychiatric disorders?

Can we effectively consider population metrics as they relate to connectivity (ie, can we link intelligence, mental disorders, growth and development rates, etc)?

Is it possible to remove the psychiatric analysis component entirely from psychiatry (ie, can we make a brain scan the most reliable measure to the point where patients don't even need an evaluation)?

Are there people who have brain connectivity that resembles that of a psychiatric disorder, yet don't display the symptoms/haven't been diagnosed? What are the implications (ie, will they be diagnosed? With what probability will they develop the disorder? Etc) of their connectivity on their long term prognosis?

##### What deliverable will we provide to the global citizens?

The team will prepare a pipeline for fMRI processing, a robust and extensive suite of quality control metrics (novel and existing), and a web service for uploading and visualizing processed graphs. Also, the team will create a deployable EC2 instance preoloaded with our ndmg software (integrated fMRI and DTI processing pipeline).

### Feasibility

##### Background

- What is the current state of knowledge regarding this problem? 

To date, a number of resources exist to aid in the development of an fMRI pipeline, however, few aids exist for building an upload tool. A number of groups have attempted to develop robust fMRI processing workflows, and we currently are the only place I know of with an upload service for MRI graphs.  

- What are the key challenges? 

The key challenges are developing the fMRI processing workflow, deciding which modules to include or not include, developing a robust quality control implementation, identifying key features for an upload service, presenting the results to users, compiling statistics that allow comparing brains between individuals, and many others that will arise throughout the design process.  

- Has anyone made a concerted effort to solve the problem? Give examples. 

The Neurodata team has developed a similar effort for DTI graph generation (open source code + upload service), and many other groups such as CPAC, SPM, etc have developed open source code for fMRI pipeline generation.  

- If so, what progress did they make, and why have they not succeeded?

Current attempts to solve this problem are either deficient in the area that they do not implement fMRI processing (the NDMG pipeline at the current time) or that they do not make use of an upload service (CPAC, SPM, etc) for remote graph processing.  

##### Gap

- What gaps in scientific understanding must be bridged in order to solve this problem? 

There are no specific gaps, however there are quite a bit of image analysis techniques we must learn.

- What gaps in technological  capabilities must be bridged in order to solve this problem? 

Remote upload graph processing can be very computationally intensive, however due to the prior experiences of the NDMG pipeline overcoming this will be far less difficult.

- What organizational, financial, and/or technological challenges must be addressed in order to bridge these gaps?

We need to learn more image analysis techniques, as well as to learn Javascript for image visualization.

##### Work

- Why will this approach work? 

This approach will work because our team has the experience and skills necessary, as well as the foundation and support that Neurodata provides.

- Why might it not, and what can be done to mitigate those challenges? 

Lack of motivation and poor scheduling could challenge our success, however due to weekly meetings with Jovo this should not be a problem.

- How will you inspire financial support at the end of the year?

We will demonstrate that open source tools for fmri image analysis are far more valuable than the financial support we would receive.

### Significance

What tangible benefits would the world derive from solving this problem? For each of the below, provide specific/concrete numbers in absolute terms, and provide a meaningful point of reference (e.g., X costs 10 USD per year, which is Y fraction of medical spending)

- Economic
Currently researchers do not have as much access to this type of fMRI research due to computational restrictions which create a need for large technological investments.
- Medical
Medical researchers would have more data from fMRIs readily available to them, improving their knowledge base and ability to statistically analyze fMRIs.
- Scientific
Makes statistical analysis of fMRI data more readily available for scientific research purposes for less of a cost.
- Societal
Any benefits resulting from increased neuroscientific knowledge.
- Which citizens of the world will be affected?
Citizens of developed countries with available internet and where fMRIs are available.
 
### Approach

##### What is the approach for filling these gaps and solving the larger problem?

Use tutorials/demos to learn the necessary libraries. Once we learn about the new image analysis techniques, we can implement these in our upload service. Utilizing prior experience will also help us form the pipeline.


##### What are each of the parts of the approach?

Learn ThreeJS and other Javascript libraries for visualization, and learn more image analysis techniques.

##### How will each of these disparate parts be coordinated to bridge these gaps and then solve the larger problem? 

We will learn both Javascript and more image analysis techniques to create a web based upload service. 

##### How is this approach different from the status quo?

As previously stated, to date, a number of resources exist to aid in the development of an fMRI pipeline, however, few aids exist for building an upload tool. A number of groups have attempted to develop robust fMRI processing workflows, and we currently are the only place I know of with an upload service for MRI graphs.

##### How and when will success be measured/quantified?  Be as specific as possible.

Success for our group will be a published web tool that is functional and effective. Small success will be defined as a minor impact on fMRI processing, and some research groups around the country use our services for their data processing. Medium success will be defined as many research groups using our services for their data processing, and collaborations with groups around the country developed as a result. People will begin to see the value of remote data processing in a research environment. Big success will be a redefinition of fMRI processing, from local cluster processing to cloud based or remote processing on optimized pipelines such as ours, bringing the entire field from a more secluded, within-university or within-grant research methodology towards a global initiative that bridges grants, universities, and national boundaries in a way previously not experienced in the computational neuroscience field. Success can be measured in terms of number of graphs processed, number of groups uploading graphs, number of collaborative papers/citations gained as a result, and volume of usage of our visualization tools.

##### What does success look like at defined points along the roadmap?

- End of Summer: have pipeline complete and process lots of data
 - Middle of June: choice of modules to try incorporating by end of july, and benchmark datasets processed (KKI, NKI, SWU)
 - End of July: update QC from pngs and txt files to html page; choice of modules completed
 - End of August: pipeline completed and ready for release, with all CoRR datasets processed and analyzed
 - End of September: intra-dataset Quality Control page
- End of first semester: have upload service completely integrated
- End of second semester: have visualization tools completely built and summarize project

##### After 10 years, what does moderate success look like? What about huge success?

Moderate success would be significant usage from the scientific and industrial community. Huge success would be enough interest and need to create an fmri imaging company with the technology. 
