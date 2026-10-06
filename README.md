### The Jurassic Amber Gap
This page holds the custom functions, workflow script, data and plots for the titular manuscript by Seyfullah et al. 202(7?)

## scripts
In scripts you find two **.R** files. (1) **functions.R** holds two custom functions: (1.1) **p.map** is a wrapper around some *rgplates* and *terra* functions which takes an occurrence-data data.frame and partitions it into temporal and spatial bins and returns a set of according metrics, most importantly the number of occurrence counts per spatial-temporal bin and the raster. (1.2) **pal.plot** is a plotting function that takes the output of **p.map** as input.

All functionality needed/used in the Seyfullah et al. 202(7?) paper are in working condition. The functions themselves are/will always be a work-in-progress. 

(2) **workflow.R** is a simple script that produces the plots used in the publication. Outside of the *path* that the user has to specify the script does not require any changes to run.

## data 

In data are two **.csv** files: **conifer_genera_done.csv** contains a list of genera contained within gymnosperma and an identifier for the gymnosperm subgroup. **conis.csv** is a curated PBDB dataset wich is filtered by using only the genera labeled as *conifer* from the **conifer_genera_done.csv**. 

## output plots

Here you find the raw outputs of the **workflow.R** scripts as well as the edited versions used in the publication. The editing is exclusively around the plot margins.


