globals [survived good-extinct radius num-good-relations ]

turtles-own [age health friends foes next-friends next-foes ]
breed [goods good]
breed [bads bad]
breed [randomizeds randomized]
breed [tit-for-tats tit-for-tat]
breed [inverse-tats inverse-tat]
breed [resentfulls resentfull]
breed [vengefuls vengeful]
resentfulls-own [last-interaction]
vengefuls-own [last-interaction]


to-report get-random-breed
  let total ( prop-goods + prop-bads + prop-rands + prop-tats + prop-inv-tats + prop-resentfulls + prop-vengefuls)
  show ( total )
  let number (random total + 1)
  let suma prop-goods
  ifelse ( suma >= number)[
    report "goods"
  ][
    set suma ( suma + prop-bads )
    ifelse (suma >= number)[
      report "bads"
    ][
      set suma ( suma + prop-rands )
      ifelse (suma >= number)[
        report "randomizeds"
      ][
        set suma ( suma + prop-tats )
        ifelse (suma >= number)[
          report "tit-for-tats"
        ][
          set suma ( suma + prop-inv-tats )
          ifelse (suma >= number)[
            report "inverse-tats"

          ][
            set suma (suma + prop-resentfulls)
            ifelse ( suma >= number )[
              report ("resentfulls")
            ][
              set suma (suma + prop-vengefuls)
              if (suma >= number) [
                report "vengefuls"
            ]
          ]
        ]
      ]
    ]
  ]
 ]
end

to-report move-strategy [mover receptor]
  if ([breed] of mover = goods)[report "good"]

  if ([breed] of mover = bads) [report "bad"]

  if ([breed] of mover = randomizeds) [report one-of ["good" "bad"]]

  if ([breed] of mover = tit-for-tats)[
    if-else (member? ([who] of receptor) ([foes] of mover) )[
      report "bad"
    ][
      report "good"
    ]
  ]

  if ([breed] of mover = inverse-tats)[
    if-else (member? ([who] of receptor) ([foes] of mover) )[
      report "good"
    ][
      report "bad"
    ]
  ]

  if ([breed] of mover = resentfulls) [
    ifelse ( [last-interaction] of mover  = "good")[
      report "good"
    ][
      if ([last-interaction] of mover = "bad")[
        report "bad"
      ]
    ]
  ]

  if ([breed] of mover = vengefuls) [
    if ([last-interaction] of mover = "bad") [
      report "bad"
    ]
    report "good"
  ]
end

to create-venges [num-vengefuls]
  create-vengefuls num-vengefuls [
    setxy random-xcor random-ycor
    set shape "person"
    set color gray
    set health 30
    set friends []
    set foes []
    set next-friends []
    set next-foes []
    set last-interaction "good"
  ]
end


to create-resent [num-resents]
  create-resentfulls num-resents [
    setxy random-xcor random-ycor
    set shape "person"
    set color violet
    set health 30
    set friends []
    set foes []
    set next-friends []
    set next-foes []
    set last-interaction "good"
  ]
end
to create-invtats [num-invtats]
 create-inverse-tats num-invtats [
    setxy random-xcor random-ycor
    set shape "person"
    set color blue
    set health 30
    set friends []
    set foes []
    set next-friends []
    set next-foes []
  ]
end
to create-tats [num-tats]
 create-tit-for-tats num-tats [
    setxy random-xcor random-ycor
    set shape "person"
    set color pink
    set health 30
    set friends []
    set foes []
    set next-friends []
    set next-foes []
  ]
end
to create-goodts [num-goods]

  create-goods num-goods [
    setxy random-xcor random-ycor
    set shape "person"
    set color green
    set health 30
    set friends []
    set foes []
    set next-friends []
    set next-foes []
  ]
end

to create-badts [num-bads]

  create-bads num-bads[
    setxy random-xcor random-ycor
    set shape "person"
    set color red
    set health 30
    set friends []
    set foes []
    set next-friends []
    set next-foes []
  ]
end

to create-rands [num-rands]

  create-randomizeds num-rands[
    setxy random-xcor random-ycor
    set shape "person"
    set color yellow
    set health 30
    set friends []
    set foes []
    set next-friends []
    set next-foes []
  ]
end

to setup [num-goods num-bads num-rands num-tats num-invtats num-resents num-vengefuls]

  clear-all
  create-resent num-resents
  create-invtats num-invtats
  create-tats num-tats
  create-goodts num-goods
  create-badts num-bads
  create-rands num-rands
  create-venges num-vengefuls

  set num-good-relations 0
  set radius 5
  set survived -1
  set good-extinct -1
  reset-ticks
end

to-report average-health
  report mean [health] of turtles
end

to go [n_iter]
  if (permanent-links = False) [
    ask links [
      die
    ]
  ]

  tick

  ask turtles [ facexy random-xcor random-ycor ]
  ask turtles [ fd 10 ]

  ask turtles[

    let me self
    let touching-turtles other turtles in-radius radius

    ask touching-turtles [
      let him self
      let numero who
      let mymove move-strategy me self
      let hismove move-strategy self me

      if ( hismove = "bad" )[
        ask me[
          if (breed = resentfulls)[set last-interaction "bad"]

          if (breed = vengefuls)[set last-interaction "bad"]

          if (member? numero friends)[
            set next-friends remove numero next-friends
            set next-foes lput numero next-foes
          ]

          if (not member? numero foes) [
            set next-foes lput numero next-foes
          ]

          if-else (mymove = "good")[
            set health (health - 4 )
            if (Wo-links = False) [create-link-with him [set color [255 140 0]]]
          ][
            set health (health - 1 )
            if (Wo-links = False) [create-link-with him [set color red]]
          ]
        ]
      ]

      if ( hismove = "good" )[
        ask me[
          if (breed = resentfulls)[set last-interaction "good"]

          if (member? numero foes)[
            set next-foes remove numero next-foes
            set next-friends lput numero next-friends
          ]

          if ( not member? numero friends) [
            set next-friends lput numero next-friends
          ]

          if-else (mymove = "bad")[
            set health ( health + 5 )
            if (Wo-links = False) [create-link-with him [set color  [255 140 0]]]
          ][
            set health ( health + 3 )
            set num-good-relations ( num-good-relations + 1 )
            if (Wo-links = False) [create-link-with him [set color green]]
          ]
        ]
      ]
    ]

    let hambre ( 1 + ( log (count(turtles)) 10 ) )
    set health (health - hambre)
  ]

  ask turtles[
    if (health <= 0)[
      ;set radius (radius + 0.25)
      die
    ]
    set friends next-friends
    set foes next-foes
  ]


  if (ticks mod n_iter = 0)[
    if (survived = -1)[
      let media average-health
      show(word "Personas: " count(turtles))
      show(word "Num_bads: " count(bads))
      show(word "Num_goods: " count(goods))
      show(word "Num_rands: " count(randomizeds))
      show(word "Num_tats: " count(tit-for-tats))
      show(word "Num_resentfulls: " count(resentfulls))
      show(word "Num_vengefuls : " count(vengefuls))
    ]
    let nacidos round( num-good-relations / (2 * n_iter))
    show (word "Born: " nacidos)

    if (count turtles + nacidos > 800) [
      set nacidos (800 - count turtles)  ;; Adjust nacidos to fit within limit
    ]

    repeat nacidos [
      let random-breed  get-random-breed

      if (random-breed = "goods") [create-goodts 1]
      if (random-breed = "bads") [create-badts 1]
      if (random-breed = "randomizeds") [create-rands 1]
      if (random-breed = "tit-for-tats") [create-tats 1]
      if (random-breed = "inverse-tats" ) [create-invtats 1]
      if (random-breed = "vengefuls") [create-venges 1]
      if (random-breed = "resentfulls" ) [create-resent 1]

    ]

    set num-good-relations 0
  ]


   if ( count(turtles) <= 1 and survived = -1 )[
      set survived ticks
   ]

  if (count(goods) <= 1 and good-extinct = -1)[
    set good-extinct ticks
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
520
16
1138
635
-1
-1
14.9
1
10
1
1
1
0
1
1
1
-20
20
-20
20
0
0
1
ticks
32.0

BUTTON
0
15
89
48
SETUP
setup goods-spawn bads-spawn rands-spawn tats-spawn inverse-tats-spawn resentfulls-spawn vengefuls-spawn
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
90
14
145
47
Go
go 100 
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
145
14
200
47
Go
go 100
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
199
14
271
47
Erase links
ask links [die]
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
4
75
177
108
goods-spawn
goods-spawn
0
50
22.0
1
1
NIL
HORIZONTAL

SLIDER
3
108
175
141
bads-spawn
bads-spawn
0
50
5.0
1
1
NIL
HORIZONTAL

SLIDER
3
142
175
175
rands-spawn
rands-spawn
0
50
5.0
1
1
NIL
HORIZONTAL

SLIDER
4
175
176
208
tats-spawn
tats-spawn
0
50
13.0
1
1
NIL
HORIZONTAL

SWITCH
271
14
361
47
Wo-links
Wo-links
1
1
-1000

SLIDER
3
208
175
241
inverse-tats-spawn
inverse-tats-spawn
0
50
5.0
1
1
NIL
HORIZONTAL

SWITCH
361
14
485
47
permanent-links
permanent-links
1
1
-1000

PLOT
1150
27
1714
209
Breed Frequencies
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Greens" 1.0 0 -13840069 true "" "plot count(goods) / count(turtles)"
"Randoms" 1.0 0 -1184463 true "" "plot count(randomizeds) / count(turtles)"
"Tit-for-tat" 1.0 0 -2064490 true "" "plot count(tit-for-tats) / count(turtles)"
"Inverse-tat" 1.0 0 -13345367 true "" "plot count(inverse-tats) / count(turtles)"
"Bads" 1.0 0 -2674135 true "" "plot count(bads) / count(turtles)"
"Resentfulls" 1.0 0 -8630108 true "" "plot count (resentfulls) / count(turtles)"
"Vengefuls" 1.0 0 -7500403 true "" "plot count (vengefuls) / count(turtles)"

PLOT
1151
391
1727
570
Population
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
"default" 1.0 0 -16777216 true "" "plot count turtles"

PLOT
1154
223
1716
373
Population per group
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Bads" 1.0 0 -2674135 true "" "plot count bads"
"Goods" 1.0 0 -13840069 true "" "plot count goods"
"Inverse-tats" 1.0 0 -13345367 true "" "plot count inverse-tats"
"Tit-for-tat" 1.0 0 -2064490 true "" "plot count tit-for-tats"
"Randoms" 1.0 0 -1184463 true "" "plot count randomizeds"
"Vengefuls" 1.0 0 -7500403 true "" "plot count vengefuls"
"Resentfulls" 1.0 0 -8630108 true "" "plot count resentfulls"

SLIDER
0
352
162
385
prop-goods
prop-goods
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
1
385
162
418
prop-bads
prop-bads
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
1
418
162
451
prop-rands
prop-rands
0
100
1.0
1
1
NIL
HORIZONTAL

SLIDER
0
450
163
483
prop-tats
prop-tats
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
0
484
162
517
prop-inv-tats
prop-inv-tats
0
100
2.0
1
1
NIL
HORIZONTAL

TEXTBOX
5
323
155
341
Porporciones de nacimiento\n
11
0.0
1

TEXTBOX
11
55
161
73
Apariciones Iniciales
11
0.0
1

SLIDER
1
243
173
276
resentfulls-spawn
resentfulls-spawn
0
50
16.0
1
1
NIL
HORIZONTAL

SLIDER
0
517
162
550
prop-resentfulls
prop-resentfulls
0
100
4.0
1
1
NIL
HORIZONTAL

SLIDER
0
550
161
583
prop-vengefuls
prop-vengefuls
0
100
3.0
1
1
NIL
HORIZONTAL

SLIDER
1
276
173
309
vengefuls-spawn
vengefuls-spawn
0
50
9.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

Este código pretende simular una sociedad, donde la gente entra en conflicto y la resolución de cada conflicto funciona como un juego (del estilo de la teoría de juegos)

## HOW IT WORKS

En cada ciclo de simulación, los agentes se mueven a posiciones aleatorias y, si se encuentran dentro de un rango de interacción, entran en conflicto con los cercanos, combatiendo según un esquema basado en teoría de juegos, donde los puntos ganados o perdidos afectan su nivel de vida. Además, hay un factor de hambre que reduce su vida. Los agentes mueren si su vida llega a cero o menos, y nuevos agentes pueden nacer en función de la cantidad de relaciones positivas existentes.

el esquema es el siguiente:



+-- ----+---- ---+
|  +3/+3 | -4/+5 |
+----- -+----- --+
|  +5/-4 | -1 /-1 |
+--- ---+-- -----+

Por ejemplo si el turtle 1 es generoso y el turtle 2 es egoísta, el turtle 1 perderá 4 puntos y el turtle 2 ganará 5 puntos.

El hambre se calcula por cada tick como hambre = 1 + log(N) donde N es la población total, esto se le resta a la vida del agente en cada iteración

Los nacimientos son controlados por una variable n_iter que controla cada cuantas iteraciones nacen personas. La cantidad de personas que nacen es M/n_iter, donde M es la cantidad de todas las relaciones buenas (verdes) que han ocurrido es las últimas n_iter iteraciones

Existen diferentes agentes, cada agente tiene una estrategia de como lidiar con cada conflicto que encuentra:
Good: siempre es generoso (verde)
Bad: siempre egoísta (rojo)
Randomized: elige aleatoriamente en cada conflicto (amarillo)
Tit-for-tat: inicia siendo bueno, después repite el mismo movimiento que uso el otro turtle contra el que tiene conflicto la última vez que jugó contra él (rosa)
Inverse-tat: utiliza la lógica inversa a tit-for-tat (azul)
Resentful: empieza siendo bueno, después repite la misma estrategia usada contra él en su último conflicto (Nótese que no es como tit-fot-tat, pues este repite lo último que fues usado contra él mientras que tit-fot-tat repite lo último usado contra él por ese mismo turtle contra el que está en conflicto, es decir, tit-for-tat recuerda a los demás agentes) (violeta)
Vengeful: inicia bueno, se convierte en malo tras haberse encontrado con algún egoísta (gris)

## HOW TO USE IT

Para ejecutar una simulación, decida cuales agentes quiere que aparezcan inicialmente y cuantos de cada uno de ellos y también la proporción en la que nacerá cada uno de estos. Nótese que son proporciones, que luego serán normalizadas por lo que 1 y 1 es, en proporción, igual que 50 y 50.

## THINGS TO NOTICE

Tiene otros botones para eliminar los links, hacerlos permanentes, hacer que no aparezcan...
Además tiene una serie de gráficas para poder visualizar los cambios en la población.
Además la población total está limitado a 800 por su alta complejidad (exponencial al crecer exponencialmente la cantidad de nacimientos y la cantidad de conflictos)

## THINGS TO TRY

Busque diferentes ratios de inicializaciones y nacimientos para conseguir una sociedad que crezca. Véase que esta limitada la población máxima a 800 personas.
Busque también entender diferentes propeidades de los agentes. Nótese que ha de usarse un gran porcentaje de goods y tit-for-tats para que pueda existir la supervivencia, pues es mas fácil quitar vida que darla y además el hambre debilita a los agentes. Por esto mismo, agentes nivelados con el randomized harán más mal que bien a la sociedad.
## EXTENDING THE MODEL

Se puede expandir los tipos de agentes con distintos comportamientos, modificar la pérdida de salud para hacer más difícil la supervivencia o el número de nacimientos

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

https://ccl.northwestern.edu/netlogo/models/community/Learning%20Complicated%20Games%20-Galla&Farmer%20(2012)

https://ccl.northwestern.edu/netlogo/models/HubNetPrisonersDilemmaHubNet

https://ccl.northwestern.edu/netlogo/models/community/GameTheory

## CREDITS AND REFERENCES

Si tiene más interés en teoría de juegos o agentes jugadores, véa el video "What Game Theory Reveals About Life, The Universe, and Everything" del canal Veritasium
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
NetLogo 6.4.0
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
