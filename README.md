# robust-capacity-planning
Data of the instances and results for the paper “Robust Capacity Planning for Project Management” on INFORMS Journal on Computing in 2020.

The folder “Section_4.1” contains the data and results for the test in Section 4.1. Specifically,
1) the folder “Instances” contains the data of the 1250 instances (250 instances for each size)
2) the folder “Solutions” contains the data of the solutions for all the 1250 instances
3) the file “InstanceAnalysis.mat” contains some statistics on the instances
4) the file “ForTable1.m” can output the Table 1 in the paper


The folder “Section_4.2_4.3” contains the data and results for the test in Sections 4.2 & 4.3. Specifically,
1) the folder “Instances” contains the data of 240 instances
2) the folder “Solutions” contains the data of the solutions from different approaches for all the 240 instances
3) the file “UncertaintyOutOfSampleTesting.mat” contains the samples and corresponding probability for the uncertainties, which are for the out of sample test
4) the folder “CostSample” contains the cost samples for each solution (from each of the 4 different approaches for each of the 240 instances), the samples are based on the file “UncertaintyOutOfSampleTesting.mat”
5) the file “CostAnalysis.mat” contains some statistics on the cost samples
6) the file “InstanceAnalysis.mat” contains some statistics on the instances
7) the file “ForFigure1.m” can output the Figure 1 in the paper
8) the file “ForTable2.m” can output the Table 2 in the paper
9) the file “ForTable3and4.m” can output the Table 3 & 4 in the paper


The folder “Section_4.4” contains the data and results for the test in Sections 4.4. Specifically,
1) the folder “Instances” contains the data of 240 instances
2) the file “SamplingDistribution.mat” contains the sampling distribution, which is needed for solving the sampling solution.
3) the folder “Solutions_RN” contains the data of the solutions from RN approach
4) the folder “Solutions_Robust” contains the data of the solutions from our robust approach
5) the folder “Solutions_Sampling” contains the data of the solutions from the sampling approach
6) the folder “Distribution1_WorstCaseDistributionUnderRobustSolution” contains the data of the worst case distribution under the robust solution
7) the folder “Distribution2_WorstCaseDistributionUnderSamplingSolution” contains the data of the worst case distribution under the sampling solution
8) the folder “CostSampleUnderDistribution1” contains the cost samples for the two solutions under distribution 1
9) the folder “CostSampleUnderDistribution2” contains the cost samples for the two solutions under distribution 2
10) the file “ForTable5.m” can output Table 5 in the paper
