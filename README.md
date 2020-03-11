# Social Consequences of Past Compound Events

The aftermath of compound events will be analyzed with the help of Agent Based Modeling to gain a better understanding of the social consequences. 

One example of such a phenomena is the [Laacher See](https://en.wikipedia.org/wiki/Laacher_See) eruption approximately 13,000 years ago located in present-day Germany. Archaeologist Felix Riede believes that this event has caused technological regression. The new inhabitants after the eruption were not as advanced in their toolmaking, even with some losing bow and arrow technology. 

This project was made by Brennen Bouwmeester and Kevin Su with supervision from Felix Riede and Igor Nikolic. 

### Authors

- Brennen Bouwmeester
- Kevin W. Su

## How-To
This model was made using [Netlogo 6.1.1](http://ccl.northwestern.edu/netlogo/).

Please unzip the files "data/gis.zip" and "experiments/Draft Experiments.zip" and put them in their respective folders such that it looks like "data/gis" and "experiments/Draft Experiments" to get the most streamlined experience possible.

Our final report is also included, which includes a more detailed interpretation of our results – including the purpose of this project, and our reasoning, methodology, conclusions, and reflection.

For any further issues please contact the authors. 

### The Model
The model code is split into seperate files which can be found in the "code/" folder to create a better overview of the codes. The main model "compound-events.nlogo" calls upon these files to be run. Furthermore, the model requires an abudance of GIS and climate data which are found in the "data/" folder.

### The Experiments
The experiments are run headless, however, certain modifications had to be made to the Java environment. If you want to replicate these experiments, make sure to change the netlogo-headless file in your NetLogo directory to allow for 3GB of RAM, see [this link](https://github.com/NetLogo/NetLogo/wiki/Optimizing-NetLogo-Runs)

### The Analysis
The analysis files are executed in Jupyter Notebook files (.ipynb) running Python 3.6.5 using general data science packages, such as pandas, numpy, seaborn, and matplotlib, and scipy. The odd package out would be [ema_workbench](https://emaworkbench.readthedocs.io/en/latest/), which is a package developed by the TU Delft for exploratory modelling and analysis. Ideally, we would have used Binder to set these environments up but because it is a private repository at the moment it is not possible. 

There are two analysis files: "experiments/Analysis of Base Experiments.ipynb" which is a very rough draft of the analysis performed, however, it includes our initial interpretation of the data. Furthermore, we have "experiments/Scenario_Analysis.ipynb" which follows the structure of the report in our analysis. 

### Directory

The files below are the important ones for running this analysis and a short description of their respective purpose.

```
---\
    code\ *Code Files used in compound-events.nlogo*
	 0_init.nls to 7_reporters.nls 
    data\
	 gis\ *contains altitude, terrain roughness, landmass shape, temperature, and precipitation data*
	  EPHA\
	  GEBCO\
	  Natural Earth 2\
	  PaleoView\
	 GISP2.csv *Climate Change Data*
    experiments\
	 Draft Experiments\ *Data Results from Experiments Run in NetLogo*
	  base-experiment-trendfalse
	  base-experiment-trendtrue
	 Analysis of Base Experiments.ipynb
	 Scenario_Analysis.ipynb *Stuctured Data Analysis of the Results*
    .gitignore
    
### License
Copyright (C) 2020  Brennen Bouwmeester and Kevin Su

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

