;grow back resources and food on patches
;Create compound events
;ending condition?
;Decide about KPI's
; idea - size of turtles depends on group size

;Compound Events
;Implement the spread of the ash
;Normal / Skewed distribution of the center
;The effect of the ash fall is time limited

; Bugs:
;- Volcano somehow disappears after it erupts.. no intentional code.. but also not that much of a problem because it formed a crater in real life anyways

__includes [ "code/0_init.nls" "code/1_load_gis.nls" "code/2_setup_functions.nls" "code/3_update_variables.nls" "code/4_band_functions.nls" "code/5_compound_event_functions.nls"
             "code/6_climate_change_functions.nls" ]

to startup
  ; startup command only applies these functions during the initial start of the model
  ; it saves time by not loading in all the GIS data everytime a new run is started!
  clear-all
;  profiler:start
  ; all these functions are in the "load_gis.nls"
  setup-patches ; function that loads in all the data needed for the initial patch data: altitude, landmass, terrain ruggedness, precipitation, and temperature
;  profiler:stop
;  print profiler:report
end

to setup
  clear-turtles
  reset-ticks
  ;random-seed -176624766

  ; all these functions are in the "setup_functions.nls"
  setup-globals
  setup-food-and-resources
  spread-population
  visualize-impact-volcano
  setup-volcano

  clear-all-plots
end

to go
  ; functions in "update_variables.nls"
  update-weather
  update-food-and-resources
  update_bands_variables

  ; functions in "band_functions.nls"
  interact-with-other-bands
  gather_move_explore
  use_gathered_products
  split_bands

  ; functions in "compound_event_functions.nls"
  compound_event_impact

  tick
  set current_season (ticks mod 4)   ;set season to next item in the list using a modulus based on ticks
end
@#$#@#$#@
GRAPHICS-WINDOW
310
10
1371
385
-1
-1
2.0221
1
10
1
1
1
0
0
0
1
0
520
0
180
1
1
1
ticks
30.0

BUTTON
60
10
124
43
Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
190
10
245
43
go-once
go\n
NIL
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
250
10
310
43
go-forever
go
T
1
T
OBSERVER
NIL
H
NIL
NIL
1

SLIDER
5
475
235
508
threshold_location_knowledge
threshold_location_knowledge
1
8
8.0
1
1
Season(s)
HORIZONTAL

CHOOSER
75
295
220
340
cultural_capital_distribution
cultural_capital_distribution
"normal" "uniform" "poisson"
0

SLIDER
5
260
145
293
mean_cultural_capital
mean_cultural_capital
1
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
145
260
285
293
stdv_cultural_capital
stdv_cultural_capital
0
50
10.0
1
1
NIL
HORIZONTAL

SLIDER
5
510
255
543
max_effectiveness
max_effectiveness
0
10
8.0
1
1
resource_units_per_HG_per_day
HORIZONTAL

SLIDER
145
190
285
223
standard_birth_rate
standard_birth_rate
1
1.25
1.05
0.01
1
NIL
HORIZONTAL

SLIDER
5
345
145
378
resources_tool
resources_tool
1
100
60.0
1
1
NIL
HORIZONTAL

SLIDER
130
95
300
128
optimal_temperature
optimal_temperature
0
30
6.0
1
1
Celcius
HORIZONTAL

SLIDER
5
95
130
128
optimal_precipitation
optimal_precipitation
0
20
4.0
1
1
NIL
HORIZONTAL

BUTTON
130
10
185
43
Startup
startup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
130
130
300
163
max_deviation_temp
max_deviation_temp
0
30
5.0
1
1
Celcius
HORIZONTAL

SLIDER
5
130
130
163
max_deviation_prec
max_deviation_prec
0
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
145
225
285
258
stdev_group_size
stdev_group_size
0
30
10.0
1
1
NIL
HORIZONTAL

SLIDER
5
225
145
258
average_group_size
average_group_size
1
40
25.0
1
1
NIL
HORIZONTAL

SLIDER
5
190
145
223
number_of_bands
number_of_bands
2
2000
1000.0
1
1
NIL
HORIZONTAL

SWITCH
145
345
285
378
show-graticules?
show-graticules?
1
1
-1000

SWITCH
95
45
195
78
show_links
show_links
0
1
-1000

PLOT
1789
25
1989
175
Number of bands
Time
Number
0.0
10.0
0.0
10.0
true
false
"" "if tick = start_event [\nplot 1000 ]"
PENS
"default" 1.0 0 -16777216 true "" "plot count bands"

PLOT
1989
25
2189
175
Mean Group Size Bands
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ group_size ] of bands"

PLOT
1375
25
1575
175
Mean Temperature
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ average_temp ] of land_patches"

PLOT
1575
25
1775
175
Mean Precipitation
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ average_prec ] of land_patches"

SWITCH
5
45
95
78
debug?
debug?
0
1
-1000

TEXTBOX
10
10
55
28
Controls
11
0.0
1

TEXTBOX
5
80
85
98
External Factors
11
0.0
1

TEXTBOX
5
175
155
193
Initialization Model
11
0.0
1

TEXTBOX
10
390
85
408
Assumptions
11
0.0
1

SLIDER
5
545
160
578
maximum_days_moving
maximum_days_moving
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
5
405
140
438
max_food_patch
max_food_patch
0
18000
9000.0
100
1
NIL
HORIZONTAL

SLIDER
140
405
295
438
max_resource_patch
max_resource_patch
0
18000
4600.0
100
1
NIL
HORIZONTAL

SLIDER
5
440
205
473
max_altitude_food_available
max_altitude_food_available
1000
5000
2500.0
100
1
m
HORIZONTAL

TEXTBOX
1380
10
1530
28
Environment
11
0.0
1

PLOT
1375
180
1575
330
Mean Food Availability
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ food_available ] of land_patches"

PLOT
1575
180
1775
330
Mean Resource Available
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ resources_available ] of land_patches"

PLOT
1790
337
1990
487
Mean Cultural Capital
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ cultural_capital ] of bands"

PLOT
1789
172
1989
322
Extinct Bands
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot extinct_bands"

PLOT
1375
339
1575
489
Number of Connections
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count links "

PLOT
1575
490
1775
640
Average Time Moving
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"clear-all-plots " ""
PENS
"default" 1.0 0 -16777216 true "" "plot total_movement / count bands"

PLOT
1989
174
2189
324
Mean Knowledge on Locations
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ count_known_locations_current ] of bands"

SLIDER
5
580
160
613
cultural_capital_mutation
cultural_capital_mutation
1
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
160
545
290
578
merge_max_size
merge_max_size
2
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
160
580
260
613
split_min_size
split_min_size
1
100
25.0
1
1
NIL
HORIZONTAL

SLIDER
5
615
177
648
growback_rate
growback_rate
4
100
20.0
4
1
NIL
HORIZONTAL

PLOT
1575
339
1775
489
Mean strength of links
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [strength_of_connection] of links"

SLIDER
312
527
522
560
volcano_eruption_distance
volcano_eruption_distance
0
100
10.0
5
1
patches
HORIZONTAL

SLIDER
527
442
727
475
ash_eruption_distance_1
ash_eruption_distance_1
0
100
70.0
5
1
patches
HORIZONTAL

SLIDER
527
477
727
510
ash_eruption_angle_1
ash_eruption_angle_1
0
180
30.0
5
1
degree
HORIZONTAL

SLIDER
527
407
727
440
ash_wind_direction_1
ash_wind_direction_1
0
360
50.0
1
1
heading
HORIZONTAL

SLIDER
727
407
927
440
ash_wind_direction_2
ash_wind_direction_2
0
360
205.0
5
1
heading
HORIZONTAL

SLIDER
727
442
927
475
ash_eruption_distance_2
ash_eruption_distance_2
0
100
45.0
5
1
patches
HORIZONTAL

SLIDER
727
477
927
510
ash_eruption_angle_2
ash_eruption_angle_2
0
180
110.0
5
1
degree
HORIZONTAL

INPUTBOX
312
407
387
487
start_event
10.0
1
0
Number

SLIDER
312
492
522
525
random_ash_fall
random_ash_fall
0
3
0.3
0.05
1
%
HORIZONTAL

SWITCH
392
407
522
440
show_impact
show_impact
0
1
-1000

CHOOSER
932
407
1094
452
ash_eruption_distribution
ash_eruption_distribution
"normal" "skewed far" "skewed near"
1

SLIDER
932
457
1104
490
mean_ash_intensity
mean_ash_intensity
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
932
492
1104
525
stdv_ash_intensity
stdv_ash_intensity
0
50
20.0
1
1
NIL
HORIZONTAL

CHOOSER
392
442
522
487
ash_fallout
ash_fallout
"in-radius" "wind-cones"
1

SLIDER
527
522
727
555
ash_eruption_radius
ash_eruption_radius
0
100
50.0
1
1
patches
HORIZONTAL

TEXTBOX
312
387
462
405
Volcano Eruption\n
11
0.0
1

TEXTBOX
530
510
590
528
If in-radius:
11
0.0
1

TEXTBOX
527
392
677
410
If wind-cones
11
0.0
1

TEXTBOX
937
392
1132
418
Changes to ash eruption distribution
11
0.0
1

SLIDER
1099
415
1311
448
volcano_duration_effect
volcano_duration_effect
0
1000
24.0
4
1
ticks
HORIZONTAL

PLOT
1992
338
2192
488
Mean Technology Level
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [ technology_level ] of bands"

MONITOR
1950
535
2040
580
NIL
lost_resources
0
1
11

MONITOR
1793
491
1908
536
NIL
death_by_volcano
17
1
11

MONITOR
1908
491
1998
536
NIL
death_by_ash
0
1
11

MONITOR
1793
535
1952
580
NIL
event_cultural_capital_loss
2
1
11

TEXTBOX
315
569
503
592
Climate Change
11
0.0
1

SLIDER
310
585
445
618
max_temp_change
max_temp_change
-5
5
0.0
0.05
1
NIL
HORIZONTAL

SLIDER
445
585
575
618
max_prec_change
max_prec_change
0
10
0.0
0.05
1
NIL
HORIZONTAL

SLIDER
580
585
735
618
increase_temp_variation
increase_temp_variation
0
10
0.0
0.1
1
NIL
HORIZONTAL

SLIDER
735
585
890
618
increase_prec_variation
increase_prec_variation
0
10
0.0
0.1
1
NIL
HORIZONTAL

SLIDER
360
620
515
653
environment_delay
environment_delay
1
1000
300.0
1
1
ticks
HORIZONTAL

SLIDER
665
620
800
653
variation_delay
variation_delay
0
1000
500.0
1
1
ticks
HORIZONTAL

MONITOR
2000
490
2102
535
Impacted Bands
count bands with [ event_impact? = true ]
17
1
11

PLOT
1375
490
1575
640
Average Connections
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count links / count bands"

@#$#@#$#@
## WHAT IS IT?
Social Consequences of Past Compound Events
The aftermath of compound events will be analyzed with the help of Agent Based Modeling to gain a better understanding of the social consequences.

One example of such a phenomena is the Laacher See eruption approximately 13,000 years ago located in present-day Germany. Archaeologist Felix Riede believes that this event has caused technological regression. The new inhabitants after the eruption were not as advanced in their toolmaking, even with some losing bow and arrow technology.

This project was made by Brennen Bouwmeester and Kevin Su with supervision from Felix Riede and Igor Nikolic.

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

volcano
true
0
Rectangle -955883 false false 120 105 180 105
Rectangle -955883 false false 105 90 195 105
Rectangle -955883 true false 105 90 195 105
Rectangle -955883 true false 90 105 225 105
Rectangle -955883 true false 105 75 195 90
Rectangle -955883 true false 105 75 150 90
Rectangle -1184463 true false 105 75 150 105
Rectangle -955883 true false 120 120 165 165
Rectangle -955883 true false 135 165 165 180
Rectangle -6459832 true false 15 195 285 270
Rectangle -6459832 true false 15 195 285 225
Rectangle -6459832 true false 45 180 270 195
Rectangle -6459832 true false 75 165 135 165
Rectangle -6459832 true false 60 165 135 165
Rectangle -6459832 true false 60 165 135 180
Rectangle -6459832 true false 165 165 240 180
Rectangle -6459832 true false 165 150 225 165
Rectangle -6459832 true false 75 150 120 165
Rectangle -6459832 true false 75 135 120 150
Rectangle -6459832 true false 75 120 120 135
Rectangle -6459832 true false 165 120 225 135
Rectangle -6459832 true false 165 135 225 150
Rectangle -955883 true false 105 105 195 105
Rectangle -955883 true false 90 105 210 120
Rectangle -16777216 true false 210 180 225 210
Rectangle -16777216 true false 75 195 90 225
Rectangle -16777216 true false 150 225 165 255
Circle -955883 true false 120 120 30
Rectangle -955883 true false 195 60 210 45
Rectangle -955883 true false 210 45 225 60
Rectangle -955883 true false 75 45 90 60
Rectangle -955883 true false 135 15 150 30

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
