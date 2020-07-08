# GCLUST Phenotype Extraction Protocol

*July 8, 2020*

**Written by Chi-Hua Chen and Donald Hagler**
**Adapted by Michael Lombardo**

Use this protocol for the analysis of mean cortical thickness and surface area
data within fuzzy cluster ROIs defined based on genetic correlations for the
UK Biobank.

---

### **Extract FreeSurfer measures with cortical surface genetic clusters**

First get the GitHub repo.

```
cd ~/code
git clone https://github.com/mvlombardo/GCLUST.git
```

The `_run_gclust_parcellation.sh` script should be the main one you should use.

You might need to change paths to where your data is located though...

At the end of this script is the call to  `sbatch` to run it in parallel.

The script it calls that does the main bulk is called `gclust_sub.sh`. This
script runs some steps in Freesurfer first, and then goes into MATLAB to run
`gclust_sub.m` for the actual extraction of values for each parcel.

The script intends to run the extraction of GCLUST surface area and thickness
for each individual subject. The end result should be a `gclust_area*.csv` or
`gclust_thickness*.csv` file in the `surface_area` and `cortical thickness`
directories.

In each of the two files called gclust_thickness.csv and gclust_area.csv
there should be 25 columns in each file (the first column is Subject ID, then
12 ROIs for the left hemisphere and 12 ROIs for the right hemisphere).
The values in the csv files are already adjusted for global effects.

If these genetically based parcellations for surface area and cortical
thickness were used, please cite the following papers.

*	[Hierarchical genetic organization of human cortical surface area.](https://www.ncbi.nlm.nih.gov/pubmed/22461613)
	Chen CH, Gutierrez ED, Thompson W, Panizzon MS, Jernigan TL, Eyler LT,
	Fennema-Notestine C, Jak AJ, Neale MC, Franz CE, Lyons MJ, Grant MD, Fischl
	B, Seidman LJ, Tsuang MT, Kremen WS, Dale AM. Science. 2012
*	[Genetic topography of brain morphology.](https://www.ncbi.nlm.nih.gov/pubmed/24082094)
	Chen CH, Fiecas M, Guti�rrez ED, Panizzon MS, Eyler LT, Vuoksimaa E,
	Thompson WK, Fennema-Notestine C, Hagler DJ Jr, Jernigan TL, Neale MC,
	Franz CE, Lyons MJ, Fischl B, Tsuang MT, Dale AM, Kremen WS. PNAS. 2013
