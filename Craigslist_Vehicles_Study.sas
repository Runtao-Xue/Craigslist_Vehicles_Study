PROC IMPORT OUT= WORK.train
            DATAFILE= "craigs_train_withoutcity.csv"
			DBMS=CSV REPLACE;
			GETNAMES=YES;
			DATAROW=2;
RUN;

PROC IMPORT OUT= WORK.test
            DATAFILE= "craigs_test_withoutcity.csv"
			DBMS=CSV REPLACE;
			GETNAMES=YES;
			DATAROW=2;
RUN;

PROC IMPORT OUT= WORK.original
            DATAFILE= "original.csv"
			DBMS=CSV REPLACE;
			GETNAMES=YES;
			DATAROW=2;
RUN;

PROC IMPORT OUT= WORK.project
            DATAFILE= "clean.csv"
			DBMS=CSV REPLACE;
			GETNAMES=YES;
			DATAROW=2;
RUN;

PROC IMPORT OUT= WORK.model
            DATAFILE= "model.csv"
			DBMS=CSV REPLACE;
			GETNAMES=YES;
			DATAROW=2;
RUN;





ods pdf file='linear regression';
/* Linear Regression*/
proc reg data=train;
title 'Linear Regression';
model price = year odometer lat long manufacturer_acura manufacturer_alfa_romeo manufacturer_aston_martin manufacturer_audi
manufacturer_bmw manufacturer_buick manufacturer_cadillac manufacturer_chevrolet manufacturer_chrysler manufacturer_datsun
manufacturer_dodge manufacturer_fiat manufacturer_ford manufacturer_gmc manufacturer_harley_davidson manufacturer_honda
manufacturer_hyundai manufacturer_infiniti manufacturer_jaguar manufacturer_jeep manufacturer_kia manufacturer_land_rover
manufacturer_lexus manufacturer_lincoln manufacturer_mazda manufacturer_mercedes_benz manufacturer_mercury manufacturer_mini
manufacturer_mitsubishi manufacturer_morgan manufacturer_nissan manufacturer_pontiac manufacturer_porche manufacturer_ram
manufacturer_rover manufacturer_saturn manufacturer_subaru manufacturer_toyota manufacturer_volkswagen manufacturer_volvo
condition_excellent condition_fair condition_good condition_like_new condition_new condition_salvage cylinders_10_cylinders
cylinders_12_cylinders cylinders_3_cylinders cylinders_4_cylinders cylinders_5_cylinders cylinders_6_cylinders cylinders_8_cylinders
cylinders_other fuel_diesel fuel_electric fuel_gas fuel_hybrid fuel_other title_status_clean title_status_lien
title_status_missing title_status_parts_only title_status_rebuilt title_status_salvage transmission_automatic 
transmission_manual transmission_other drive_4wd drive_fwd drive_rwd size_compact size_full_size size_mid_size
size_sub_compact type_SUV type_bus type_convertible type_coupe type_hatchback type_mini_van type_offroad type_other
type_pickup type_sedan type_truck type_van type_wagon paint_color_black paint_color_blue paint_color_brown
paint_color_custom paint_color_green paint_color_grey paint_color_orange paint_color_purple paint_color_red
paint_color_silver paint_color_white paint_color_yellow;
run;
ods pdf close;

/* PCA */
ods pdf file='PCA';
title 'PCA';
proc factor data=train simple corr;
run;

proc factor data=train n=5 score;
ods output StdScoreCoef=Coef;
run;

proc princomp data=drain;
run;

proc stdize method=ustd mult=.44721 data=Coef out=eigenvectors;
   Var Factor1-Factor5;
run;

proc print data=eigenvectors; 
run;

ods pdf close;

/* Mean of original data*/
ods pdf file='original mean';
proc tabulate data = original;
title 'mean of original data';
var price year odometer lat long;
table  price year odometer lat long,(N Mean StdDev Min p25 Median p75 Max);
run;
ods pdf close;

/* Mean of new data*/
ods pdf file='clean mean';
proc tabulate data = project;
title 'mean of clean data';
var price year odometer lat long;
table  price year odometer lat long,(N Mean StdDev Min p25 Median p75 Max);
run;
ods pdf close;


/* LASSO */
ods pdf file='lasso';
title 'LASSO';
proc glmselect data=train testdata=test seed=2 plots=all;
model price = year odometer lat long manufacturer_acura manufacturer_alfa_romeo manufacturer_aston_martin manufacturer_audi
manufacturer_bmw manufacturer_buick manufacturer_cadillac manufacturer_chevrolet manufacturer_chrysler manufacturer_datsun
manufacturer_dodge manufacturer_fiat manufacturer_ford manufacturer_gmc manufacturer_harley_davidson manufacturer_honda
manufacturer_hyundai manufacturer_infiniti manufacturer_jaguar manufacturer_jeep manufacturer_kia manufacturer_land_rover
manufacturer_lexus manufacturer_lincoln manufacturer_mazda manufacturer_mercedes_benz manufacturer_mercury manufacturer_mini
manufacturer_mitsubishi manufacturer_morgan manufacturer_nissan manufacturer_pontiac manufacturer_porche manufacturer_ram
manufacturer_rover manufacturer_saturn manufacturer_subaru manufacturer_toyota manufacturer_volkswagen manufacturer_volvo
condition_excellent condition_fair condition_good condition_like_new condition_new condition_salvage cylinders_10_cylinders
cylinders_12_cylinders cylinders_3_cylinders cylinders_4_cylinders cylinders_5_cylinders cylinders_6_cylinders cylinders_8_cylinders
cylinders_other fuel_diesel fuel_electric fuel_gas fuel_hybrid fuel_other title_status_clean title_status_lien
title_status_missing title_status_parts_only title_status_rebuilt title_status_salvage transmission_automatic 
transmission_manual transmission_other drive_4wd drive_fwd drive_rwd size_compact size_full_size size_mid_size
size_sub_compact type_SUV type_bus type_convertible type_coupe type_hatchback type_mini_van type_offroad type_other
type_pickup type_sedan type_truck type_van type_wagon paint_color_black paint_color_blue paint_color_brown
paint_color_custom paint_color_green paint_color_grey paint_color_orange paint_color_purple paint_color_red
paint_color_silver paint_color_white paint_color_yellow @2
/selection = lasso(choose=cv stop = none) hierarchy=single cvmethod=random(10) showpvalues;
performance buildsscp=incremental;
run;
ods pdf close;

/* Forward */
ods pdf file='forward';
title 'Forward';
proc glmselect data=train testdata=test seed=2 plots=all;
model price = year odometer lat long manufacturer_acura manufacturer_alfa_romeo manufacturer_aston_martin manufacturer_audi
manufacturer_bmw manufacturer_buick manufacturer_cadillac manufacturer_chevrolet manufacturer_chrysler manufacturer_datsun
manufacturer_dodge manufacturer_fiat manufacturer_ford manufacturer_gmc manufacturer_harley_davidson manufacturer_honda
manufacturer_hyundai manufacturer_infiniti manufacturer_jaguar manufacturer_jeep manufacturer_kia manufacturer_land_rover
manufacturer_lexus manufacturer_lincoln manufacturer_mazda manufacturer_mercedes_benz manufacturer_mercury manufacturer_mini
manufacturer_mitsubishi manufacturer_morgan manufacturer_nissan manufacturer_pontiac manufacturer_porche manufacturer_ram
manufacturer_rover manufacturer_saturn manufacturer_subaru manufacturer_toyota manufacturer_volkswagen manufacturer_volvo
condition_excellent condition_fair condition_good condition_like_new condition_new condition_salvage cylinders_10_cylinders
cylinders_12_cylinders cylinders_3_cylinders cylinders_4_cylinders cylinders_5_cylinders cylinders_6_cylinders cylinders_8_cylinders
cylinders_other fuel_diesel fuel_electric fuel_gas fuel_hybrid fuel_other title_status_clean title_status_lien
title_status_missing title_status_parts_only title_status_rebuilt title_status_salvage transmission_automatic 
transmission_manual transmission_other drive_4wd drive_fwd drive_rwd size_compact size_full_size size_mid_size
size_sub_compact type_SUV type_bus type_convertible type_coupe type_hatchback type_mini_van type_offroad type_other
type_pickup type_sedan type_truck type_van type_wagon paint_color_black paint_color_blue paint_color_brown
paint_color_custom paint_color_green paint_color_grey paint_color_orange paint_color_purple paint_color_red
paint_color_silver paint_color_white paint_color_yellow @2
/selection = forward(select=cv) hierarchy=single cvmethod=random(10) showpvalues;
performance buildsscp=incremental;
run;
ods pdf close;

/* Backward */
ods pdf file='backward';
title 'backward';
proc glmselect data=train testdata=test seed=2 plots=all;
model price = year odometer lat long manufacturer_acura manufacturer_alfa_romeo manufacturer_aston_martin manufacturer_audi
manufacturer_bmw manufacturer_buick manufacturer_cadillac manufacturer_chevrolet manufacturer_chrysler manufacturer_datsun
manufacturer_dodge manufacturer_fiat manufacturer_ford manufacturer_gmc manufacturer_harley_davidson manufacturer_honda
manufacturer_hyundai manufacturer_infiniti manufacturer_jaguar manufacturer_jeep manufacturer_kia manufacturer_land_rover
manufacturer_lexus manufacturer_lincoln manufacturer_mazda manufacturer_mercedes_benz manufacturer_mercury manufacturer_mini
manufacturer_mitsubishi manufacturer_morgan manufacturer_nissan manufacturer_pontiac manufacturer_porche manufacturer_ram
manufacturer_rover manufacturer_saturn manufacturer_subaru manufacturer_toyota manufacturer_volkswagen manufacturer_volvo
condition_excellent condition_fair condition_good condition_like_new condition_new condition_salvage cylinders_10_cylinders
cylinders_12_cylinders cylinders_3_cylinders cylinders_4_cylinders cylinders_5_cylinders cylinders_6_cylinders cylinders_8_cylinders
cylinders_other fuel_diesel fuel_electric fuel_gas fuel_hybrid fuel_other title_status_clean title_status_lien
title_status_missing title_status_parts_only title_status_rebuilt title_status_salvage transmission_automatic 
transmission_manual transmission_other drive_4wd drive_fwd drive_rwd size_compact size_full_size size_mid_size
size_sub_compact type_SUV type_bus type_convertible type_coupe type_hatchback type_mini_van type_offroad type_other
type_pickup type_sedan type_truck type_van type_wagon paint_color_black paint_color_blue paint_color_brown
paint_color_custom paint_color_green paint_color_grey paint_color_orange paint_color_purple paint_color_red
paint_color_silver paint_color_white paint_color_yellow @2
/selection = backward(select=cv) hierarchy=single cvmethod=random(10) showpvalues;
performance buildsscp=incremental;
run;
ods pdf close;

/* stepwise */
ods pdf file='stepwise';
title 'stepwise';
proc glmselect data=train testdata=test seed=2 plots=all;
model price = year odometer lat long manufacturer_acura manufacturer_alfa_romeo manufacturer_aston_martin manufacturer_audi
manufacturer_bmw manufacturer_buick manufacturer_cadillac manufacturer_chevrolet manufacturer_chrysler manufacturer_datsun
manufacturer_dodge manufacturer_fiat manufacturer_ford manufacturer_gmc manufacturer_harley_davidson manufacturer_honda
manufacturer_hyundai manufacturer_infiniti manufacturer_jaguar manufacturer_jeep manufacturer_kia manufacturer_land_rover
manufacturer_lexus manufacturer_lincoln manufacturer_mazda manufacturer_mercedes_benz manufacturer_mercury manufacturer_mini
manufacturer_mitsubishi manufacturer_morgan manufacturer_nissan manufacturer_pontiac manufacturer_porche manufacturer_ram
manufacturer_rover manufacturer_saturn manufacturer_subaru manufacturer_toyota manufacturer_volkswagen manufacturer_volvo
condition_excellent condition_fair condition_good condition_like_new condition_new condition_salvage cylinders_10_cylinders
cylinders_12_cylinders cylinders_3_cylinders cylinders_4_cylinders cylinders_5_cylinders cylinders_6_cylinders cylinders_8_cylinders
cylinders_other fuel_diesel fuel_electric fuel_gas fuel_hybrid fuel_other title_status_clean title_status_lien
title_status_missing title_status_parts_only title_status_rebuilt title_status_salvage transmission_automatic 
transmission_manual transmission_other drive_4wd drive_fwd drive_rwd size_compact size_full_size size_mid_size
size_sub_compact type_SUV type_bus type_convertible type_coupe type_hatchback type_mini_van type_offroad type_other
type_pickup type_sedan type_truck type_van type_wagon paint_color_black paint_color_blue paint_color_brown
paint_color_custom paint_color_green paint_color_grey paint_color_orange paint_color_purple paint_color_red
paint_color_silver paint_color_white paint_color_yellow @2
/selection = stepwise(select=cv) hierarchy=single cvmethod=random(10) showpvalues;
performance buildsscp=incremental;
run;
ods pdf close;

/*Area*/

data area;
set project;
if lat>42 
then area='cold';
if 34<=lat<=42
then area='normal';
if lat<34
then area='hot';
run;

ods pdf file='area-drive';
title 'area';
proc glmselect data=model;
class area(ref='hot') drive(ref='fwd') manufacturer;
model price=  year odometer lat long acura alfa_romeo aston_martin audi bmw buick 
cadillac chevrolet chrysler datsun dodge fiat ford gmc harley_davidson honda hyundai infiniti 
jaguar jeep kia land_rover lexus lincoln mazda mercedes_benz mercury mini mitsubishi morgan
nissan pontiac porche ram rover saturn subaru toyota volkswagen volvo excellent fair good
like_new new salvage _10_cylinders _12_cylinders _3_cylinders _4_cylinders _5_cylinders 
_6_cylinders _8_cylinders other diesel electric gas hybrid clean lien missing parts_only rebuilt 
automatic manual _4wd fwd rwd compact full_size mid_size sub_compact SUV bus convertible coupe
hatchback mini_van offroad  pickup sedan truck van wagon black blue brown custom green grey orange 
purple red silver white yellow  drive|area manufacturer*area;
run;
ods pdf close;




/* color manufacturer */
ods pdf file='color';
title 'color';
proc glmselect data=model;
class manufacturer paint_color;
model price=year odometer lat long acura alfa_romeo aston_martin audi bmw buick 
cadillac chevrolet chrysler datsun dodge fiat ford gmc harley_davidson honda hyundai infiniti 
jaguar jeep kia land_rover lexus lincoln mazda mercedes_benz mercury mini mitsubishi morgan
nissan pontiac porche ram rover saturn subaru toyota volkswagen volvo excellent fair good
like_new new salvage _10_cylinders _12_cylinders _3_cylinders _4_cylinders _5_cylinders 
_6_cylinders _8_cylinders other diesel electric gas hybrid clean lien missing parts_only rebuilt 
automatic manual _4wd fwd rwd compact full_size mid_size sub_compact SUV bus convertible coupe
hatchback mini_van offroad  pickup sedan truck van wagon black blue brown custom green grey orange 
purple red silver white yellow manufacturer*paint_color ;
run;
ods pdf close;

proc freq data=project;
tables manufacturer;
run;

/*country*/
data country;
set project;
if manufacturer='acura'or manufacturer='buick'or manufacturer='cadillac'or manufacturer='chevrolet'
or manufacturer='chrysler'or manufacturer='dodge'or manufacturer='ford'or manufacturer='gmc'
or manufacturer='harley-da'or manufacturer='jeep'or manufacturer='lincoln'
or manufacturer='mercury'or manufacturer='pontiac'or manufacturer='saturn'or manufacturer='ram'
or manufacturer='pontiac'
then country='America';
if manufacturer='alfa-rome'or manufacturer='fiat'
then country='Italian';
if manufacturer='aston-mar'or manufacturer='jaguar'or manufacturer='mini'or manufacturer='morgan'
or manufacturer='rover'or manufacturer='land rove'
then country='British';
if manufacturer='audi'or manufacturer='bmw'or manufacturer='mercedes-'or manufacturer='porche'
or manufacturer='volkswage'
then country='German';
if manufacturer='datsun'or manufacturer='honda'or manufacturer='infiniti'or manufacturer='lexus'
or manufacturer='mazda'or manufacturer='mitsubishi'or manufacturer='nissan'or manufacturer='subaru'
or manufacturer='toyota'
then country='Japanese';
if manufacturer='hyundai'or manufacturer='kia'or manufacturer='mini'or manufacturer='morgan'
or manufacturer='rover'
then country='Korean';
if manufacturer='volvo'
then country='Swedish';
run;

ods pdf file='country model';
proc glmselect data=model;
class country(ref='America');
model price=year odometer lat long  excellent fair good
like_new new salvage _10_cylinders _12_cylinders _3_cylinders _4_cylinders _5_cylinders 
_6_cylinders _8_cylinders other diesel electric gas hybrid clean lien missing parts_only rebuilt 
automatic manual _4wd fwd rwd compact full_size mid_size sub_compact SUV bus convertible coupe
hatchback mini_van offroad  pickup sedan truck van wagon black blue brown custom green grey orange 
purple red silver white yellow country ;
run;
ods pdf close;

ods pdf file='country-mean';
proc means data=model;
class country;
var price;
run;
ods pdf close;
