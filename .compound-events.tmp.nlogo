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
; Fix Hatch Links

__includes [ "code/0_init.nls" "code/1_load_gis.nls" "code/2_setup_functions.nls" "code/3_update_variables.nls" "code/4_band_functions.nls" "code/5_compound_event_functions.nls"
             "code/6_community.nls" ]

to startup
  ; startup command only applies these functions during the initial start of the model
  ; it saves time by not loading in all the GIS data everytime a new run is started!
  clear-all
  reset-ticks
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

  community-detection

  tick
  set current_season (ticks mod 4)   ;set season to next item in the list using a modulus based on ticks
end
@#$#@#$#@
GRAPHICS-WINDOW
5
88
1498
613
-1
-1
2.851
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
210
10
265
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
740
10
805
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
810
10
885
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
205
45
430
78
threshold_location_knowledge
threshold_location_knowledge
1
8
3.0
1
1
Season(s)
HORIZONTAL

CHOOSER
615
1095
760
1140
cultural_capital_distribution
cultural_capital_distribution
"normal" "uniform" "poisson"
0

SLIDER
745
45
885
78
mean_cultural_capital
mean_cultural_capital
1
100
56.0
1
1
NIL
HORIZONTAL

SLIDER
760
1095
900
1128
stdv_cultural_capital
stdv_cultural_capital
0
50
11.0
1
1
NIL
HORIZONTAL

SLIDER
80
45
205
78
max_effectiveness
max_effectiveness
0
10
9.0
1
1
NIL
HORIZONTAL

SLIDER
1035
935
1175
968
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
910
970
1015
1003
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
740
935
910
968
optimal_temperature
optimal_temperature
0
30
5.0
1
1
Celcius
HORIZONTAL

SLIDER
615
935
740
968
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
5
10
60
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
740
970
910
1003
max_deviation_temp
max_deviation_temp
0
30
4.0
1
1
Celcius
HORIZONTAL

SLIDER
615
970
740
1003
max_deviation_prec
max_deviation_prec
0
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
745
1060
865
1093
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
615
1060
745
1093
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
910
935
1035
968
number_of_bands
number_of_bands
2
2000
100.0
1
1
NIL
HORIZONTAL

SWITCH
60
10
200
43
show-graticules?
show-graticules?
1
1
-1000

SWITCH
420
10
520
43
show_links
show_links
0
1
-1000

PLOT
405
615
605
765
Number of bands
Time
Number
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count bands"

PLOT
605
615
805
765
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
6
615
206
765
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
206
615
406
765
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

TEXTBOX
620
920
710
938
External factors
11
0.0
1

TEXTBOX
620
1010
695
1028
Assumptions
11
0.0
1

SLIDER
1015
970
1170
1003
maximum_days_moving
maximum_days_moving
0
89
89.0
1
1
NIL
HORIZONTAL

SLIDER
1025
1025
1150
1058
max_food_patch
max_food_patch
0
18000
5200.0
100
1
NIL
HORIZONTAL

SLIDER
1150
1025
1295
1058
max_resource_patch
max_resource_patch
0
18000
5200.0
100
1
NIL
HORIZONTAL

SLIDER
615
1025
810
1058
max_altitude_food_available
max_altitude_food_available
1000
5000
2500.0
100
1
m
HORIZONTAL

PLOT
805
615
1005
765
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
1005
615
1205
765
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
605
765
805
915
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
1205
615
1385
765
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
205
765
405
915
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
805
765
1005
915
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
5
765
205
915
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
1175
935
1330
968
cultural_capital_mutation
cultural_capital_mutation
1
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
910
1025
1025
1058
merge_max_size
merge_max_size
2
100
51.0
1
1
NIL
HORIZONTAL

SLIDER
810
1025
910
1058
split_min_size
split_min_size
1
100
26.0
1
1
NIL
HORIZONTAL

SLIDER
865
1060
970
1093
growback_rate
growback_rate
4
100
8.0
4
1
NIL
HORIZONTAL

PLOT
405
765
605
915
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
"mean" 1.0 0 -16777216 true "" "plot mean [strength_of_connection] of links"

SLIDER
1185
10
1390
43
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
200
1090
395
1123
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
395
1090
580
1123
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
5
1090
200
1123
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
5
1125
200
1158
ash_wind_direction_2
ash_wind_direction_2
0
360
225.0
5
1
heading
HORIZONTAL

SLIDER
200
1125
395
1158
ash_eruption_distance_2
ash_eruption_distance_2
0
100
60.0
5
1
patches
HORIZONTAL

SLIDER
395
1125
580
1158
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
895
10
960
80
start_event
10.0
1
0
Number

SLIDER
1360
45
1500
78
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
265
10
420
43
show_volcano_impact
show_volcano_impact
0
1
-1000

CHOOSER
1050
10
1185
55
ash_eruption_distribution
ash_eruption_distribution
"normal" "skewed far" "skewed near"
0

SLIDER
1160
1135
1290
1168
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
1290
1135
1415
1168
stdv_ash_intensity
stdv_ash_intensity
0
50
10.0
1
1
NIL
HORIZONTAL

CHOOSER
960
10
1052
55
ash_fallout
ash_fallout
"in-radius" "wind-cones"
1

SLIDER
975
1135
1150
1168
ash_eruption_radius
ash_eruption_radius
0
100
10.0
1
1
patches
HORIZONTAL

TEXTBOX
1030
60
1120
78
Volcano Eruption\n
11
0.0
1

TEXTBOX
980
1120
1040
1138
If in-radius:
11
0.0
1

TEXTBOX
10
1075
80
1093
If wind-cones
11
0.0
1

TEXTBOX
1160
1120
1340
1138
Changes to ash eruption distribution
11
0.0
1

SLIDER
1185
45
1360
78
volcano_duration_effect
volcano_duration_effect
0
1000
24.0
4
1
ticks
HORIZONTAL

MONITOR
1385
795
1475
840
NIL
lost_resources
0
1
11

MONITOR
1385
615
1490
660
NIL
death_by_volcano
17
1
11

MONITOR
1385
660
1475
705
NIL
death_by_ash
0
1
11

MONITOR
1385
750
1490
795
Cultural capital loss
event_cultural_capital_loss
2
1
11

TEXTBOX
10
980
90
1003
Climate Change
11
0.0
1

SLIDER
5
995
140
1028
max_temp_change
max_temp_change
-5
5
1.2
0.05
1
NIL
HORIZONTAL

SLIDER
140
995
270
1028
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
270
995
425
1028
increase_temp_variation
increase_temp_variation
0
10
3.5
0.1
1
NIL
HORIZONTAL

SLIDER
425
995
580
1028
increase_prec_variation
increase_prec_variation
0
10
0.1
0.1
1
NIL
HORIZONTAL

SLIDER
5
1030
160
1063
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
270
1030
415
1063
variation_delay
variation_delay
0
1000
506.0
1
1
ticks
HORIZONTAL

MONITOR
1385
705
1487
750
Impacted Bands
count bands with [ event_impact? = true ]
17
1
11

TEXTBOX
10
55
75
73
Policy Levers
11
0.0
1

SLIDER
585
45
745
78
cooperation_radius
cooperation_radius
0
10
3.0
1
1
patches
HORIZONTAL

SLIDER
430
45
585
78
decrease_connection
decrease_connection
1
100
4.0
4
1
ticks
HORIZONTAL

SLIDER
970
1060
1105
1093
mobility_size_factor
mobility_size_factor
1
2
2.0
0.1
1
NIL
HORIZONTAL

PLOT
1005
765
1205
915
Count Unique Communities
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
"default" 1.0 0 -16777216 true "" "plot length unique_communities"

PLOT
1205
765
1385
915
Mean community size
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
"default" 1.0 0 -16777216 true "" "plot mean [ community_size ] of agentset_unique_communities"

SWITCH
520
10
645
43
color_clusters?
color_clusters?
1
1
-1000

SWITCH
645
10
735
43
debug?
debug?
1
1
-1000

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

band
false
0
Polygon -16777216 true false 15 90 30 150 15 225 15 225 30 225 45 180 60 225 75 225 75 225 60 150 75 90
Polygon -16777216 true false 15 90 0 165 15 165 30 90
Polygon -16777216 true false 75 165 90 165 75 90 60 90
Circle -16777216 true false 15 30 60
Circle -16777216 true false 120 45 60
Circle -16777216 true false 225 30 60
Polygon -16777216 true false 120 105 135 165 120 240 120 240 135 240 150 195 165 240 180 240 180 240 165 165 180 105
Polygon -16777216 true false 225 90 240 150 225 225 225 225 240 225 255 180 270 225 285 225 285 225 270 150 285 90
Polygon -16777216 true false 120 105 105 180 120 180 135 105
Polygon -16777216 true false 225 90 210 165 225 165 240 90
Polygon -16777216 true false 180 180 195 180 180 105 165 105
Polygon -16777216 true false 285 165 300 165 285 90 270 90
Rectangle -7500403 true true 45 90 60 90
Rectangle -16777216 true false 30 75 60 90
Rectangle -16777216 true false 135 90 165 105
Rectangle -16777216 true false 240 75 270 90
Line -6459832 false 90 225 90 60
Line -6459832 false 300 225 300 75
Circle -7500403 true true 75 270 0
Polygon -7500403 true true 90 45 75 75 105 75
Polygon -6459832 false false 225 135 300 135 285 165 240 165 225 135
Circle -2674135 true false 240 120 30
Circle -10899396 true false 255 120 30
Polygon -6459832 true false 225 135 240 165 285 165 300 135
Polygon -6459832 false false 180 210 210 180 210 135 180 105
Line -1 false 180 105 180 210
Line -1 false 210 150 210 165
Line -6459832 false 90 45 105 75
Line -6459832 false 90 45 75 75
Line -6459832 false 75 75 105 75
Polygon -1 false false 225 135 240 165 285 165 300 135 225 135 225 135

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
