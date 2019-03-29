* Breast Cancer data;
data Cancer; 
infile '/home/lavos840/data.csv' firstobs=2 dlm=","; 
input id	diagnosis $	radius_mean	texture_mean	perimeter_mean	area_mean	
			smoothness_mean	compactness_mean	concavity_mean	concave_points_mean	
			symmetry_mean	fractal_dimension_mean	radius_se	texture_se	perimeter_se	
			area_se	smoothness_se	compactness_se	concavity_se	concave_points_se	
			symmetry_se	fractal_dimension_se	radius_worst	texture_worst	
			perimeter_worst	area_worst	smoothness_worst	compactness_worst	
			concavity_worst	concave_points_worst	symmetry_worst	fractal_dimension_worst;
run;
proc print data= cancer; run;
* The data are not normally distributed.  Take the log of each parameter and replot.;
data Cancer2;
set Cancer;
radius_mean = log(radius_mean);
texture_mean = log(texture_mean);
perimeter_mean = log(perimeter_mean);
area_mean = log(area_mean);
smoothness_mean = log(smoothness_mean);
compactness_mean = log(compactness_mean);
concavity_mean = log(concavity_mean);
concave_points_mean = log(concave_points_mean);
symmetry_mean = log(symmetry_mean);
fractal_dimension_mean = log(fractal_dimension_mean);
radius_se = log(radius_se);
texture_se = log(texture_se);
perimeter_se = log(perimeter_se);
area_se = log(area_se);
smoothness_se = log(smoothness_se);
compactness_se = log(compactness_se);
concavity_se = log(concavity_se);
concave_points_se = log(concave_points_se);
symmetry_se = log(symmetry_se);
fractal_dimension_se = log(fractal_dimension_se);
radius_worst = log(radius_worst);
texture_worst = log(texture_worst);
perimeter_worst = log(perimeter_worst);
area_worst = log(area_worst);
smoothness_worst = log(smoothness_worst);
compactness_worst = log(compactness_worst);
concavity_worst = log(concavity_worst);
concave_points_worst = log(concave_points_worst);
symmetry_worst = log(symmetry_worst);
fractal_dimension_worst = log(fractal_dimension_worst);
run;

* Plot the data ;
ods graphics;
ods layout gridded columns=10 advance=table rows= 6;
proc univariate data= Cancer2 noprint;
hist radius_mean texture_mean perimeter_mean area_mean smoothness_mean compactness_mean 
	   concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean radius_se 
	   texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
	   concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst 
	   perimeter_worst area_worst smoothness_worst compactness_worst concavity_worst 
	   concave_points_worst symmetry_worst fractal_dimension_worst;
run;
proc univariate data= Cancer2 noprint;
qqplot radius_mean texture_mean perimeter_mean area_mean smoothness_mean compactness_mean 
	   concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean radius_se 
	   texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
	   concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst 
	   perimeter_worst area_worst smoothness_worst compactness_worst concavity_worst 
	   concave_points_worst symmetry_worst fractal_dimension_worst / normal(mu=est sigma=est color=red l=2);
run;
ods layout end;


* Principal component analysis;
proc princomp plots=all data=Cancer2 cov out=pca;
      var radius_mean texture_mean perimeter_mean area_mean smoothness_mean compactness_mean 
	   concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean radius_se 
	   texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
	   concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst 
	   perimeter_worst area_worst smoothness_worst compactness_worst concavity_worst 
	   concave_points_worst symmetry_worst fractal_dimension_worst;
run;
* Standardized (should probably use this one);
proc princomp plots=all data=Cancer2 out=pca;
      var radius_mean texture_mean perimeter_mean area_mean smoothness_mean compactness_mean 
	   concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean radius_se 
	   texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
	   concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst 
	   perimeter_worst area_worst smoothness_worst compactness_worst concavity_worst 
	   concave_points_worst symmetry_worst fractal_dimension_worst;
run;
proc print data= pca; run;

* Logistic regression using pca;
proc logistic data = pca;
class  Diagnosis / param = ref;
model Diagnosis(event = "M") = prin1 prin2 prin3 prin4 prin5 prin6 / lackfit ctable;
output out=Probs predprobs= i lower=lcl upper=ucl;
run;
proc print data= Probs;
title 'Predicted Probabilities and 95% Confidence Limits';
run;