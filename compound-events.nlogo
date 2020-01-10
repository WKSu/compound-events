extensions [ gis profiler ]

breed [ bands band ]

globals [
  ; start: GIS globals used for loading in map data
  europe-landmass ; visualize the continent
  europe-altitude ; altitude
  europe-grid ; overlay a grid with graticules of 10
  europe-tri ; terrain roughness index

  ; mean precipitation GIS
  europe-prec-djf ; DJF: December, January, February
  europe-prec-mam ; MAM: March, April, May
  europe-prec-jja ; JJA: June, July, August
  europe-prec-son ; September, October, November

  ; mean temperature GIS
  europe-temp-djf
  europe-temp-mam
  europe-temp-jja
  europe-temp-son
  europe-temp-range ; Annual Temeprature Range
  ; end: GIS globals

  max_group_size
  technology_sharing_threshold
  first_threshold_connection
  second_threshold_connection
  third_threshold_connection
  fourth_threshold_connection
  current_season
  time_available
  max_move_time
]

bands-own [
  group_size
  food_needed
  resources_needed
  food_owned
  resources_owned
  food_effectiveness
  resource_effectiveness
  cultural_capital
  technology_level_food
  technology_level_resources

  mobility
  birth_rate
  death_rate
  health
  known_locations_summer
  known_locations_fall
  known_locations_winter
  known_locations_spring
  known_locations_current
  current_home_location
  previous_home_location
  time_spent
  time_spent_exploring
  time_spent_moving
  time_spent_gathering
]

links-own[
  strength_of_connection
  updated?
]

patches-own [
  food_available
  resources_available
  food_return_rate
  resource_return_rate
  accessibility
  altitude
  ruggedness_index
  landmass

  prec-djf
  prec-mam
  prec-jja
  prec-son

  temp-djf
  temp-mam
  temp-jja
  temp-son
  temp-range
  temp-current
]

to startup
   clear-all
   profiler:start
   setup-patches ; function that loads in all the data needed for the initial patch data: altitude, landmass, terrain ruggedness, precipitation, and temperature
   profiler:stop
   print profiler:report
end

to setup
  clear-turtles
  reset-ticks
  ask n-of 1 patches[
    setup-agents]
  set max_group_size 200
  set current_season 0 ;0 = summer, 1 = fall, 2 = winter, 3 = spring
  set fourth_threshold_connection 3
  set max_move_time 45
  set time_available 90
end

to setup-patches
  gis:load-coordinate-system ("data/gis/EPHA/europe.prj") ; set the coordinate system to WGS84 (CR84)

  ; load in GIS data split
  setup-altitude
  setup-terrain-ruggedness-index
  setup-precipitation
  setup-temperature

  if show-graticules? = True [
     setup-graticules
  ]
end

to setup-altitude
  ; loading GIS datasets
  set europe-altitude gis:load-dataset "data/gis/GEBCO/gebco_elevation_resampled.asc" ; https://download.gebco.net/ - altitude data also used for the Allerod map
  set europe-landmass gis:load-dataset "data/gis/EPHA/europe.asc" ; Allerod compiled by ZBSA after Andrén et al. 2011; Björck 1995; Brooks et al. 2011; Hughes et al. 2016; Lericolais 2017; Lunkka et al. 2012; Moscon et al. 2015; Patton et al. 2017; Seguinot et al. 2018; Stroeven et al. 2016; Subetto et al. 2017; Vassiljev/Saarse 2013; Weaver et al. 2003 - full bibliography in report"

  gis:set-world-envelope-ds (gis:envelope-of europe-landmass) ; mapping the envelope of the NetLogo world to the given envelope in GIS space

  ; assign the values to the patch attributes
  gis:apply-raster europe-altitude altitude
  gis:apply-raster europe-landmass landmass

  ; start: coloring patches to represent european landmass 13900 - 12700BP
  let min-landmass gis:minimum-of europe-landmass
  let max-landmass gis:maximum-of europe-landmass

  ask patches [
   if (landmass <= 0) or (landmass >= 0) ; note the use of the "<= 0 or >= 0" technique to filter out "not a number" values
   [ set pcolor scale-color black landmass min-landmass max-landmass ]

   if (landmass = 781.4310302734375) or (landmass = 1133.7154541015625) or (landmass = 0) ;; easy way to idenfity water bodies
   [ set pcolor blue ]
  ]
  ; end: coloring landmass
end

to setup-terrain-ruggedness-index
    set europe-tri gis:load-dataset "data/gis/EPHA/europe_TRI.asc" ; Allerod Map raster analysis in QGIS using GDAL to create the TRI
    gis:apply-raster europe-tri ruggedness_index
end

to setup-precipitation
  ; loading GIS datasets
  ; Precipitation data comes from PaleoView V1.5 - Fordham, D. A., Saltré, F., Haythorne, S., Wigley, T. M., Otto‐Bliesner, B. L., Chan, K. C., & Brook, B. W. (2017). PaleoView: a tool for generating continuous climate projections spanning the last 21 000 years at regional and global scales. Ecography, 40(11), 1348-1358.
  set europe-prec-djf gis:load-dataset "data/gis/PaleoView/precipitation/mean_prec_DJF.asc"
  set europe-prec-mam gis:load-dataset "data/gis/PaleoView/precipitation/mean_prec_MAM.asc"
  set europe-prec-jja gis:load-dataset "data/gis/PaleoView/precipitation/mean_prec_JJA.asc"
  set europe-prec-son gis:load-dataset "data/gis/PaleoView/precipitation/mean_prec_SON.asc"

  gis:set-world-envelope-ds (gis:envelope-of europe-prec-djf) ; mapping the envelope of the NetLogo world to the given envelope in GIS space

  ; assign the values to the patch attributes
  gis:apply-raster europe-prec-djf prec-djf
  gis:apply-raster europe-prec-mam prec-mam
  gis:apply-raster europe-prec-jja prec-jja
  gis:apply-raster europe-prec-son prec-son
end

to setup-temperature
  ; loading GIS datasets
  ; Precipitation data comes from PaleoView V1.5 - Fordham, D. A., Saltré, F., Haythorne, S., Wigley, T. M., Otto‐Bliesner, B. L., Chan, K. C., & Brook, B. W. (2017). PaleoView: a tool for generating continuous climate projections spanning the last 21 000 years at regional and global scales. Ecography, 40(11), 1348-1358.
  set europe-prec-djf gis:load-dataset "data/gis/PaleoView/precipitation/mean_prec_DJF.asc"
  set europe-prec-mam gis:load-dataset "data/gis/PaleoView/precipitation/mean_prec_MAM.asc"
  set europe-temp-djf gis:load-dataset "data/gis/PaleoView/temperature/mean/mean_temp_DJF.asc"
  set europe-temp-mam gis:load-dataset "data/gis/PaleoView/temperature/mean/mean_temp_mam.asc"
  set europe-temp-jja gis:load-dataset "data/gis/PaleoView/temperature/mean/mean_temp_jja.asc"
  set europe-temp-son gis:load-dataset "data/gis/PaleoView/temperature/mean/mean_temp_son.asc"
  set europe-temp-range gis:load-dataset "data/gis/PaleoView/temperature/temp_range.asc"

  gis:set-world-envelope-ds (gis:envelope-of europe-temp-djf) ; mapping the envelope of the NetLogo world to the given envelope in GIS space

  ; assign the values to the patch attributes
  gis:apply-raster europe-temp-djf temp-djf
  gis:apply-raster europe-temp-mam temp-mam
  gis:apply-raster europe-temp-jja temp-jja
  gis:apply-raster europe-temp-son temp-son
  gis:apply-raster europe-temp-range temp-range
end

to setup-graticules
  gis:load-coordinate-system ("data/gis/Natural Earth 2/ne_10m_graticules_5.prj") ;
  set europe-grid gis:load-dataset "data/gis/Natural Earth 2/ne_10m_graticules_5.shp"
  gis:draw europe-grid 1
end


to setup-agents
  let population_density 2
  let number_of_bands_multiplier 1
  if population_density > 0[
    sprout-bands number_of_bands_multiplier * population_density[
      set xcor random 10
      set ycor random 10
      set health 100
      set group_size random 50
      set food_needed group_size
      set resources_needed group_size
      set resources_owned 0
      set food_effectiveness random 100
      set resource_effectiveness random 100
      set cultural_capital random 100
      set technology_level_food random 100
      set technology_level_resources random 100
      set mobility random 5 + 5
      set birth_rate random 100
      set death_rate random 100
      set health 100
      set current_home_location patch-here
      set known_locations_summer (list (list current_home_location ([food_available] of current_home_location) ([resources_available] of current_home_location)))
      set known_locations_fall []
      set known_locations_winter []
      set known_locations_spring []
    ]
  ]
end

to go
  temperature-distribution
  update_bands_variables
  interact-with-other-bands
  gather_move_explore

  ask turtles[
    fd 1
    set current_home_location patch-here
    set known_locations_summer filter [x -> item 0 x != patch-here] known_locations_summer
        ;add the new knowledge on this patch in the current season
    set known_locations_summer lput (list patch-here [food_available] of patch-here [resources_available] of patch-here) known_locations_summer
  ]
  tick
  set current_season (ticks mod 4)
  ;set season to next item in the list using a modulus based on ticks

end

to temperature-distribution
  ask patches [
    let sd (temp-range / 4) ; very rough estimate of the standard deviation, assuming a normal distribution

    if current_season = 0[
      set temp-current random-normal temp-jja sd
    ]
    if current_season = 1[
      set temp-current random-normal temp-son sd
    ]
    if current_season = 2[
      set temp-current random-normal temp-djf sd
    ]
    if current_season = 3[
      set temp-current random-normal temp-mam sd
    ]
  ]
end

to update_bands_variables
  ;new season means the bands have all available time to move, gather and explore
  ask turtles[
    set time_spent 0
    set time_spent_exploring 0
    set time_spent_moving 0
    set time_spent_gathering 0
    ;as the season has changed, the bands change their knowledge about the patches to the current season
    if current_season = 0[
      set known_locations_current known_locations_summer
    ]
    if current_season = 1[
      set known_locations_current known_locations_fall
    ]
    if current_season = 2[
      set known_locations_current known_locations_winter
    ]
    if current_season = 3[
      set known_locations_current known_locations_spring
    ]
  ]
end

to interact-with-other-bands
  ;Make sure that links do not get updated by both of the ends (turtles)
  ask links[
    set updated? False
  ]
  ask bands[
    ;define the current turtle who is asked to interact
    let current_band self

    ;put all the turtles on the same or a neighbouring patch in a turtleset
    let neighbor_bands (turtle-set bands-on neighbors bands-here)
    ask neighbor_bands[

      ;if there is no link between the neighbouring bands yet...
      if not member? current_band in-link-neighbors and current_band != self[

        ;create a link between the bands
        create-link-with current_band[
          set strength_of_connection 0
          set updated? False
          set color green
        ]
      ]
      ;make sure turtles don't see themselves as neighbours
      if current_band != self[
        ;make existing connections between neighbouring turtles stronger
        let current_link one-of my-links with [end1 = current_band or end2 = current_band]
        if [updated?] of current_link = False[
          ask current_link[
            ;increase the strength of the current link as the groups have been close to each other for another tick
            set strength_of_connection strength_of_connection + 1
            set updated? True
          ]



          if [strength_of_connection] of current_link = technology_sharing_threshold[
            ;update technology knowledge
            ]

          ;Share knowledge based on the strength of the connection: Spring, Winter, Fall, Summer
          if [strength_of_connection] of current_link > fourth_threshold_connection[
            update_location_knowledge known_locations_summer current_band
          ]
          if [strength_of_connection] of current_link > third_threshold_connection[
            update_location_knowledge known_locations_fall current_band
          ]
          if [strength_of_connection] of current_link > second_threshold_connection[
            update_location_knowledge known_locations_winter current_band
          ]
          if [strength_of_connection] of current_link > first_threshold_connection[
            update_location_knowledge known_locations_spring current_band
          ]
        ]
      ]
    ]
  ]
end

to update_location_knowledge [known_locations_given_season current_band]
  ;Function that shares knowledge between bands (will happen twice per link as both agents have to update their knowledge)

  let temporary_list_of_known_locations [known_locations_given_season] of current_band

  let x 0
  ;First delete all the other bands knowledge which the band has already (own information > foreign information)
  while [x < length known_locations_given_season][
    let current_location item x known_locations_given_season
    set temporary_list_of_known_locations filter [y -> item 0 y != item 0 current_location] temporary_list_of_known_locations
    set x x + 1
  ]
  ;Add all remaining knowledge of patches to complete the list of known locations (add linked bands known locations)
  foreach temporary_list_of_known_locations[y -> if length y = 3
    [set known_locations_given_season lput y known_locations_given_season]
  ]
end


to gather_move_explore
  ;General fucntion that creates the flow for the bands
  ask bands
  [
    ;if there is no need to move, they won't, if there is a need, choose the closest location that has the needed food/resources
    if ([food_available] of patch-here <= food_needed) or ([resources_available] of patch-here <= resources_needed)
    [
      let potential_new_locations []
      ;Find patches with enough food and resources, but exlude patches that are too far away from the current position
      foreach known_locations_current [x -> if (item 1 x >= food_needed and item 2 x >= resources_needed and [distance self] of item 0 x + ([ruggedness_index] of item 0 x / 10) + abs (([altitude] of item 0 x - [altitude] of current_home_location) / 100) * (mobility / 10) < max_move_time)
        [set potential_new_locations lput (item 0 x) potential_new_locations]
      ]
      set potential_new_locations patch-set potential_new_locations
      if any? potential_new_locations[
        ;chose the patch that is closest to my current position
        let new_home min-one-of potential_new_locations [distance self]
        move new_home

      ]
      ;If there is no location available that has enough food AND resources, explore to find a patch that has enough
      if not any? potential_new_locations[
        explore

      ;At the end of a season, the knowledge should be updated about the season that has just passed
      ]
      if current_season = 0[
        set known_locations_summer known_locations_current
      ]
      if current_season = 1[
        set known_locations_fall known_locations_current
      ]
      if current_season = 2[
        set known_locations_winter known_locations_current
      ]
      if current_season = 3[
        set known_locations_spring known_locations_current
      ]
    ]
    gather
  ]
end


to gather
  ;Calculate the time left afrer exploring and moving
  let time_left time_available - time_spent
  set time_spent_gathering time_left
  ;Decide how much time is needed to gather food and resources
  let time_needed_for_food food_needed / (group_size * food_effectiveness)
  let time_needed_for_resources resources_needed / (group_size * resource_effectiveness)

  let part_spent_food time_left * (time_needed_for_food / (time_needed_for_food + time_needed_for_resources))
  let part_spent_resources time_left - part_spent_food

  if part_spent_food > time_needed_for_food[
    set part_spent_food time_needed_for_food
  ]

  if part_spent_resources > time_needed_for_resources[
    set part_spent_resources time_needed_for_resources
  ]


  ;Find out how much food and resources the band could gather if available
  let potential_food part_spent_food * group_size * food_effectiveness
  let potential_resources part_spent_resources * group_size * resource_effectiveness


  ;Gather food
  ifelse potential_food > [food_available] of current_home_location[
    set food_owned food_available

    ask current_home_location[
      set food_available 0
    ]
  ]
  [
    set food_owned potential_food
    ask current_home_location[
      set food_available food_available - potential_food
    ]
  ]
  ;Gather resources
  ifelse potential_resources > [resources_available] of current_home_location[
    set resources_owned resources_owned + resources_available
    ask current_home_location[
      set resources_available 0
    ]
  ]
  [
    set resources_owned resources_owned + potential_resources
    ask current_home_location[
      set resources_available resources_available - potential_resources
    ]
    ;Spending the spare time if there is any on gathering additional resources
    let spare_time time_left - time_needed_for_food - time_needed_for_resources
    let potential_extra_resources group_size * resource_effectiveness * spare_time

    ifelse potential_extra_resources > [resources_available] of current_home_location[
      set resources_owned resources_owned + potential_extra_resources
      ask current_home_location[
        set resources_available 0
      ]
    ]
    [
      set resources_owned resources_owned + potential_extra_resources
      ask current_home_location[
        set resources_available resources_available - potential_extra_resources
      ]
    ]
    ;create more offspring when there is time left
    set birth_rate birth_rate + 100
  ]
end


to move [new_home]
  ;Calculate time needed to move based on the roughness of the new home, the distance to this new home and the differene in altitude between the current home and the new home. Also lower the time based on mobility.
  let time_needed_to_move (distance new_home + ([ruggedness_index] of new_home / 10) + abs (([altitude] of new_home - [altitude] of current_home_location) / 100)) * (mobility / 10)
  set time_spent time_spent + time_needed_to_move
  set time_spent_moving time_needed_to_move

  set previous_home_location current_home_location
  move-to new_home
  set current_home_location new_home
  ;delete current knowledge on this patch in the current season
  set known_locations_current filter [x -> item 0 x != patch-here] known_locations_current
  ;add the new knowledge on this patch in the current season
  set known_locations_current lput (list new_home [food_available] of new_home [resources_available] of new_home) known_locations_current
end

to explore
  ;Exploring takes time depending on mobility
  set time_spent time_spent + mobility
  set time_spent_exploring time_spent
  let list_of_explored_patches []
  ;Add the explored patches to the known patches
  ask neighbors[
    set list_of_explored_patches lput (list self [food_available] of self [resources_available] of self) list_of_explored_patches
  ]
  let x 0

  while [x < length list_of_explored_patches][
    let current_location item x list_of_explored_patches
    set known_locations_current filter [y -> item 0 y != item 0 current_location] known_locations_current
    set x x + 1
  ]
  foreach list_of_explored_patches [y -> if length y = 3
    [set known_locations_current lput y known_locations_current]
  ]
  ;decide which known location is the best possible to move to (even though it will not reach the needs) and move there
  let best_known_locations []
  foreach known_locations_current [y -> set best_known_locations lput (list item 0 y ((item 1 y / food_needed) + (item 2 y / resources_needed)))  best_known_locations
  ]
  ;Only travel to the new location if there is time to do so
  set known_locations_current filter [y -> [distance self] of item 0 y + ([ruggedness_index] of item 0 y / 10) + abs (([altitude] of item 0 y - [altitude] of current_home_location) / 100) * (mobility / 10) < max_move_time] known_locations_current
  ;Choose the best option based on where the biggest part of the food and resources can still be gathered
  let current_max_patch item 0 item 0 best_known_locations
  let current_max item 1 item 0 best_known_locations
  foreach best_known_locations [y -> if item 1 y > current_max[
    set current_max_patch item 0 y
    set current_max item 1 y
    ]
  ]

  move current_max_patch
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1260
381
-1
-1
2.0
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
0
0
1
ticks
30.0

SLIDER
16
38
188
71
number-of-bands
number-of-bands
0
100
51.0
1
1
NIL
HORIZONTAL

BUTTON
16
86
80
119
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

SWITCH
16
129
164
162
show-graticules?
show-graticules?
1
1
-1000

BUTTON
66
192
143
225
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
95
252
187
285
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

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

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
0
@#$#@#$#@
