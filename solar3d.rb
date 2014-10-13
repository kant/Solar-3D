1 # To change this template, choose Tools | Templates
2 # and open the template in the editor.
3
4 require 'sketchup.rb'
5
6 class Simulation
7
8 NOW = 0
9 HOUR = 1
10 DAY = 2
11 MONTH = 3
12 YEAR = 4
13 N_DAY_MONTH = [31,28,31,30,31,30,31,31,30,31,30,31]
14
15 def initialize(option,mod)
16 @option = option
17 @mod = mod
18 title = ""
19 datetime = ""
20 header = ""
21 body = ""
22 case(@option)
23 when NOW
24 start = Time.now
25 Sketchup.status_text = "Simulación en curso. Espere!!!"
26 time = Site.get_datetime()
27 e = @mod.sim_module_at_time(time)
28 e.convert_to(ModuleEnergy::W)
29 Sketchup.status_text = "Simulación finalizada!!!"
30 title = "Factor de sombreado e irradiancia;;;;;;\n"
31 datetime = "Data:;#{time.strftime("%d/%m/%Y")};Hora:;#{time.strftime("%H:%M")};;Tempo:;#{((Time. now - start)/60.0).round_to(6)} min\n"
32 header = "Fs;Gt (W/m²);Gts (W/m²);Gdt (W/m²);Gdts (W/m²);E (W);Es (W)\n"
33 body = "-#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sprintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.3f",e.e_ts)}_\n"
34 when HOUR
35 start = Time.now
36 Sketchup.status_text = "Simulación en curso. Espere!!!"
37 time = Site.get_datetime()
38 e = @mod.sim_module_at_hour(time)
39 e.convert_to(ModuleEnergy::KWH)
40 Sketchup.status_text = "Simulación finalizada!!!"
41 title = "Factor de sombreado e irradiancia horaria;;;;;;\n"
42 datetime = "Data:;#{time.strftime("%d/%m/%Y")};Hora:;#{time.strftime("%H")};;Tempo:;#{((Time.now - start)/60.0).round_to(6)} min\n"
43 header = "Fs;It (kWh/m²);Its (kWh/m²);Idt (kWh/m²);Idts (kWh/m²);E (W);Es (W)\n"
44 body = "-#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sprintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.3f",e.e_ts)}_\n"
45 when DAY
46 start = Time.now
47 Sketchup.status_text = "Simulación en curso. Espere!!!"
48 time = Site.get_datetime()
49 e_d = @mod.sim_module_at_day(time,true)
50 Sketchup.status_text = "Simulación finalizada!!!"
51 hour = 0
52 title = "Factor de sombreado e irradiancia diaria;;;;;;;\n"
53 datetime = "Data:;#{time.strftime("%d/%m/%Y")};;;;;Tempo:;#{((Time.now -
start)/60.0).round_to(6)} min\n"
54 header = "Hora;Fs;It (kWh/m²);Its (kWh/m²);Idt (kWh/m²);Idts (kWh/m²);E (W);Es (W)\n"
55 b = ""
56 for e in e_d
57 e.convert_to(ModuleEnergy::KWH)
58 b << "-#{sprintf("%.0f",hour)};#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sprintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.3f",e.e_ts)}_\n" if(hour < (e_d.size - 1))
59 b <<"-Dia;#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sprintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.3f",e.e_ts)}_\n" if(hour == (e_d.size - 1))
60 hour += 1
61 end
62 body = b
63 when MONTH
64 start = Time.now
65 Sketchup.status_text = "Simulación en curso. Espere!!!"
66 time = Site.get_datetime()
67 e_m = @mod.sim_module_at_month(time,true)
68 Sketchup.status_text = "Simulación finalizada!!!"
69 day = 1
70 title = "Factor de sombreado e irradiancia diaria promedio mensual;;;;;;;\n"
71 datetime = "Mês:;#{time.strftime("%m/%Y")};;;;;Tempo:;#{((Time.now - start)/60.0).round_to(6)} min\n"
72 header = "Dia;Fs;Ht (kWh/m²);Hts (kWh/m²);Hdt (kWh/m²);Hdts (kWh/m²);E (W);Es (W)\n"
73 b = ""
74 for e in e_m do
75 if(day < e_m.size)then
76 e.convert_to(ModuleEnergy::KWH)
77 b << "-#{sprintf("%.0f",day)};#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sprintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.3f",e.e_ts)}_\n"
78 elsif(day == e_m.size)
79 e.convert_to(ModuleEnergy::KWH,e_m.size - 1)
80 b << "-Mês;#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sp
rintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.
3f",e.e_ts)}_\n"
81 end
82 day += 1
83 end
84 body = b
85 when YEAR
86 start = Time.now
87 Sketchup.status_text = "Simulación en curso. Espere!!!"
88 time = Site.get_datetime()
89 e_y = @mod.sim_module_at_year(time)
90 Sketchup.status_text = "Simulación finalizada!!!"
91 month = 1
92 n_day_month = N_DAY_MONTH[(time.month - 1)]
93 n_day_month += 1 if((time.month == 2)&&(Site.leap_year?() == true))
94 title = "Factor de sombreado e irradiancia diaria promedio anual;;;;;;;\n"
95 datetime = "Ano:;#{time.strftime("%Y")};;;;;Tempo:;#{((Time.now - start)/60.0).round_to(6)} min\n"
96 header = "Mês;Fs;Ht (kWh/m²);Hts (kWh/m²);Hdt (kWh/m²);Hdts (kWh/m²);E (W);Es (W)\n"
97 b = ""
98 for e in e_y do
99 if(month < e_y.size)then
100 e.convert_to(ModuleEnergy::KWH,n_day_month)
101 b << "-#{sprintf("%.0f",month)};#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sprintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.3f",e.e_ts)}_\n"
102 elsif(month == e_y.size)
103 if(Site.leap_year?() == true)
104 n_year = 366
105 else
106 n_year = 365
107 end
108 e.convert_to(ModuleEnergy::KWH,n_year)
109 b << "-Ano;#{sprintf("%.3f",e.fs)};#{sprintf("%.3f",e.i_t)};#{sprintf("%.3f",e.i_ts)};#{sprintf("%.3f",e.i_d)};#{sprintf("%.3f",e.i_ds)};#{sprintf("%.3f",e.e_t)};#{sprintf("%.3f",e.e_ts)}_\n"
110 end
111 month += 1
112 end
113 body = b
114 end
115 data = ""
116 data << title
117 data << datetime
118 data << header
119 data << body
120 data << ";;;;;;"
121 data.gsub!('.',',')
122 data.gsub!('-','')
123 data.gsub!('_','')
124 @mod.file_append(data)
125 title.gsub!(';','')
126 header.gsub!(';','</th><th scope="col">')
127 header.gsub!('²','&sup2;')
128 header.gsub!('ê','&ecirc;')
129 body.gsub!('.', ',')
130 body.gsub!('-','<tr align="center" style="font-family:Arial, Helvetica, sans-serif; color:#0033FF"><td>')
131 body.gsub!('_','</td></tr>')
132 body.gsub!(';','</td><td>')
133 body.gsub!('ê','&ecirc;')
134 datetime.gsub!(';',' ')
135 datetime.gsub!('ê','&ecirc;')
136 html = "<table width='700' border='2' align='center' cellpadding='0' cellspacing='0' bordercolor='#000033' bgcolor='#FFFFFF'>"
137 html << "<tr align='center' style='font-family:Arial, Helvetica, sans-serif; color:#000033'><th scope='col'>#{header}</th></tr>"
138 html << "#{body}"
139 html << "</table>"
140 html << "<p align='center' style='font-family:Arial, Helvetica, sans-serif; color:#000033'>#{datetime}</p>"
141 dlg = UI::WebDialog.new(title, true,"Solar3DBR",700, 450, 150, 150, true);
142 dlg.set_html(html)
143 dlg.show
144 end
145
146 end
147
148 class Modules
149
150 POL_MET = 0.00064516
151 MEAN_DAY = [17,16,16,15,15,11,17,16,15,15,14,10]
152 N_DAY_MONTH = [31,28,31,30,31,30,31,31,30,31,30,31]
153
154 attr_accessor :n
155 attr_accessor :fs_d_iso_total
156 attr_accessor :surfaces
157
158 def initialize
159 @faces ||= Array.new()
160 @surfaces ||= Array.new()
161 @area = 0.0
162 @n = 0.1562
163 @file = Array.new()
164 end
165
166 def select_module_surfaces(entity = Sketchup.active_model.entities)
167 @faces.clear()
168 entity.each { |ent|
169 if((ent.layer.name == "Módulos")&&(ent.kind_of?(Sketchup::Face)))
170 f = Array.new(3)
171 f[0] = ent
172 f[1] = ent.material
173 f[2] = ent.back_material
174 @faces.push(f)
175 end
176 }
177 end
178
179 def show_face_direction()
180 model = Sketchup.active_model
181 selection = model.selection
182 selection.clear()
183 @faces.each { |face|
184 face[0].material = "green"
185 face[0].back_material = "red"
186 }
187 end
188
189 def invert_face_direction()
190 model = Sketchup.active_model
191 sel = model.selection
192 sel.each { |face| face.reverse! if((face.layer.name == "Módulos")&&(face.kind_of?(Sketchup::Face)))}
193 sel.clear()
194 end
195
196 def hide_face_direction()
197 @faces.each { |face|
198 face[0].material = face[1]
199 face[0].back_material = face[2]
200 }
201 end
202
203 def submit_module_surfaces(resolution)
204 start = Time.now
205 survey = Survey.new()
206 @surfaces.clear()
207 @area = 0.0
208 @fs_d_iso_total = 0.0
209 for face in @faces
210 @area += face[0].area
211 s = Surface.new(face[0],survey,resolution)
212 @surfaces.push(s)
213 end
214 @area *= POL_MET
215 @fs_d_iso_total = 0.0
216 for surface in @surfaces
217 a = surface.area * POL_MET
218 @fs_d_iso_total += surface.fs_d_iso * (a / @area)
219 end
220 puts("Factores de sombreado calculados en: #{(Time.now - start)/60.0} min;;;;;;;;;;;")
221 puts("Factores de sombreado difuso isotrópico: #{@fs_d_iso_total};;;;;;;;;;;")
222 end
223
224 def sim_module_at_year(time)
225 e_t = 0.0
226 e_b = 0.0
227 e_d = 0.0
228 e_ts = 0.0
229 e_bs = 0.0
230 e_ds = 0.0
231 e = Array.new()
232 (1..12).each { |month|
233 time_y = Time.utc(time.year,month)
234 e_m = sim_module_at_month(time_y,false)
235 e.push(e_m)
236 }
237 e.each { |energy|
238 e_t += energy.e_t
239 e_b += energy.e_b
240 e_d += energy.e_d
241 e_ts += energy.e_ts
242 e_bs += energy.e_bs
243 e_ds += energy.e_ds
244 }
245 e_y = ModuleEnergy.new(true,@n,@area,e_t,e_b,e_d,e_ts,e_bs,e_ds)
246 e.push(e_y)
247 e
248 end
249
250 def sim_module_at_month(time,day_values)
251 e_t = 0.0
252 e_b = 0.0
253 e_d = 0.0
254 e_ts = 0.0
255 e_bs = 0.0
256 e_ds = 0.0
257 e = Array.new()
258 last_day = N_DAY_MONTH[(time.month - 1)]
259 last_day += 1 if((time.month == 2)&&(Site.leap_year?() == true))
260 (1..last_day).each { |i|
261 time_dm = Time.utc(time.year,time.month,i)
262 e_dm = sim_module_at_day(time_dm,false)
263 e.push(e_dm)
264 }
265 e.each { |energy|
266 e_t += energy.e_t
267 e_b += energy.e_b
268 e_d += energy.e_d
269 e_ts += energy.e_ts
270 e_bs += energy.e_bs
271 e_ds += energy.e_ds
272 }
273 e_m = ModuleEnergy.new(true,@n,@area,e_t,e_b,e_d,e_ts,e_bs,e_ds)
274 if(day_values == true)
275 e.push(e_m)
276 e
277 else
278 e_m
279 end
280 end
281
282 def sim_module_at_day(time,hour_values)
283 e_t = 0.0
284 e_b = 0.0
285 e_d = 0.0
286 e_ts = 0.0
287 e_bs = 0.0
288 e_ds = 0.0
289 e = Array.new()
290 (0..23).each { |i|
291 time_d = Time.utc(time.year,time.month,time.day,i)
292 e_h = sim_module_at_hour(time_d)
293 e.push(e_h)
294 }
295 e.each { |energy|
296 e_t += energy.e_t
297 e_b += energy.e_b
298 e_d += energy.e_d
299 e_ts += energy.e_ts
300 e_bs += energy.e_bs
301 e_ds += energy.e_ds
302 }
303 e_dm = ModuleEnergy.new(true,@n,@area,e_t,e_b,e_d,e_ts,e_bs,e_ds)
304 if(hour_values == true)
305 e.push(e_dm)
306 e
307 else
308 e_dm
309 end
310 end
311
312 def sim_module_at_hour(time)
313 e_t = 0.0
314 e_b = 0.0
315 e_d = 0.0
316 e_ts = 0.0
317 e_bs = 0.0
318 e_ds = 0.0
319 sun_rise_times = 0.0
320 sun_is_rised = true
321 e = Array.new()
322 0.step(50,10) { |i|
323 time_h = Time.utc(time.year,time.month,time.day,time.hour,i)
324 e_hm = sim_module_at_time(time_h)
325 e.push(e_hm)
326 }
327 e.each { |energy|
328 e_t += (energy.e_t / 6.0) # Energia em 10min.
329 e_b += (energy.e_b / 6.0) # Energia em 10min.
330 e_d += (energy.e_d / 6.0) # Energia em 10min.
331 e_ts += (energy.e_ts / 6.0) # Energia em 10min.
332 e_bs += (energy.e_bs / 6.0) # Energia em 10min.
333 e_ds += (energy.e_ds / 6.0) # Energia em 10min.
334 sun_rise_times += energy.sun_is_rised
335 }
336 sun_is_rised = false if(sun_rise_times == 0.0)
337 e_h = ModuleEnergy.new(sun_is_rised,@n,@area,e_t,e_b,e_d,e_ts,e_bs,e_ds)
338 e_h
339 end
340
341 def sim_module_at_time(time)
342 Site.set_datetime(time)
343 sun = SunPosition.new()
344 sun_is_rised = true
345 if((sun.w.round_to(4) > -sun.w_sunset.round_to(4))&&(sun.w.round_to(4) <
sun.w_sunset.round_to(4)))
346 v_north = Geom::Vector3d.new(0,1,0)
347 v_sol = sun.sun_vector
348 p_sol = Geom::Point3d.new(v_sol.x,v_sol.y,v_sol.z)
349 for surface in @surfaces
350 ih = Site.get_irrad()
351 irrad =
Irrad.new(sun,surface.face,surface.beta,surface.azimuth,ih[0],ih[1])
352 f_shad_beam = 0.0
353 f_shad_dif = 0.0
354 unless(irrad.i_t == 0.0)
355 v_face_sol = surface.p_face.vector_to(p_sol)
356 v_face_sol_projection =
Geom::Vector3d.new(v_face_sol.x,v_face_sol.y,0)
357 el = v_face_sol_projection.angle_between(v_face_sol)
358 el = -el if(v_face_sol.z < 0.0)
359 az = v_north.angle_between(v_face_sol_projection)
360 az = (2.0 * Math::PI) - az if(v_face_sol_projection.x < 0.0)
361 f_shad_beam = surface.get_face_shad(az,el)
362 if(irrad.i_d > 0.0)
363 f_shad_dif = f_shad_beam
405 return false
406 end
407 end
408
409 end
410
411 class ModuleEnergy
412
413 POL_MET = 0.00064516
414 W = 0.0002778
415 KWH = 0.0000002778
416
417 attr_accessor :sun_is_rised
418 attr_accessor :e_t
419 attr_accessor :e_b
420 attr_accessor :e_d
421 attr_accessor :e_to
422 attr_accessor :e_ts
423 attr_accessor :e_bs
424 attr_accessor :e_ds
425 attr_accessor :e_tos
426 attr_accessor :i_t
427 attr_accessor :i_d
428 attr_accessor :i_ts
429 attr_accessor :i_ds
430 attr_accessor :fs
431 attr_accessor :fs_b
432 attr_accessor :fs_d
433
434 def initialize(sun_is_rised,n,area,*args)
435 @e_t = 0.0
436 @e_b = 0.0
437 @e_d = 0.0
438 @e_to = 0.0
439 @e_ts = 0.0
440 @e_bs = 0.0
441 @e_ds = 0.0
442 @e_tos = 0.0
443 @i_t = 0.0
444 @i_d = 0.0
445 @i_ts = 0.0
446 @i_ds = 0.0
447 @fs = 0.0
448 @fs_b = 0.0
449 @fs_d = 0.0
450 @sun_is_rised = 0.0
451 if(sun_is_rised == true)
452 @sun_is_rised = 1.0
453 if(args.size > 1)
454 @e_t = args[0]
364 else
365 f_shad_dif = 0.0
366 end
367 end
368 i_b = irrad.i_b * (1.0 - f_shad_beam)
369 i_d = (irrad.i_d_iso * (1.0 - surface.fs_d_iso)) + (irrad.i_d_circ *
(1.0 - f_shad_dif)) + irrad.i_d_hor
370 i_t = i_b + i_d + irrad.i_ref
371 surface.i_t = irrad.i_t
372 surface.i_b = irrad.i_b
373 surface.i_d = irrad.i_d
374 surface.i_ts = i_t
375 surface.i_bs = i_b
376 surface.i_ds = i_d
377 end
378 else
379 sun_is_rised = false
380 end
381 GC.start()
382 e = ModuleEnergy.new(sun_is_rised,@n,@area,@surfaces)
383 e
384 end
385
386 def file_append(data)
387 @file.push(data)
388 end
389
390 def file_save()
391 path = UI.savepanel "Guardar resultados", "c:\\", "Solar3DBR"
392 unless(path.nil? == true)
393 path << ".csv"
394 f = File.new(path, 'w')
395 @file.each { |data| f.print(data) }
396 f.close()
397 @file.clear()
398 end
399 end
400
401 def file_empty?()
402 if(@file.size == 0)
403 return true
404 else
455 @e_b = args[1]
456 @e_d = args[2]
457 @e_ts = args[3]
458 @e_bs = args[4]
459 @e_ds = args[5]
460 else
461 for surf in args[0]
462 area_s = surf.area * POL_MET
463 @e_t += (surf.i_t * area_s)
464 @e_b += (surf.i_b * area_s)
465 @e_d += (surf.i_d * area_s)
466 @e_ts += (surf.i_ts * area_s)
467 @e_bs += (surf.i_bs * area_s)
468 @e_ds += (surf.i_ds * area_s)
469 end
470 end
471 @e_to = @e_t * n
472 @e_tos = @e_ts * n
473 if(area > 0.0)
474 @i_t = @e_t / area
475 @i_d = @e_d / area
476 @i_ts = @e_ts / area
477 @i_ds = @e_ds / area
478 end
479 @fs = 1.0 - (@e_ts / @e_t) if(@e_t > 0.0)
480 @fs_b = 1.0 - (@e_bs / @e_b) if(@e_b > 0.0)
481 @fs_d = 1.0 - (@e_ds / @e_d) if(@e_d > 0.0)
482 end
483 end
484
485 def convert_to(conv_factor,n_average = 1)
486 @e_t = (@e_t * conv_factor)/n_average
487 @e_b = (@e_b * conv_factor)/n_average
488 @e_d = (@e_d * conv_factor)/n_average
489 @e_to = (@e_to * conv_factor)/n_average
490 @e_ts = (@e_ts * conv_factor)/n_average
491 @e_bs = (@e_bs * conv_factor)/n_average
492 @e_ds = (@e_ds * conv_factor)/n_average
493 @e_tos = (@e_tos * conv_factor)/n_average
494 @i_t = (@i_t * conv_factor)/n_average
495 @i_d = (@i_d * conv_factor)/n_average
496 @i_ts = (@i_ts * conv_factor)/n_average
497 @i_ds = (@i_ds * conv_factor)/n_average
498 end
499
500 end
501
502 class Surface
503
504 HALF_PI = Math::PI/2.0
505 TWO_PI = 6.2832
506 TRAP_CONST1_1 = 0.0001523087099
507 TRAP_CONST2_2 = 0.0006092348
508 TRAP_CONST5_5 = 0.00380771
509 TRAP_CONST10_10 = 0.0152308
510 EL_ARC1_1 = 0.017453292
511 EL_ARC2_2 = 0.0349066
512 EL_ARC5_5 = 0.08726646
513 EL_ARC10_10 = 0.17453292
514 POL_MET = 0.00064516
515 M1_1 = "1°x1°"
516 M2_2 = "2°x2°"
517 M5_5 = "5°x5°"
518 M10_10 = "10°x10°"
519 NOT_INTER = 0
520 SUB_CLIP_CROSS = 1
521 SUBJECT_INSIDE = 2
522 CLIP_INSIDE = 3
523
524 attr_accessor :face
525 attr_accessor :area
526 attr_accessor :p_face
527 attr_accessor :beta
528 attr_accessor :azimuth
529 attr_accessor :fs_d_iso
530 attr_accessor :i_t
531 attr_accessor :i_b
532 attr_accessor :i_d
533 attr_accessor :i_ts
534 attr_accessor :i_bs
535 attr_accessor :i_ds
536
537 def initialize(face,survey,resolution)
538 @face = face
539 @area = @face.area
540 @p_face = face.vertices[0].position
541 @survey = survey
542 @fs = Array.new()
543 if(resolution == M1_1)
544 @trap_const = TRAP_CONST1_1
545 @el_arc = EL_ARC1_1
546 @pass_az = 1.0
547 @pass_el = 1.0
548 elsif(resolution == M2_2)
549 @trap_const = TRAP_CONST2_2
550 @el_arc = EL_ARC2_2
551 @pass_az = 2.0
552 @pass_el = 2.0
553 elsif(resolution == M5_5)
554 @trap_const = TRAP_CONST5_5
555 @el_arc = EL_ARC5_5
556 @pass_az = 5.0
557 @pass_el = 5.0
558 elsif(resolution == M10_10)
559 @trap_const = TRAP_CONST10_10
560 @el_arc = EL_ARC10_10
561 @pass_az = 10.0
562 @pass_el = 10.0
563 end
564 set_surface_angles()
565 set_surface_shad()
566 end
567
568 def set_surface_angles()
569 v_p_projection = Geom::Vector3d.new(@face.normal.x,@face.normal.y,0)
570 v_north = Geom::Vector3d.new(0,1,0)
571 @beta = HALF_PI - v_p_projection.angle_between(@face.normal)
572 if(@beta == 0.0)
573 @azimuth = 0.0
574 else
575 @azimuth = v_north.angle_between(v_p_projection)
576 @azimuth = (2.0 * Math::PI) - @azimuth if(v_p_projection.x < 0)
577 end
578 end
579
580 def set_surface_shad()
581 @fs_d_iso = 0.0
582 area_shad_dif = 0.0 # Área total dos obstáculos projetados no hemisfério
583 @max_el = 0
584 min_z = 0.0
585
586 poly_face_dirty = Array.new()
587 @face.outer_loop.vertices.each { |vert_face| # Verifica a menor altura de @face
588 poly_face_dirty.push(vert_face.position)
589 m_z ||= vert_face.position.z
590 m_z = vert_face.position.z if(vert_face.position.z < m_z)
591 min_z = m_z unless(m_z.nil?)
592 min_z = min_z.round_to(3)
593 }
594
595 poly_face = prepare_face(poly_face_dirty) # Polígono contendo os pontos de @face
596
597 for face_sur in @survey.faces
598 unless(face_sur[Survey::FACE].entityID == @face.entityID)
599 poly_face.each { |p_f|
600 face_sur[Survey::FACE].outer_loop.vertices.each { |vert_f_sur|
601 v_el = p_f.vector_to(vert_f_sur.position)
602 v_el_proj = Geom::Vector3d.new(v_el.x,v_el.y,0)
603 m_el = v_el_proj.angle_between(v_el)
604 @max_el = m_el if(m_el > @max_el)
605 }
606 }
607 end
608 end
609 @max_el = @max_el.radians()
610 @max_el = (@max_el/@pass_el).ceil * @pass_el
611 @max_el = 90 if(@max_el > 90)
612
613 0.0.step(360.0,@pass_az) { |azimute| # Varia o azimute de 0 à 360°
614 el_shad = Array.new(91)
615 az = azimute
616 elevation = 0.0
617 el = elevation
618 poly_error = false
619 poly_error_count = 0
620 while(elevation <= @max_el)
621 f_shad_beam = 0.0 # Fator de sombreamento direto: fb(az,el)
622 sun_behind = false
623 poly_to_clip = Array.new() # Armazena os poligonos que
certamente obstruem @face
624 shades_to_clip = Array.new()
625
626 el_rad = el.degrees() # Encontra a direção dada por aze el
627 az_rad = az.degrees()
628 cosel = Math.cos(el_rad)
629 x = cosel * Math.sin(az_rad)
630 y = cosel * Math.cos(az_rad)
631 z = Math.sin(el_rad)
632 dir_vector = Geom::Vector3d.new(x,y,z) # Vetor com origem (0,0,0) e direção az,el - Aponta para o Sol
633
634 angle_f_normal_sun = @face.normal.angle_between(dir_vector)
635 if(angle_f_normal_sun <= HALF_PI)
636 for face_survey in @survey.faces
637 unless(face_survey[Survey::FACE].entityID == @face.entityID) # Exclui @face da análise
638 if(face_survey[Survey::MAX_Z] > min_z) # Apenas analisa superfícies acima de @face
639 poly_proj_dirty = Array.new() # Armazena os vértices da projeção de face_survey em @face
640 vertices_face_survey = face_survey[Survey::FACE].outer_loop.vertices
641 (0..(vertices_face_survey.size - 1)).each { |v_f_s|
642 vert_face_survey = vertices_face_survey[v_f_s].position
643 v_p_face_p_face_survey = @p_face.vector_to(vert_face_survey) # Conta a quantidade de pontos de face_survey atrás de @face
644 angle_f_normal_p_face_survey = @face.normal.angle_between(v_p_face_p_face_survey)
645 if(angle_f_normal_p_face_survey <= HALF_PI)
646 line_vert_face_survey = [vert_face_survey,dir_vector] # Projeta o ponto de face_survey no plano de @face
647 p_intersect_vert_face_survey = Geom.intersect_line_plane(line_vert_face_survey,@face.plane)
648 poly_proj_dirty.push(p_intersect_vert_face_survey) unless (p_intersect_vert_face_survey == nil)
649 else
650 if(v_f_s == 0)
651 p_v_face_p = vertices_face_survey[vertices_face_survey.size - 1].position
652 else
653 p_v_face_p = vertices_face_survey[v_f_s - 1].position
654 end
655 if(v_f_s == (vertices_face_survey.size - 1))
656 p_v_face_n = vertices_face_survey[0].position
657 else
658 p_v_face_n = vertices_face_survey[v_f_s + 1].position
659 end
660 line_inter_p = [vert_face_survey,p_v_face_p]
661 p_inter_p = Geom.intersect_line_plane(line_inter_p,@face.plane)
662 unless(p_inter_p == nil)
663 dist_p = vert_face_survey.distance(p_v_face_p).round_to(4)
664 dist_p_inter = p_v_face_p.distance(p_inter_p).round_to(4)
665 dist_vp_inter = vert_face_survey.distance(p_inter_p).round_to(4)
666 poly_proj_dirty.push(p_inter_p) if((dist_p_inter <= dist_p)&&(dist_vp_inter <= dist_p))
667 end
668 line_inter_n = [vert_face_survey,p_v_face_n]
669 p_inter_n = Geom.intersect_line_plane(line_inter_n,@face.plane)
670 unless(p_inter_n == nil)
671 dist_n = vert_face_survey.distance(p_v_face_n).round_to(4)
672 dist_n_inter = p_v_face_n.distance(p_inter_n).round_to(4)
673 dist_vn_inter = vert_face_survey.distance(p_inter_n).round_to(4)
674 poly_proj_dirty.push(p_inter_n) if((dist_n_inter <= dist_n)&&(dist_vn_inter <= dist_n))
675 end
676 end
677 }
678 if(poly_proj_dirty.size > 2)
679 poly_proj = prepare_face(poly_proj_dirty) # Remove pontos desnecessários e acerta a direção.
680 if(poly_proj.size > 2) # Se todos os pontos estiverem a frente de @face, computa as interseções
681 begin
682 inter_elements = find_intersections(poly_face,poly_proj)
683 if(inter_elements[0] == CLIP_INSIDE)
684 f_shad_beam = 1.0
685 elsif(inter_elements[0] == SUBJECT_INSIDE)
686 shades_to_clip.push(poly_proj)
687 elsif(inter_elements[0] == SUB_CLIP_CROSS)
688 poly_to_clip.push(inter_elements)
689 end
690 rescue
691 poly_error = true
692 poly_error_count += 1
693 end
694 end
695 end
696 end
697 end
698 break if(f_shad_beam == 1.0)
699 end
700 else
701 f_shad_beam = 1.0
702 sun_behind = true
703 end
704
705 if((f_shad_beam != 1.0)&&(poly_to_clip.size > 0)&&(poly_error == false))
706 poly_to_clip.each { |poly_list|
707 begin
708 shades_projected = clip_polygon(poly_list[1],poly_list[2])
709 shades_projected.each { |sh_proj| shades_to_clip.push(sh_proj) if(sh_proj.size > 2)}
710 rescue
711 poly_error = true
712 poly_error_count += 1
713 end
714 }
715 end
716
717 if((f_shad_beam != 1.0)&&(shades_to_clip.size > 0)&&(poly_error == false))
718 shades_part = Hash.new()
719 area_shad_beam = 0.0
720 r = 0
721 shades_part[r] = shades_to_clip[0]
722 (1..(shades_to_clip.size - 1)).each { |s|
723 shade_cliped_list = Array.new()
724 clip_into = false
725 shades_part.each { |k,shade_part_r|
726 shade_cliped = Array.new()
727 begin
728 shade_clip_items = find_intersections(shades_to_clip[s].reverse,shade_part_r)
729 rescue
730 poly_error = true
731 poly_error_count += 1
732 end
733 if(shade_clip_items[0] == CLIP_INSIDE)
734 shade_cliped[0] = nil
735 shade_cliped[1] = nil
736 shade_cliped[2] = nil
737 clip_into = true
738 break
739 elsif(shade_clip_items[0] == SUBJECT_INSIDE)
740 shade_cliped[0] = k
741 shade_cliped[1] = s
742 shade_cliped[2] = nil
743 elsif(shade_clip_items[0] == NOT_INTER)
744 shade_cliped[0] = nil
745 shade_cliped[1] = s
746 shade_cliped[2] = nil
747 else
748 shade_cliped[0] = k
749 shade_cliped[1] = s
750 begin
751 shade_cliped[2] = subtract_polygon(shade_clip_items[1],shade_clip_items[2])
752 rescue
753 poly_error = true
754 poly_error_count += 1
755 end
756 end
757 shade_cliped_list.push(shade_cliped)
758 }
759 s_included = false
760 if(clip_into == false)
761 shade_cliped_list.each { |sh_c_list|
762 shades_part.delete(sh_c_list[0]) unless(sh_c_list[0].nil? == true)
763 if((s_included == false)&&(sh_c_list[1].nil? == false))
764 s_included = true
765 r += 1
766 shades_part[r] = shades_to_clip[sh_c_list[1]] if(shades_to_clip[sh_c_list[1]].size > 2)
767 end
768 if(sh_c_list[2].nil? == false)
769 sh_c_list[2].each { |sh_part|
770 r += 1
771 shades_part[r] = sh_part if(sh_part.size > 2)
772 }
773 end
774 }
775 end
776 }
777 shades_part.each_value{|sh| area_shad_beam += Geometrics.calc_face_area(sh)}
778 f_shad_beam = area_shad_beam / @area
779 end
780
781 if(poly_error == false)
782 if((f_shad_beam > 0.0)&&(elevation < 90)&&(azimute < 360)&&(sun_behind == false))
783 area_shad = 0.0
784 area_shad = f_shad_beam * (@trap_const * (Math.cos(el_rad) + Math.cos(el_rad + @el_arc)))
785 area_shad_dif += area_shad
786 end
787 el_shad[elevation/@pass_el] = f_shad_beam
788 elevation += @pass_el
789 el = elevation
790 az = azimute
791 poly_error_count = 0
792 else
793 if(poly_error_count == 1)
794 el += 0.5
795 az += 0.5
796 else
797 f_shad_beam = 1.0
798 f_shad_beam = el_shad[elevation - @pass_el] if(elevation > 0)
799 if((f_shad_beam > 0.0)&&(elevation < 90)&&(azimute < 360))
800 area_shad = 0.0
801 area_shad = f_shad_beam * (@trap_const * (Math.cos(el_rad) + Math.cos(el_rad + @el_arc)))
802 area_shad_dif += area_shad
803 end
804 el_shad[elevation/@pass_el] = f_shad_beam
805 elevation += @pass_el
806 el = elevation
807 az = azimute
808 poly_error_count = 0
809 end
810 poly_error = false
811 end
812 end
813 @fs.push(el_shad)
814 GC.start()
815 }
816 @fs_d_iso = area_shad_dif / ((1.0 + Math.cos(@beta)) * Math::PI)
817 end
818
819 def find_intersections(poly_clip,poly_subject)
820 index_inter_clip = poly_clip.size # Indice
inicial das interseções
821 index_inter_sub = poly_subject.size
822 count_p_sub_inside = 0
823 count_p_sub_border = 0
824 count_p_clip_inside = 0
825 count_p_clip_border = 0
826 count_p_intersection = 0
827 inter_elements = Array.new()
828 result = NOT_INTER
829
830 subject_list = create_poly_list(poly_subject) # Inicia a lista do poligono Subject com os vértices projetados
831 clip_list = create_poly_list(poly_clip) # Inicia a lista do poligono Clip com os vértices de @face
832
833 (0..(poly_subject.size - 1)).each { |p_s_k| # Verifica se os pontos estão dentro, na borda ou fora de clip
834 degree_p = 0.0
835 border = false
836 p_s = poly_subject[p_s_k]
837 p_c_b = poly_clip[0]
838 dist_b = p_s.distance(p_c_b)
839 dist_b = dist_b.round_to(4)
840 v_c_b = p_s.vector_to(p_c_b)
841 (1..poly_clip.size).each { |p_c|
842 p_c_a = p_c_b
843 dist_a = dist_b
844 v_c_a = v_c_b
845 if(p_c == poly_clip.size)
846 p_c_b = poly_clip[0]
847 else
848 p_c_b = poly_clip[p_c]
849 end
850 dist_b = p_s.distance(p_c_b)
851 dist_b = dist_b.round_to(4)
852 v_c_b = p_s.vector_to(p_c_b)
853 v_sum = v_c_a * v_c_b
854 if((v_sum.x.round_to(3) == 0)&&(v_sum.y.round_to(3) == 0)&&(v_sum.z.round_to(3) == 0))
855 dist_ab = p_c_a.distance(p_c_b)
856 dist_ab = dist_ab.round_to(4)
857 if((dist_a <= dist_ab)&&(dist_b <= dist_ab))
858 border = true
859 break
860 end
861 else
862 d_p = v_c_a.angle_between(v_c_b)
863 d_p *= -1 if(v_sum.z < 0)
864 degree_p += d_p
865 end
866 }
867 if(border == true)
868 count_p_sub_border += 1
869 subject_list[p_s_k].side = PolyListItem::INSIDE
870 else
871 degree_p = degree_p.abs.ceil_to(4)
872 if(degree_p == TWO_PI)
873 count_p_sub_inside += 1
874 subject_list[p_s_k].side = PolyListItem::INSIDE
875 end
876 end
877 }
878
879
880 if((count_p_sub_inside + count_p_sub_border) == poly_subject.size)
881 result = SUBJECT_INSIDE
882 else
883
884 (0..(poly_clip.size - 1)).each { |p_c_k| # Verifica se os pontos estão dentro, na borda ou fora de subject
885 degree_p = 0.0
886 border = false
887 p_c = poly_clip[p_c_k]
888 p_s_b = poly_subject[0]
889 dist_b = p_c.distance(p_s_b)
890 dist_b = dist_b.round_to(4)
891 v_s_b = p_c.vector_to(p_s_b)
892 (1..poly_subject.size).each { |p_s|
893 p_s_a = p_s_b
894 dist_a = dist_b
895 v_s_a = v_s_b
896 if(p_s == poly_subject.size)
897 p_s_b = poly_subject[0]
898 else
899 p_s_b = poly_subject[p_s]
900 end
901 dist_b = p_c.distance(p_s_b)
902 dist_b = dist_b.round_to(4)
903 v_s_b = p_c.vector_to(p_s_b)
904 v_sum = v_s_a * v_s_b
905 if((v_sum.x.round_to(3) == 0)&&(v_sum.y.round_to(3) == 0)&&(v_sum.z.round_to(3) == 0))
906 dist_ab = p_s_a.distance(p_s_b)
907 dist_ab = dist_ab.round_to(4)
908 if((dist_a <= dist_ab)&&(dist_b <= dist_ab))
909 border = true
910 break
911 end
912 else
913 d_p = v_s_a.angle_between(v_s_b)
914 d_p *= -1 if(v_sum.z < 0)
915 degree_p += d_p
916 end
917 }
918 if(border == true)
919 count_p_clip_border += 1
920 clip_list[p_c_k].side = PolyListItem::INSIDE
921 else
922 degree_p = degree_p.abs.ceil_to(4)
923 if(degree_p == TWO_PI)
924 count_p_clip_inside += 1
925 clip_list[p_c_k].side = PolyListItem::INSIDE
926 end
927 end
928 }
929
930 if((count_p_clip_inside + count_p_clip_border) == poly_clip.size)
931 result = CLIP_INSIDE
932 elsif((count_p_sub_border == 2)&&(count_p_sub_inside == 0)&&
933 (count_p_clip_border == 2)&&(count_p_clip_inside == 0))
934 result = NOT_INTER
935 else
936
937 (1..poly_subject.size).each {|i|
938 index_sub_a = i - 1 # Index a do vetor ab de subject
939 p_subject_a = poly_subject[index_sub_a] # Ponto a do vetor ab de subject
940 index_sub_b = i # Index b do vetor ab de subject
941 index_sub_b = 0 if(i == poly_subject.size)
942 p_subject_b = poly_subject[index_sub_b] # Ponto b do vetor ab de subject
943 line_subject = [p_subject_a,p_subject_b] # Linha ab de subject
944 dist_line_subject = p_subject_a.distance(p_subject_b).round_to(4) # Módulo de ab
945 (1..poly_clip.size).each {|j|
946 index_clip_a = j - 1 # Index a do vetor ab de subject
947 p_clip_a = poly_clip[index_clip_a] # Ponto a do vetor ab de clip
948 index_clip_b = j # Index b do vetor ab de subject
949 index_clip_b = 0 if(j == poly_clip.size)
950 p_clip_b = poly_clip[index_clip_b] # Ponto b do vetor ab de clip
951 line_clip = [p_clip_a,p_clip_b] # Linha ab de clip
952 dist_line_clip = p_clip_a.distance(p_clip_b).round_to(4) # Módulo de ab
953 p_line_subject_line_clip = Geom.intersect_line_line(line_subject,line_clip) # Ponto de interseção entre as linhas de subject e clip
954 unless(p_line_subject_line_clip == nil)
955 dist_pa_subject_intersect = p_subject_a.distance(p_line_subject_line_clip).round_to(4)
956 dist_pb_subject_intersect = p_subject_b.distance(p_line_subject_line_clip).round_to(4)
957 dist_pa_clip_intersect = p_clip_a.distance(p_line_subject_line_clip).round_to(4)
958 dist_pb_clip_intersect = p_clip_b.distance(p_line_subject_line_clip).round_to(4)
959
960 if((dist_pa_subject_intersect <= dist_line_subject)&&(dist_pb_subject_intersect <= dist_line_subject)&& # Verifica se o ponto de interseção está contido entre os dois segmentos
961 (dist_pa_clip_intersect <=
dist_line_clip)&&(dist_pb_clip_intersect <= dist_line_clip))
962
963 index_sub_p = index_sub_a # Insere o ponto de interseção no segmento de Subject
964 dist_sub_next_p = subject_list[index_sub_p].dist_next_p
965 index_sub_next_p = subject_list[index_sub_p].next_p
966 while(dist_pa_subject_intersect > dist_sub_next_p)
967 index_sub_p = index_sub_next_p
968 dist_sub_next_p += subject_list[index_sub_p].dist_next_p
969 index_sub_next_p = subject_list[index_sub_p].next_p
970 end
971
972 index_clip_p = index_clip_a # Insere o ponto de interseção no segmento de Subject
973 dist_clip_next_p = clip_list[index_clip_p].dist_next_p
974 index_clip_next_p = clip_list[index_clip_p].next_p
975 while(dist_pa_clip_intersect > dist_clip_next_p)
976 index_clip_p = index_clip_next_p
977 dist_clip_next_p += clip_list[index_clip_p].dist_next_p
978 index_clip_next_p = clip_list[index_clip_p].next_p
979 end
980
981 if((dist_pa_subject_intersect > 0) && (dist_pb_subject_intersect > 0)&& # Sinter/Cinter
982 (dist_pa_clip_intersect > 0)&&(dist_pb_clip_intersect > 0))
983 subject_list[index_inter_sub] = PolyListItem.new(p_line_subject_line_clip,PolyListItem::INTER,index_sub_next_p,subject_list[index_sub_next_p].p)
984 subject_list[index_sub_p].set_next_p(index_inter_sub,p_line_subject_line_clip)
985 subject_list[index_inter_sub].link = index_inter_clip
986 clip_list[index_inter_clip] = PolyListItem.new(p_line_subject_line_clip,PolyListItem::INTER,index_clip_next_p,clip_list[index_clip_next_p].p)
987 clip_list[index_clip_p].set_next_p(index_inter_clip,p_line_subject_line_clip)
988 clip_list[index_inter_clip].link = index_inter_sub
989 index_inter_sub += 1
990 index_inter_clip += 1
991 count_p_intersection += 1
992 elsif((dist_pa_subject_intersect > 0) && (dist_pb_subject_intersect > 0)&& #Sinter/Cstart
993 (dist_pa_clip_intersect == 0))
994 subject_list[index_inter_sub] = PolyListItem.new(p_line_subject_line_clip,PolyListItem::INTER,index_sub_next_p,subject_list[index_sub_next_p].p)
995 subject_list[index_sub_p].set_next_p(index_inter_sub,p_line_subject_line_clip)
996 subject_list[index_inter_sub].link = index_clip_a
997 clip_list[index_clip_a].link = index_inter_subif(clip_list[index_clip_a].link == PolyListItem::NOT_LINK)
998 index_inter_sub += 1
999 count_p_intersection += 1
1000 elsif((dist_pa_subject_intersect > 0) && (dist_pb_subject_intersect > 0)&& #Sinter/Cend
1001 (dist_pb_clip_intersect == 0))
1002 subject_list[index_inter_sub] = PolyListItem.new(p_line_subject_line_clip,PolyListItem::INTER,index_sub_next_p,subject_list[index_sub_next_p].p)
1003 subject_list[index_sub_p].set_next_p(index_inter_sub,p_line_subject_line_clip)
1004 subject_list[index_inter_sub].link = index_clip_b
1005 clip_list[index_clip_b].link = index_inter_subif(clip_list[index_clip_b].link == PolyListItem::NOT_LINK)
1006 index_inter_sub += 1
1007 count_p_intersection += 1
1008 elsif((dist_pa_subject_intersect == 0)&&#Sstart/Cinter
1009 (dist_pa_clip_intersect > 0)&&(dist_pb_clip_intersect >0))
1010 clip_list[index_inter_clip] = PolyListItem.new(p_line_subject_line_clip,PolyListItem::INTER,index_clip_next_p,clip_list[index_clip_next_p].p)
1011 clip_list[index_clip_p].set_next_p(index_inter_clip,p_line_subject_line_clip)
1012 clip_list[index_inter_clip].link = index_sub_a
1013 subject_list[index_sub_a].link = index_inter_clip if(subject_list[index_sub_a].link == PolyListItem::NOT_LINK)
1014 index_inter_clip += 1
1015 count_p_intersection += 1
1016 elsif((dist_pa_subject_intersect == 0)&& #Sstart/Cstart
1017 (dist_pa_clip_intersect == 0))
1018 subject_list[index_sub_a].link = index_clip_a if (subject_list[index_sub_a].link == PolyListItem::NOT_LINK)
1019 clip_list[index_clip_a].link = index_sub_a if(clip_list[index_clip_a].link == PolyListItem::NOT_LINK)
1020 elsif((dist_pa_subject_intersect == 0)&& #Sstart/Cend
1021 (dist_pb_clip_intersect == 0))
1022 subject_list[index_sub_a].link = index_clip_b if(subject_list[index_sub_a].link == PolyListItem::NOT_LINK)
1023 clip_list[index_clip_b].link = index_sub_a if(clip_list[index_clip_b].link == PolyListItem::NOT_LINK)
1024 elsif((dist_pb_subject_intersect == 0)&& #Send/Cinter
1025 (dist_pa_clip_intersect > 0)&&(dist_pb_clip_intersect > 0))
1026 clip_list[index_inter_clip] = PolyListItem.new(p_line_subject_line_clip,PolyListItem::INTER,index_clip_next_p,clip_list[index_clip_next_p].p)
1027 clip_list[index_clip_p].set_next_p(index_inter_clip,p_line_subject_line_clip)
1028 clip_list[index_inter_clip].link = index_sub_b
1029 subject_list[index_sub_b].link = index_inter_clip if(subject_list[index_sub_b].link == PolyListItem::NOT_LINK)
1030 index_inter_clip += 1
1031 count_p_intersection += 1
1032 elsif((dist_pb_subject_intersect == 0)&& #Send/Cstart
1033 (dist_pa_clip_intersect == 0))
1034 subject_list[index_sub_b].link = index_clip_a if(subject_list[index_sub_b].link == PolyListItem::NOT_LINK)
1035 clip_list[index_clip_a].link = index_sub_b if(clip_list[index_clip_a].link == PolyListItem::NOT_LINK)
1036 elsif((dist_pb_subject_intersect == 0)&& #Send/Cend
1037 (dist_pb_clip_intersect == 0))
1038 subject_list[index_sub_b].link = index_clip_b if(subject_list[index_sub_b].link == PolyListItem::NOT_LINK)
1039 clip_list[index_clip_b].link = index_sub_b if(clip_list[index_clip_b].link == PolyListItem::NOT_LINK)
1040 end
1041 end
1042 end
1043 }
1044 }
1045 if(count_p_intersection > 0)
1046 result = SUB_CLIP_CROSS
1047 inter_dir = 0.0
1048 next_s = 0
1049 begin
1050 s = subject_list[next_s]
1051 next_s = s.next_p
1052 if(s.type == PolyListItem::CORNER)
1053 if(s.side == PolyListItem::OUTSIDE)
1054 s.dir = PolyListItem::OUTPUT
1055 inter_dir = 0.0
1056 elsif((s.side == PolyListItem::INSIDE)&&(s.link == PolyListItem::NOT_LINK))
1057 s.dir = PolyListItem::INPUT
1058 inter_dir = 1.0
1059 elsif((s.side == PolyListItem::INSIDE)&&(s.link != PolyListItem::NOT_LINK))
1060 if(subject_list[s.next_p].type == PolyListItem::INTER)
1061 s.dir = PolyListItem::INPUT
1062 clip_list[s.link].dir = PolyListItem::INPUT
1063 inter_dir = 1.0
1064 else
1065 if(subject_list[s.next_p].side == PolyListItem::OUTSIDE)
1066 s.dir = PolyListItem::OUTPUT
1067 clip_list[s.link].dir = PolyListItem::OUTPUT
1068 inter_dir = 0.0
1069 else
1070 s.dir = PolyListItem::INPUT
1071 clip_list[s.link].dir = PolyListItem::INPUT
1072 inter_dir = 1.0
1073 end
1074 end
1075 end
1076 else
1077 dir_result = inter_dir % 2.0
1078 if(dir_result > 0)
1079 s.dir = PolyListItem::OUTPUT
1080 clip_list[s.link].dir = PolyListItem::OUTPUT
1081 else
1082 s.dir = PolyListItem::INPUT
1083 clip_list[s.link].dir = PolyListItem::INPUT
1084 end
1085 inter_dir += 1.0
1086 end
1087 end while(next_s != 0)
1088 end
1089 end
1090 end
1091 inter_elements[0] = result
1092 inter_elements[1] = clip_list
1093 inter_elements[2] = subject_list
1094 inter_elements
1095 end
1096
1097 def clip_polygon(clip,subject)
1098 poly_shad = Array.new()
1099 shades = Array.new()
1100 in_subject = true
1101 begin_cycle = false
1102 inside = false
1103 inserted = false
1104 index_p = 0
1105 end_p = 0
1106 run = true
1107 p = subject[index_p]
1108 begin
1109 if(p.visited == false)
1110 if(in_subject == true)
1111 if(inside == false)
1112 if((p.dir == PolyListItem::INPUT)&&(begin_cycle == true))
1113 poly_shad.push(p.p)
1114 subject[index_p].visited = true
1115 clip[p.link].visited = true if(p.link != PolyListItem::NOT_LINK)
1116 inside = true
1117 end_p = index_p if(end_p == 0)
1118 elsif(p.dir == PolyListItem::OUTPUT)
1119 begin_cycle = true
1120 end
1121 index_p = p.next_p
1122 p = subject[index_p]
1123 else
1124 inserted = false
1125 poly_shad.push(p.p)
1126 subject[index_p].visited = true
1127 if(p.dir == PolyListItem::INPUT)
1128 index_p = p.next_p
1129 p = subject[index_p]
1130 else
1131 clip[p.link].visited = true if(p.link != PolyListItem::NOT_LINK)
1132 p = clip[p.link]
1133 index_p = p.next_p
1134 p = clip[index_p]
1135 in_subject = false
1136 end
1137 end
1138 else
1139 poly_shad.push(p.p)
1140 if(p.dir == PolyListItem::FORWARD)
1141 index_p = p.next_p
1142 p = clip[index_p]
1143 else
1144 clip[index_p].visited = true
1145 subject[p.link].visited = true
1146 p = subject[p.link]
1147 index_p = p.next_p
1148 p = subject[index_p]
1149 in_subject = true
1150 end
1151 end
1152 elsif((p.visited == true)&&(inserted == false))
1153 shades.push(poly_shad.clone()) if(poly_shad.size > 2)
1154 poly_shad.clear()
1155 if(in_subject == false)
1156 p = subject[p.link]
1157 in_subject = true
1158 end
1159 index_p = p.next_p
1160 p = subject[index_p]
1161 begin_cycle = false
1162 inserted = true
1163 inside = false
1164 elsif((p.visited == true)&&(inserted == true))
1165 index_p = p.next_p
1166 p = subject[index_p]
1167 end
1168 if((index_p == end_p)&&(inside == false))
1169 run = false
1170 end
1171 end while(run == true)
1172 shades
1173 end
1174
1175 def subtract_polygon(clip,subject)
1176 poly_shad = Array.new()
1177 shades = Array.new()
1178 in_subject = true
1179 begin_cycle = false
1180 inside = false
1181 inserted = false
1182 index_p = 0
1183 end_p = 0
1184 run = true
1185 p = subject[index_p]
1186 begin
1187 if(p.visited == false)
1188 if(in_subject == true)
1189 if(inside == false)
1190 if((p.dir == PolyListItem::OUTPUT)&&(begin_cycle == true))
1191 poly_shad.push(p.p)
1192 subject[index_p].visited = true
1193 clip[p.link].visited = true if(p.link != PolyListItem::NOT_LINK)
1194 inside = true
1195 end_p = index_p if(end_p == 0)
1196 elsif(p.dir == PolyListItem::INPUT)
1197 begin_cycle = true
1198 end
1199 index_p = p.next_p
1200 p = subject[index_p]
1201 else
1202 inserted = false
1203 poly_shad.push(p.p)
1204 subject[index_p].visited = true
1205 if(p.dir == PolyListItem::OUTPUT)
1206 index_p = p.next_p
1207 p = subject[index_p]
1208 else
1209 clip[p.link].visited = true if(p.link != PolyListItem::NOT_LINK)
1210 p = clip[p.link]
1211 index_p = p.next_p
1212 p = clip[index_p]
1213 in_subject = false
1214 end
1215 end
1216 else
1217 poly_shad.push(p.p)
1218 if(p.dir == PolyListItem::FORWARD)
1219 index_p = p.next_p
1220 p = clip[index_p]
1221 else
1222 clip[index_p].visited = true
1223 subject[p.link].visited = true
1224 p = subject[p.link]
1225 index_p = p.next_p
1226 p = subject[index_p]
1227 in_subject = true
1228 end
1229 end
1230 elsif((p.visited == true)&&(inserted == false))
1231 shades.push(poly_shad.clone()) if(poly_shad.size > 2)
1232 poly_shad.clear()
1233 if(in_subject == false)
1234 p = subject[p.link]
1235 in_subject = true
1236 end
1237 index_p = p.next_p
1238 p = subject[index_p]
1239 begin_cycle = false
1240 inserted = true
1241 inside = false
1242 elsif((p.visited == true)&&(inserted == true))
1243 index_p = p.next_p
1244 p = subject[index_p]
1245 end
1246 if((index_p == end_p)&&(inside == false))
1247 run = false
1248 end
1249 end while(run == true)
1250 shades
1251 end
1252
1253 def create_poly_list(poly)
1254 poly_list = Array.new()
1255 (0..(poly.size - 1)).each {|h|
1256 if(h == (poly.size - 1))
1257 next_p = 0
1258 else
1259 next_p = h + 1
1260 end
1261 poly_list[h] = PolyListItem.new(poly[h],PolyListItem::CORNER,next_p,poly[next_p])
1262 }
1263 poly_list
1264 end
1265
1266 def prepare_face(vertices)
1267 poly_face = Array.new()
1268 v_p_face_p_n = Geom::Vector3d.new()
1269 (0..(vertices.size - 1)).each{ |v|
1270 p_vert_face = vertices[v]
1271 if(v == 0)
1272 p_vert_face_p = vertices[vertices.size - 1]
1273 else
1274 p_vert_face_p = vertices[v - 1]
1275 end
1276 if(v == (vertices.size - 1))
1277 p_vert_face_n = vertices[0]
1278 else
1279 p_vert_face_n = vertices[v + 1]
1280 end
1281 v_p_face_p = p_vert_face_p.vector_to(p_vert_face)
1282 v_p_face_n = p_vert_face.vector_to(p_vert_face_n)
1283 v_p_face_p_n = v_p_face_p * v_p_face_n
1284 poly_face.push(p_vert_face) unless((v_p_face_p_n.x.round_to(3) == 0)&&(v_p_face_p_n.y.round_to(3) == 0)&&(v_p_face_p_n.z.round_to(3) == 0)) # Se o
ponto entiver entre dois outros pontos com a mesma direção, ele não é adicionado.
1285 }
1286 poly_face.reverse! if(v_p_face_p_n.z < 0) # Se estiver ordenado no sentido horário, inverte poly_face
1287 poly_face
1288 end
1289
1290 def get_face_shad(az_rad,el_rad)
1291 f_shad_beam = 0.0
1292 az = az_rad.radians()
1293 el = el_rad.radians()
1294 if(el < 0.0)
1295 f_shad_beam = 1.0
1296 elsif(el <= @max_el)
1297 az = az / @pass_az
1298 az0 = az.floor
1299 az1 = az.ceil
1300 el = el / @pass_el
1301 el0 = el.floor
1302 el1 = el.ceil
1303 el_at_1 = @fs.at(az0)
1304 el_at_2 = @fs.at(az1)
1305 fb11 = el_at_1.at(el0)
1306 fb12 = el_at_1.at(el1)
1307 fb21 = el_at_2.at(el0)
1308 fb22 = el_at_2.at(el1)
1309 f_shad_beam = ((fb11*((az - az1)*(el - el1)))/((az0 - az1)*(el0 - el1)))
1310 f_shad_beam += ((fb21*((az - az0)*(el - el1)))/((az1 - az0)*(el0 - el1)))
1311 f_shad_beam += ((fb12*((az - az1)*(el - el0)))/((az0 - az1)*(el1 - el0)))
1312 f_shad_beam += ((fb22*((az - az0)*(el - el0)))/((az1 - az0)*(el1 - el0)))
1313 end
1314 f_shad_beam = 0.0 if(f_shad_beam < 0.0)
1315 f_shad_beam = 1.0 if(f_shad_beam > 1.0)
1316 f_shad_beam
1317 end
1318
1319 end
1320
1321 class PolyListItem
1322 INSIDE = 0
1323 OUTSIDE = 1
1324 CORNER = 0
1325 INTER = 1
1326 NOT_LINK = 1000
1327 INPUT = 0
1328 OUTPUT = 1
1329 FORWARD = 2
1330
1331 attr_accessor :p
1332 attr_accessor :type
1333 attr_accessor :side
1334 attr_accessor :link
1335 attr_accessor :dir
1336 attr_accessor :next_p
1337 attr_accessor :dist_next_p
1338 attr_accessor :visited
1339
1340 def initialize(p,type,next_p,next_p_p)
1341 @p = p
1342 @type = type
1343 @side = OUTSIDE
1344 @link = NOT_LINK
1345 @dir = FORWARD
1346 @next_p = next_p
1347 @dist_next_p = p.distance(next_p_p).round_to(4)
1348 @visited = false
1349 end
1350
1351 def set_next_p(new_next_p,new_next_p_p)
1352 @next_p = new_next_p
1353 @dist_next_p = @p.distance(new_next_p_p).round_to(4)
1354 end
1355 end
1356
1357 class Site
1358
1359 def initialize()
1360 @@latitude ||= -23.556936
1361 @@longitude ||= -46.730765
1362 @@lat_rad = @@latitude.degrees()
1363 @@long_rad = @@longitude.degrees()
1364 @@time ||= Time.now()
1365 @@n_days ||= 365
1366 @@timezone ||= -3
1367 @@save_time ||= false
1368 @@albedo ||= 0.1
1369 @@h = [5.42, 5.17, 4.84, 4.31, 3.58, 3.33, 3.49, 4.03, 4.21, 4.88, 5.56,
5.47]
1370 @@irrad ||= IO.readlines(Sketchup.find_support_file('irrad.csv', 'Plugins/Solar3DBR'))
1371 end
1372
1373 def self.set_latlong(lat,long)
1374 @@latitude = lat
1375 @@longitude = long
1376 @@lat_rad = @@latitude.degrees()
1377 @@long_rad = @@longitude.degrees()
1378 end
1379
1380 def self.get_lat()
1381 @@latitude
1382 end
1383
1384 def self.get_lat_rad()
1385 @@lat_rad
1386 end
1387
1388 def self.get_long()
1389 @@longitude
1390 end
1391
1392 def self.get_long_rad()
1393 @@long_rad
1394 end
1395
1396 def self.set_datetime(datetime)
1397 @@time = datetime
1398 @@n_days = Time.utc(@@time.year,12,31).yday
1399 @@hour_utc = @@time.hour - @@timezone
1400 @@time_dec = @@time.hour + (@@time.min/60.0)
1401 @@time_dec -= 1.0 if(@@save_time == true)
1402 @@utc_time_dec = @@hour_utc + (@@time.min/60.0)
1403 @@utc_time_dec -= 1.0 if(@@save_time == true)
1404 end
1405
1406 def self.set_timezone(timezone)
1407 @@timezone = timezone
1408 end
1409
1410 def self.get_datetime()
1411 @@time
1412 end
1413
1414 def self.get_year()
1415 @@time.year
1416 end
1417
1418 def self.get_month()
1419 @@time.month
1420 end
1421
1422 def self.get_day()
1423 @@time.day
1424 end
1425
1426 def self.get_day_of_year()
1427 @@time.yday
1428 end
1429
1430 def self.leap_year?()
1431 if(@@n_days == 366)
1432 true
1433 else
1434 false
1435 end
1436 end
1437
1438 def self.get_hour()
1439 @@time.hour
1440 end
1441
1442 def self.get_utc_hour()
1443 @@hour_utc
1444 end
1445
1446 def self.get_minute()
1447 @@time.min
1448 end
1449
1450 def self.get_timezone()
1451 @@timezone
1452 end
1453
1454 def self.get_time_dec()
1455 @@time_dec
1456 end
1457
1458 def self.get_utc_time_dec()
1459 @@utc_time_dec
1460 end
1461
1462 def self.set_save_time(save)
1463 @@save_time = save
1464 end
1465
1466 def self.set_h(h)
1467 @@h = h
1468 end
1469
1470 def self.get_h()
1471 @@h
1472 end
1473
1474 def self.set_albedo(albedo)
1475 @@albedo = albedo
1476 end
1477
1478 def self.get_albedo()
1479 @@albedo
1480 end
1481
1482 def self.set_irrad()
1483 @@irrad = IO.readlines(Sketchup.find_support_file('irrad.csv', 'Plugins/Solar3DBR'))
1484 end
1485
1486 def self.get_irrad()
1487 search = @@time.strftime("%d/%m/[0-9]{2} %H:00")
1488 result = @@irrad.select{ |i| i.match(search) }
1489 if(result.size > 0)
1490 irrad_s = result[0].split(';')
1491 else
1492 irrad_s = ["0","0","0"]
1493 end
1494 irrad = Array.new(2)
1495 irrad[0] = irrad_s[1].to_f() * 3600.0
1496 irrad[1] = irrad_s[2].to_f() * 3600.0
1497 irrad
1498 end
1499
1500 end
1501
1502 class SunPosition
1503
1504 AU = 149597890000.0 # Unidade Astronômica em metros
1505 GS = 1367.0
1506 TWO_PI = 2.0*Math::PI
1507 HALF_PI = Math::PI/2.0
1508
1509 attr_accessor :declination
1510 attr_accessor :cos_dec
1511 attr_accessor :sin_dec
1512 attr_accessor :w
1513 attr_accessor :w1
1514 attr_accessor :w2
1515 attr_accessor :w_sunset
1516 attr_accessor :solar_time
1517 attr_accessor :sunrise_time
1518 attr_accessor :sunset_time
1519 attr_accessor :air_mass
1520 attr_accessor :zenith
1521 attr_accessor :cos_zenith
1522 attr_accessor :elevation
1523 attr_accessor :azimuth
1524 attr_accessor :sun_vector_normal
1525 attr_accessor :sun_vector
1526 attr_accessor :g_etr
1527 attr_accessor :g_etr_h
1528
1529 def initialize()
1530 set_julian_day()
1531 set_mean_long()
1532 set_mean_anomaly()
1533 set_ecliptc_long()
1534 set_obliq_ecliptc()
1535 set_right_ascension()
1536 set_gmst()
1537 set_lmst()
1538 set_hour_angle()
1539 set_sun_earth_dist()
1540 set_declination()
1541 set_zenith()
1542 set_elevation()
1543 set_azimuth()
1544 set_sunset_hour_angle()
1545 set_solar_time()
1546 set_sunrise_sunset_hour()
1547 set_zenith_elevation_corrected()
1548 set_sun_vector()
1549 set_irrad_etr()
1550 set_irrad_etr_h()
1551 set_air_mass()
1552 end
1553
1554 def set_julian_day()
1555 year = Site.get_year()
1556 day_year = Site.get_day_of_year()
1557 hour = Site.get_utc_time_dec()
1558 delta = year - 1949
1559 leap = (delta/4).to_int()
1560 julian_day = 32916.5 + (delta * 365.0) + leap + day_year + (hour/24.0)
1561 @n = julian_day - 51545.0
1562 @day_angle = 360.0 * ((day_year - 1) / 365.0)
1563 end
1564
1565 def set_mean_long() # L - mean longitude - 0 <= L <= 360°
1566 @mnlong = 280.460 + (0.9856474*@n)
1567 @mnlong %= 360.0
1568 @mnlong += 360.0 if(@mnlong < 0.0)
1569 end
1570
1571 def set_mean_anomaly() # g - mean anomaly - 0 <= g <= 2PI
1572 @mnanom = 357.528 + (0.9856003 * @n)
1573 @mnanom %= 360.0
1574 @mnanom += 360.0 if(@mnanom < 0.0)
1575 @mnanom = @mnanom.degrees()
1576 end
1577
1578 def set_ecliptc_long() # l - ecliptic longitude - 0 <= l <= 2PI
1579 @eclong = @mnlong + (1.915 * Math.sin(@mnanom)) + (0.02 * Math.sin(2*@mnanom))
1580 @eclong %= 360.0
1581 @eclong += 360.0 if(@eclong < 0.0)
1582 @eclong = @eclong.degrees()
1583 end
1584
1585 def set_obliq_ecliptc() # ep - obliquity of the ecliptc - 0 <= ep <= 2PI
1586 @oblqec = 23.439 - (0.0000004 * @n)
1587 @oblqec = @oblqec.degrees()
1588 end
1589
1590 def set_right_ascension() # 0 <= ra <= 2PI
1591 num = Math.cos(@oblqec) * Math.sin(@eclong)
1592 den = Math.cos(@eclong)
1593 if(den == 0.0)
1594 @ra = HALF_PI
1595 else
1596 @ra = Math.atan(num/den)
1597 end
1598 @ra += Math::PI if(den < 0.0)
1599 @ra += TWO_PI if(num < 0.0)
1600 end
1601
1602 def set_gmst() # Greenwich Mean Sideral Time em Horas
1603 @gmst = 6.697375 + (0.0657098242 * @n) + Site.get_utc_time_dec()
1604 @gmst %= 24.0
1605 @gmst += 24.0 if(@gmst < 0)
1606 end
1607
1608 def set_lmst() # Local Mean Sideral Time em Radianos
1609 @lmst = (@gmst * 15.0) + Site.get_long()
1610 @lmst %= 360.0
1611 @lmst += 360.0 if(@lmst < 0.0)
1612 @lmst = @lmst.degrees()
1613 end
1614
1615 def set_hour_angle() # -PI <= w <= PI
1616 @w = @lmst - @ra
1617 if(@w < (-Math::PI)) then
1618 @w += TWO_PI
1619 elsif (@w > Math::PI)
1620 @w -= TWO_PI
1621 end
1622 d = (7.5).degrees()
1623 @w1 = @w - d
1624 @w2 = @w + d
1625 end
1626
1627 def set_sun_earth_dist()
1628 day_angle_x_2 = 2.0 * @day_angle
1629 @erc = 1.000110 + (0.034221 * Math.cos(@day_angle)) + (0.001280 * Math.sin(@day_angle)) +
1630 (0.000719 * Math.cos(day_angle_x_2)) + (0.000077 * Math.sin(day_angle_x_2))
1631 @sun_earth_dist = AU * @erc
1632 end
1633
1634 def set_declination() # Declinação em radianos
1635 @declination = Math.asin(Math.sin(@oblqec) * Math.sin(@eclong))
1636 @cos_dec = Math.cos(@declination)
1637 @sin_dec = Math.sin(@declination)
1638 end
1639
1640 def set_zenith()
1641 cz = (@sin_dec * Math.sin(Site.get_lat_rad())) +
1642 (@cos_dec * Math.cos(Site.get_lat_rad()) * Math.cos(@w))
1643 if(cz.abs > 1.0)
1644 if(cz >= 0.0)
1645 cz = 1.0
1646 else
1647 cz = -1.0
1648 end
1649 end
1650 @zenith = Math.acos(cz)
1651 @zenith = 99.degrees() if(@zenith > 99.degrees())
1652 end
1653
1654 def set_elevation() # Calcula a elevação em radianos
1655 @elevation = HALF_PI - @zenith
1656 end
1657
1658 def set_azimuth() # Calcula o azimute em radianos 0 <= azimuth <= 2PI
1659 ce = Math.cos(@elevation)
1660 se = Math.sin(@elevation)
1661 @azimuth = 180.0
1662 cecl = ce * Math.cos(Site.get_lat_rad())
1663 if(cecl.abs >= 0.001)
1664 ca = (se * Math.sin(Site.get_lat_rad()) - @sin_dec) / cecl
1665 if(ca > 1.0) then
1666 ca = 1.0
1667 elsif(ca < -1.0)
1668 ca = -1.0
1669 end
1670 @azimuth = Math::PI - Math.acos(ca)
1671 if(@w > 0)
1672 @azimuth = TWO_PI - @azimuth
1673 end
1674 end
1675 end
1676
1677 def set_sun_vector()
1678 cosel = Math.cos(@elevation)
1679 x = cosel * Math.sin(@azimuth)
1680 y = cosel * Math.cos(@azimuth)
1681 z = Math.sin(@elevation)
1682 @sun_vector_normal = Geom::Vector3d.new(x,y,z)
1683 x *= @sun_earth_dist
1684 y *= @sun_earth_dist
1685 z *= @sun_earth_dist
1686 @sun_vector = Geom::Vector3d.new(x,y,z)
1687 end
1688
1689 def set_sunset_hour_angle() # Sunset hour angle
1690 cssha = 0
1691 cdcl = @cos_dec * Math.cos(Site.get_lat_rad())
1692 if(cdcl.abs >= 0.001) then
1693 cssha = -Math.sin(Site.get_lat_rad()) * (@sin_dec/cdcl)
1694 if(cssha < -1.0) then
1695 @w_sunset = Math::PI
1696 elsif(cssha > 1.0)
1697 @w_sunset = 0.0
1698 else
1699 @w_sunset = Math.acos(cssha)
1700 end
1701 elsif(((@declination >= 0.0)&&(Site.get_lat() > 0.0))||
1702 ((@declination < 0.0)&&(Site.get_lat() < 0.0)))
1703 @w_sunset = Math::PI
1704 else
1705 @w_sunset = 0.0
1706 end
1707 end
1708
1709 def set_solar_time()
1710 @solar_time = (180.0 + @w.radians()) * 4.0
1711 @solar_time_fix = @solar_time - (Site.get_hour() * 60) - Site.get_minute()
1712 while(@solar_time_fix > 720.0)
1713 @solar_time_fix -= 1440.0
1714 end
1715 while(@solar_time_fix < -720.0)
1716 @solar_time_fix += 1440.0
1717 end
1718 @equation_of_time = @solar_time_fix + (60.0 * Site.get_timezone()) - (4.0 * Site.get_long())
1719 end
1720
1721 def set_sunrise_sunset_hour()
1722 sunset_w = @w_sunset.radians()
1723 if(sunset_w <= 1.0) then
1724 @sunrise_time = 2999.0
1725 @sunset_time = -2999.0
1726 elsif(sunset_w >= 179.0)
1727 @sunrise_time = -2999.0
1728 @sunset_time = 2999.0
1729 else
1730 x = (4.0 * sunset_w) - @solar_time_fix
1731 @sunrise_time = 720 - x
1732 @sunset_time = 720 + x
1733 end
1734 @sunrise_time /= 60.0
1735 @sunset_time /= 60.0
1736 end
1737
1738 def set_zenith_elevation_corrected()
1739 prestemp = 0.0
1740 refcor = 0.0
1741 tanelev = 0.0
1742 el = @elevation.radians()
1743 if(el < 85.0)
1744 tanelev = Math.tan(@elevation)
1745 if(el >= 5.0) then
1746 refcor = (58.1/tanelev) - (0.07/(tanelev**3)) + (0.000086/(tanelev**5))
1747 elsif(el >= -0.575)
1748 refcor = 1735.0 + el * (-518.2 + el * (103.4 + el * (-12.79 + el * 0.711 )));
1749 else
1750 refcor = -20.774/tanelev
1751 end
1752 prestemp = (1013.0 * 283.0)/(1013.0 * (273.0 + 15.0));
1753 refcor *= prestemp/3600.0;
1754 end
1755 el += refcor
1756 el = -9.0 if(el < -9.0)
1757 @elevation = el.degrees()
1758 @zenith = HALF_PI - @elevation
1759 @cos_zenith = Math.cos(@zenith)
1760 end
1761
1762 def set_irrad_etr()
1763 @g_etr = GS * @erc
1764 end
1765
1766 def set_irrad_etr_h()
1767 @g_etr_h = @g_etr * @cos_zenith
1768 end
1769
1770 def set_air_mass()
1771 if(@zenith.radians() > 93.0)
1772 @air_mass = -1.0
1773 else
1774 @air_mass = 1.0/@cos_zenith + 0.50572 * ((96.07995 - @zenith.radians())**-1.6364)
1775 end
1776 end
1777
1778 def get_incidence_angle(v_normal)
1779 sun_inc_angle = @sun_vector.angle_between(v_normal)
1780 sun_inc_angle
1781 end
1782
1783 end
1784
1785 class Survey
1786
1787 FACE = 0
1788 MAX_Z = 1
1789
1790 attr_accessor :faces
1791
1792 def initialize
1793 @faces = Array.new()
1794 model = Sketchup.active_model
1795 ent = model.entities
1796 for face in ent
1797 if((face.kind_of?(Sketchup::Face)&&(face.layer.name != "Transparente")))
1798 for vertice in face.vertices
1799 z ||= vertice.position.z
1800 z = vertice.position.z if(vertice.position.z > z)
1801 end
1802 f = Array.new(2)
1803 f[FACE] = face
1804 f[MAX_Z] = z.round_to(3)
1805 @faces.push(f)
1806 end
1807 end
1808 end
1809
1810 end
1811
1812 class ExtraIrrad
1813
1814 attr_accessor :i0
1815 attr_accessor :i0n
1816 attr_accessor :h0
1817
1818 def initialize(sun)
1819 @sun = sun
1820 end
1821
1822 def set_i0() # Determina o valor de I0 (Irradiação Horária Extraterrestre) em J.
1823 @cos_w2 = Math.cos(@sun.w2)
1824 @cos_w1 = Math.cos(@sun.w1)
1825 @sin_w2 = Math.sin(@sun.w2)
1826 @sin_w1 = Math.sin(@sun.w1)
1827 @cos_lat = Math.cos(Site.get_lat_rad)
1828 @sin_lat = Math.sin(Site.get_lat_rad)
1829 @i0 = ((12.0 * 3600.0)/Math::PI) * @sun.g_etr *
1830 ((@cos_lat * @sun.cos_dec * (@sin_w2 - @sin_w1)) +
1831 ((@sun.w2 - @sun.w1) * @sin_lat * @sun.sin_dec))
1832 @i0n = @i0 / @sun.cos_zenith
1833 end
1834
1835 def set_h0() # Determina o valor de H0 (Irradiação Diária Extraterrestre) em J.
1836 @sin_ws = Math.sin(@sun.w_sunset)
1837 @cos_lat = Math.cos(Site.get_lat_rad)
1838 @sin_lat = Math.sin(Site.get_lat_rad)
1839 @h0 = ((24.0 * 3600.0)/Math::PI) * @sun.g_etr *
1840 ((@cos_lat * @sun.cos_dec * @sin_ws) +
1841 (@sun.w_sunset * @sin_lat * @sun.sin_dec))
1842 end
1843
1844 end
1845
1846 class Irrad < ExtraIrrad
1847
1848 COS_85 = 0.087155
1849 K = 0.000005535
1850 F = [[-0.008,0.588,-0.062,-0.060,0.072,-0.022],
1851 [0.130,0.683,-0.151,-0.019,0.066,-0.029],
1852 [0.330,0.487,-0.221,0.055,-0.064,-0.026],
1853 [0.568,0.187,-0.295,0.109,-0.152,0.014],
1854 [0.873,-0.392,-0.362,0.226,-0.462,0.001],
1855 [1.132,-1.237,-0.412,0.288,-0.823,0.056],
1856 [1.060,-1.600,-0.359,0.264,-1.127,0.131],
1857 [0.678,-0.327,-0.250,0.156,-1.377,0.251]]
1858
1859 attr_accessor :ih
1860 attr_accessor :ih_b
1861 attr_accessor :ih_d
1862 attr_accessor :i_t
1863 attr_accessor :i_b
1864 attr_accessor :i_d
1865 attr_accessor :i_d_iso
1866 attr_accessor :i_d_circ
1867 attr_accessor :i_d_hor
1868 attr_accessor :i_ref
1869
1870 def initialize(sun,face,beta,azimuth,ih,ih_d = 0)
1871 super(sun)
1872 @sun = sun
1873 @face = face
1874 @beta = beta
1875 @azi = azimuth - Math::PI
1876 @incidence = @sun.get_incidence_angle(@face.normal)
1877 @ih = ih
1878 @ih_d = ih_d
1879 @ih_b = @ih - @ih_d
1880 set_i0()
1881 set_face_parameters()
1882 set_i_b()
1883 set_i_d_iso()
1884 set_i_d_circ()
1885 set_i_d_hor()
1886 set_i_d()
1887 set_i_ref()
1888 set_i_t()
1889 end
1890
1891 def set_face_parameters()
1892 @cos_beta = Math.cos(@beta)
1893 @cos_incidence = Math.cos(@incidence)
1894 @cos_zen = @sun.cos_zenith
1895 @cos_azi = Math.cos(@azi)
1896 @sin_beta = Math.sin(@beta)
1897 @sin_azi = Math.sin(@azi)
1898
1899 @a = @cos_incidence
1900 @a = 0 if (@a < 0.0)
1901 @b = @cos_zen
1902 @b = COS_85 if (@b < COS_85)
1903 if(@cos_incidence >= 0.0)
1904 a_rb = ((@sun.sin_dec * @sin_lat * @cos_beta - @sun.sin_dec * @cos_lat * @sin_beta * @cos_azi) * (@sun.w2 - @sun.w1)) +
1905 ((@sun.cos_dec * @cos_lat * @cos_beta + @sun.cos_dec * @sin_lat * @sin_beta * @cos_azi) * (@sin_w2 - @sin_w1)) -
1906 ((@sun.cos_dec * @sin_beta * @sin_azi) * (@cos_w2 - @cos_w1))
1907 b_rb = ((@cos_lat * @sun.cos_dec) * (@sin_w2 - @sin_w1)) + ((@sin_lat * @sun.sin_dec) * (@sun.w2 - @sun.w1))
1908 @rb = a_rb / b_rb
1909 else
1910 @rb = 0.0
1911 end
1912 @i_bn = @ih_b / @cos_zen
1913 @e = (((@ih_d + @i_bn)/@ih_d) + (K * (@sun.zenith.radians**3))) / (1 +(K * (@sun.zenith.radians**3)))
1914 @e = @e
1915 @delta = @sun.air_mass * (@ih_d/@i0n)
1916 @t = 0
1917 if((@e >= 1.000) && (@e < 1.065)) then
1918 @t = 0
1919 elsif((@e >= 1.065) && (@e < 1.230))
1920 @t = 1
1921 elsif((@e >= 1.230) && (@e < 1.500))
1922 @t = 2
1923 elsif((@e >= 1.500) && (@e < 1.950))
1924 @t = 3
1925 elsif((@e >= 1.950) && (@e < 2.800))
1926 @t = 4
1927 elsif((@e >= 2.800) && (@e < 4.500))
1928 @t = 5
1929 elsif((@e >= 4.500) && (@e < 6.200))
1930 @t = 6
1931 elsif(@e >= 6.200)
1932 @t = 7
1933 end
1934 @f1 = F[@t][0] + (F[@t][1] * @delta) + (@sun.zenith * F[@t][2])
1935 @f1 = 0 if(@f1 < 0)
1936 @f2 = F[@t][3] + (F[@t][4] * @delta) + (@sun.zenith * F[@t][5])
1937 end
1938
1939 def set_i_b()
1940 @i_b = @ih_b * @rb
1941 @i_b = 0.0 if(@i_b < 0.0)
1942 end
1943
1944 def set_i_d_iso()
1945 @i_d_iso = @ih_d * (1.0 - @f1) * ((1 + @cos_beta) / 2.0)
1946 @i_d_iso = 0.0 if(@i_d_iso < 0.0)
1947 end
1948
1949 def set_i_d_circ()
1950 @i_d_circ = @ih_d * @f1 * (@a/@b)
1951 @i_d_circ = 0.0 if(@i_d_circ < 0.0)
1952 end
1953
1954 def set_i_d_hor()
1955 @i_d_hor = @ih_d * @f2 * @sin_beta
1956 @i_d_hor = 0.0 if(@i_d_hor < 0.0)
1957 end
1958
1959 def set_i_d()
1960 @i_d = @i_d_iso + @i_d_circ + @i_d_hor
1961 end
1962
1963 def set_i_ref()
1964 @i_ref = @ih * Site.get_albedo() * ((1.0 - @cos_beta) / 2.0)
1965 @i_ref = 0.0 if(@i_ref < 0.0)
1966 end
1967
1968 def set_i_t()
1969 @i_t = @i_b + @i_d + @i_ref
1970 end
1971
1972 end
1973
1974 class SyntheticIrrad < ExtraIrrad
1975
1976 KWH = 0.0000002778
1977 WH = 0.0002778
1978 PI_24 = -0.2617
1979
1980 MEAN_DAY = [17,16,16,15,15,11,17,16,15,15,14,10]
1981
1982 MTM_KT = [[[0.229, 0.333, 0.208, 0.042, 0.083, 0.042, 0.042, 0.021, 0.000, 0.000],
1983 [0.167, 0.319, 0.194, 0.139, 0.097, 0.028, 0.042, 0.000, 0.014, 0.000],
1984 [0.250, 0.250, 0.091, 0.136, 0.091, 0.046, 0.046, 0.023, 0.068, 0.000],
1985 [0.158, 0.237, 0.158, 0.263, 0.026, 0.053, 0.079, 0.026, 0.000, 0.000],
1986 [0.211, 0.053, 0.211, 0.158, 0.053, 0.053, 0.158, 0.105, 0.000, 0.000],
1987 [0.125, 0.125, 0.250, 0.188, 0.063, 0.125, 0.000, 0.125, 0.000, 0.000],
1988 [0.040, 0.240, 0.080, 0.120, 0.080, 0.080, 0.120, 0.120, 0.080, 0.040],
1989 [0.000, 0.250, 0.000, 0.125, 0.000, 0.125, 0.125, 0.250, 0.063, 0.063],
1990 [0.000, 0.250, 0.000, 0.125, 0.250, 0.000, 0.250, 0.000, 0.000, 0.125],
1991 [0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.500, 0.250, 0.000, 0.250]],
1992 [[0.000, 0.000, 0.091, 0.000, 0.364, 0.091, 0.182, 0.000, 0.273, 0.000],
1993 [0.118, 0.118, 0.176, 0.118, 0.059, 0.118, 0.176, 0.059, 0.059, 0.000],
1994 [0.067, 0.267, 0.067, 0.200, 0.067, 0.000, 0.133, 0.133, 0.000, 0.067],
1995 [0.118, 0.235, 0.000, 0.235, 0.059, 0.176, 0.118, 0.000, 0.059, 0.000],
1996 [0.077, 0.154, 0.308, 0.077, 0.154, 0.077, 0.000, 0.077, 0.077, 0.000],
1997 [0.083, 0.000, 0.167, 0.250, 0.083, 0.167, 0.000, 0.083, 0.167, 0.000],
1998 [0.222, 0.222, 0.000, 0.111, 0.111, 0.000, 0.111, 0.222, 0.000, 0.000],
1999 [0.091, 0.182, 0.273, 0.000, 0.091, 0.273, 0.000, 0.091, 0.000, 0.000],
2000 [0.111, 0.111, 0.111, 0.222, 0.000, 0.000, 0.000, 0.222, 0.111, 0.111],
2001 [0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.500, 0.000, 0.000, 0.500]],
2002 [[0.206, 0.088, 0.176, 0.176, 0.088, 0.029, 0.176, 0.029, 0.029, 0.000],
2003 [0.120, 0.100, 0.140, 0.160, 0.120, 0.220, 0.100, 0.000, 0.020, 0.020],
2004 [0.077, 0.123, 0.185, 0.123, 0.077, 0.139, 0.092, 0.123, 0.061, 0.000],
2005 [0.048, 0.111, 0.095, 0.206, 0.206, 0.190, 0.095, 0.048, 0.000, 0.000],
2006 [0.059, 0.137, 0.118, 0.137, 0.098, 0.118, 0.118, 0.157, 0.059, 0.000],
2007 [0.014, 0.097, 0.139, 0.153, 0.124, 0.139, 0.208, 0.056, 0.042, 0.028],
2008 [0.073, 0.101, 0.116, 0.145, 0.087, 0.159, 0.203, 0.087, 0.029, 0.000],
2009 [0.019, 0.037, 0.111, 0.056, 0.074, 0.111, 0.185, 0.296, 0.074, 0.037],
2010 [0.035, 0.069, 0.035, 0.000, 0.035, 0.103, 0.172, 0.138, 0.379, 0.035],
2011 [0.000, 0.167, 0.167, 0.000, 0.167, 0.000, 0.000, 0.333, 0.000, 0.167]],
2012 [[0.167, 0.167, 0.167, 0.000, 0.083, 0.125, 0.000, 0.167, 0.125, 0.000],
2013 [0.117, 0.117, 0.150, 0.117, 0.083, 0.117, 0.200, 0.067, 0.017, 0.017],
2014 [0.049, 0.085, 0.134, 0.158, 0.098, 0.110, 0.134, 0.134, 0.061, 0.037],
2015 [0.039, 0.090, 0.141, 0.141, 0.167, 0.141, 0.090, 0.141, 0.039, 0.013],
2016 [0.009, 0.139, 0.074, 0.093, 0.194, 0.139, 0.167, 0.093, 0.074, 0.019],
2017 [0.036, 0.018, 0.117, 0.099, 0.144, 0.180, 0.180, 0.117, 0.072, 0.036],
2018 [0.000, 0.046, 0.061, 0.061, 0.136, 0.159, 0.273, 0.167, 0.098, 0.000],
2019 [0.016, 0.056, 0.080, 0.128, 0.104, 0.080, 0.160, 0.208, 0.136, 0.032],
2020 [0.011, 0.053, 0.021, 0.043, 0.128, 0.096, 0.074, 0.223, 0.277, 0.074],
2021 [0.000, 0.074, 0.037, 0.000, 0.074, 0.074, 0.074, 0.074, 0.333, 0.259]],
2022 [[0.120, 0.200, 0.160, 0.120, 0.120, 0.120, 0.080, 0.000, 0.040, 0.040],
2023 [0.100, 0.080, 0.120, 0.140, 0.140, 0.200, 0.180, 0.040, 0.000, 0.000],
2024 [0.046, 0.114, 0.068, 0.171, 0.125, 0.171, 0.080, 0.159, 0.057, 0.011],
2025 [0.015, 0.061, 0.084, 0.099, 0.191, 0.153, 0.153, 0.115, 0.115, 0.015],
2026 [0.024, 0.030, 0.098, 0.098, 0.165, 0.195, 0.195, 0.140, 0.043, 0.012],
2027 [0.015, 0.026, 0.062, 0.124, 0.144, 0.170, 0.170, 0.222, 0.062, 0.005],
2028 [0.000, 0.013, 0.045, 0.108, 0.112, 0.175, 0.188, 0.224, 0.117, 0.018],
2029 [0.008, 0.023, 0.054, 0.066, 0.093, 0.125, 0.191, 0.253, 0.183, 0.004],
2030 [0.006, 0.022, 0.061, 0.033, 0.067, 0.083, 0.139, 0.222, 0.322, 0.044],
2031 [0.000, 0.046, 0.091, 0.091, 0.046, 0.046, 0.136, 0.091, 0.273, 0.182]],
2032 [[0.250, 0.179, 0.107, 0.107, 0.143, 0.071, 0.107, 0.036, 0.000, 0.000],
2033 [0.133, 0.022, 0.089, 0.111, 0.156, 0.178, 0.111, 0.133, 0.067, 0.000],
2034 [0.064, 0.048, 0.143, 0.048, 0.175, 0.143, 0.206, 0.095, 0.079, 0.000],
2035 [0.000, 0.022, 0.078, 0.111, 0.156, 0.156, 0.244, 0.167, 0.044, 0.022],
2036 [0.016, 0.027, 0.037, 0.069, 0.160, 0.219, 0.230, 0.160, 0.075, 0.005],
2037 [0.013, 0.025, 0.030, 0.093, 0.144, 0.202, 0.215, 0.219, 0.055, 0.004],
2038 [0.006, 0.041, 0.035, 0.064, 0.090, 0.180, 0.337, 0.192, 0.049, 0.006],
2039 [0.012, 0.021, 0.029, 0.035, 0.132, 0.123, 0.184, 0.371, 0.082, 0.012],
2040 [0.008, 0.016, 0.016, 0.024, 0.071, 0.103, 0.159, 0.270, 0.309, 0.024],
2041 [0.000, 0.000, 0.000, 0.000, 0.059, 0.000, 0.059, 0.294, 0.412, 0.176]],
2042 [[0.217, 0.087, 0.000, 0.174, 0.130, 0.087, 0.087, 0.130, 0.087, 0.000],
2043 [0.026, 0.079, 0.132, 0.079, 0.026, 0.158, 0.158, 0.132, 0.158, 0.053],
2044 [0.020, 0.020, 0.020, 0.040, 0.160, 0.180, 0.160, 0.200, 0.100, 0.100],
2045 [0.025, 0.013, 0.038, 0.076, 0.076, 0.139, 0.139, 0.266, 0.215, 0.013],
2046 [0.030, 0.030, 0.050, 0.020, 0.091, 0.131, 0.162, 0.282, 0.131, 0.071],
2047 [0.006, 0.006, 0.013, 0.057, 0.057, 0.121, 0.204, 0.287, 0.185, 0.064],
2048 [0.004, 0.026, 0.037, 0.030, 0.093, 0.107, 0.193, 0.307, 0.167, 0.037],
2049 [0.011, 0.009, 0.014, 0.042, 0.041, 0.071, 0.152, 0.418, 0.203, 0.041],
2050 [0.012, 0.022, 0.022, 0.038, 0.019, 0.050, 0.113, 0.281, 0.360, 0.084],
2051 [0.008, 0.024, 0.039, 0.039, 0.063, 0.039, 0.118, 0.118, 0.284, 0.268]],
2052 [[0.067, 0.133, 0.133, 0.067, 0.067, 0.200, 0.133, 0.133, 0.067, 0.000],
2053 [0.118, 0.059, 0.059, 0.059, 0.059, 0.118, 0.118, 0.235, 0.118, 0.059],
2054 [0.000, 0.024, 0.024, 0.049, 0.146, 0.073, 0.195, 0.244, 0.195, 0.049],
2055 [0.026, 0.000, 0.026, 0.026, 0.053, 0.184, 0.263, 0.184, 0.237, 0.000],
2056 [0.014, 0.000, 0.042, 0.056, 0.069, 0.097, 0.139, 0.306, 0.278, 0.000],
2057 [0.009, 0.009, 0.052, 0.069, 0.052, 0.112, 0.215, 0.285, 0.138, 0.060],
2058 [0.009, 0.009, 0.026, 0.017, 0.094, 0.099, 0.232, 0.283, 0.210, 0.021],
2059 [0.010, 0.014, 0.016, 0.019, 0.027, 0.062, 0.163, 0.467, 0.202, 0.019],
2060 [0.004, 0.007, 0.031, 0.017, 0.033, 0.050, 0.086, 0.252, 0.469, 0.050],
2061 [0.000, 0.000, 0.015, 0.046, 0.031, 0.046, 0.077, 0.123, 0.446, 0.215]],
2062 [[0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000],
2063 [0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000],
2064 [0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.250, 0.250, 0.500, 0.000],
2065 [0.000, 0.000, 0.000, 0.000, 0.250, 0.000, 0.000, 0.375, 0.250, 0.125],
2066 [0.000, 0.000, 0.000, 0.083, 0.000, 0.167, 0.167, 0.250, 0.333, 0.000],
2067 [0.000, 0.000, 0.042, 0.042, 0.042, 0.083, 0.083, 0.292, 0.292, 0.125],
2068 [0.000, 0.000, 0.032, 0.000, 0.000, 0.032, 0.129, 0.387, 0.355, 0.065],
2069 [0.000, 0.000, 0.000, 0.038, 0.038, 0.075, 0.047, 0.340, 0.415, 0.047],
2070 [0.004, 0.004, 0.007, 0.007, 0.011, 0.030, 0.052, 0.141, 0.654, 0.089],
2071 [0.000, 0.000, 0.000, 0.000, 0.061, 0.061, 0.030, 0.030, 0.349, 0.470]],
2072 [[0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.000, 0.000],
2073 [0.100, 0.100, 0.100, 0.100, 0.100, 0.100, 0.100, 0.100, 0.100, 0.100],
2074 [0.000, 0.000, 0.000, 0.250, 0.000, 0.000, 0.000, 0.500, 0.250, 0.000],
2075 [0.000, 0.000, 0.143, 0.143, 0.000, 0.143, 0.143, 0.429, 0.000, 0.000],
2076 [0.000, 0.000, 0.000, 0.200, 0.000, 0.000, 0.200, 0.400, 0.200, 0.000],
2077 [0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.222, 0.444, 0.333, 0.000],
2078 [0.000, 0.000, 0.000, 0.000, 0.080, 0.080, 0.080, 0.480, 0.240, 0.040],
2079 [0.000, 0.000, 0.027, 0.009, 0.027, 0.018, 0.135, 0.523, 0.252, 0.009],
2080 [0.000, 0.000, 0.000, 0.022, 0.000, 0.043, 0.043, 0.326, 0.511, 0.054],
2081 [0.000, 0.000, 0.000, 0.143, 0.000, 0.000, 0.000, 0.143, 0.714, 0.000]]]
2082
2083 KT_MAX_MIN = [[0.031, 0.705],
2084 [0.058, 0.694],
2085 [0.051, 0.753],
2086 [0.052, 0.753],
2087 [0.028, 0.807],
2088 [0.053, 0.856],
2089 [0.044, 0.818],
2090 [0.085, 0.846],
2091 [0.010, 0.842],
2092 [0.319, 0.865]]
2093
2094 def initialize()
2095 @kt_day = Array.new()
2096 @kt = Array.new()
2097 @irrad = Array.new()
2098 h_month = Site.get_h()
2099 @i = 0
2100 @j = 0
2101 time = Site.get_datetime()
2102 time_d = Time.utc(time.year,1,1)
2103 (0..11).each { |month|
2104 h0_m = 0.0
2105 n_m = 0.0
2106 while(time_d.month == (month + 1))
2107 Site.set_datetime(time_d)
2108 sun = SunPosition.new()
2109 super(sun)
2110 set_h0()
2111 h0_m += @h0
2112 time_d += 86400
2113 n_m += 1.0
2114 end
2115 h0_m = h0_m / n_m
2116 kt_d = h_month[month] / (h0_m * KWH)
2117 @kt.push(kt_d.round_to(3))
2118 }
2119 time_d = Time.utc(time.year,1,1)
2120 kt_day = @kt.at(11)
2121 (0..11).each { |month|
2122 if(@kt.at(month) <= 0.30)
2123 @i = 0
2124 elsif((0.30 < @kt.at(month))&&(@kt.at(month) <= 0.35))
2125 @i = 1
2126 elsif((0.35 < @kt.at(month))&&(@kt.at(month) <= 0.40))
2127 @i = 2
2128 elsif((0.40 < @kt.at(month))&&(@kt.at(month) <= 0.45))
2129 @i = 3
2130 elsif((0.45 < @kt.at(month))&&(@kt.at(month) <= 0.50))
2131 @i = 4
2132 elsif((0.50 < @kt.at(month))&&(@kt.at(month) <= 0.55))
2133 @i = 5
2134 elsif((0.55 < @kt.at(month))&&(@kt.at(month) <= 0.60))
2135 @i = 6
2136 elsif((0.60 < @kt.at(month))&&(@kt.at(month) <= 0.65))
2137 @i = 7
2138 elsif((0.65 < @kt.at(month))&&(@kt.at(month) <= 0.70))
2139 @i = 8
2140 elsif(0.70 < @kt.at(month))
2141 @i = 9
2142 end
2143 kt_min = KT_MAX_MIN[@i][0]
2144 kt_max = KT_MAX_MIN[@i][1]
2145 while(time_d.month == (month + 1))
2146 p_line = (kt_max - kt_min)/10.0
2147 (1..10).each { |line|
2148 @j = line - 1
2149 p = p_line + (line * p_line)
2150 break if(kt_day < p)
2151 }
2152 r = rand()
2153 r_0 = 0.0
2154 r_1 = 0.0
2155 r_row = 0
2156 (0..9).each { |row|
2157 r_row = row + 1
2158 r_0 = r_1
2159 r_1 += MTM_KT[@i][@j][row]
2160 break if(r_1 > r)
2161 }
2162 kt_line_0 = p_line + ((r_row - 1) * p_line)
2163 kt_line_1 = p_line + (r_row * p_line)
2164 kt_day = ((kt_line_0*(r - r_1))/(r_0 - r_1))+((kt_line_1*(r - r_0))/(r_1 - r_0))
2165 @kt_day.push(kt_day)
2166 time_d += 86400
2167 end
2168 }
2169 time_d = Time.utc(time.year,1,1)
2170 year = time_d.year
2171 while(time_d.year == year)
2172 kt_d = @kt_day.at(time_d.yday - 1)
2173 y = 0.1 + (rand() * 0.25)
2174 (0..23).each { |h|
2175 time_h = Time.utc(time_d.year,time_d.month,time_d.day,h,30)
2176 Site.set_datetime(time_h)
2177 sun = SunPosition.new()
2178 super(sun)
2179 set_i0()
2180 i = 0.0
2181 w_h = 0.0
2182 w_rate = 0.0
2183 if(sun.w < 0.0)
2184 w_h = sun.w_sunset.round_to(4) - (-1.0 * sun.w1.round_to(4))
2185 w_rate = (sun.w_sunset.round_to(4) - (-1.0 * sun.w.round_to(4))) / (-1.0 * sun.w.round_to(4))
2186 else
2187 w_h = sun.w_sunset.round_to(4) - sun.w2.round_to(4)
2188 w_rate = (sun.w_sunset.round_to(4) - sun.w.round_to(4)) / sun.w.round_to(4)
2189 end
2190 if(w_h > PI_24)
2191 f1 = 0.38 + (0.06 * Math.cos((7.4 * kt_d) - 2.5))
2192 kcs = 0.88 * Math.cos(Math::PI * (((sun.solar_time/60.0) - 12.5)/30.0))
2193 l = -0.19 + (1.12 * kt_d) + (0.24 * Math.exp(-8 * kt_d))
2194 e = 0.32 - (1.60 * ((kt_d - 0.50)**2))
2195 k = 0.19 + (2.27 * (kt_d**2)) - (2.51 * (kt_d**3))
2196 ktm = l + (e * Math.exp(-k / Math.sin(sun.elevation)))
2197 a = 0.14 * Math.exp(-20 * ((kt_d - 0.35)**2))
2198 b = (3 * ((kt_d - 0.45)**2)) + (0.16 * (kt_d**5))
2199 t = a * Math.exp(b * (1 - Math.sin(sun.elevation)))
2200 t_l = t * ((1 - (f1**2))**0.5)
2201 kt_h = 0.0
2202 seq_irrad = Array.new()
2203 (0..9).each { |seq|
2204 (0..100).each {
2205 z = rand()
2206 r = t_l * (((z**0.135) - ((1 - z)**0.135)) / 0.1975)
2207 y = (f1 * y) + r
2208 kt_h = ktm + (t * y)
2209 break if((kt_h > 0.0)&&(kt_h < kcs))
2210 }
2211 kt_h = 0.01 if(kt_h < 0.0)
2212 kt_h = kcs if(kt_h > kcs)
2213 i = @i0 * kt_h * WH
2214 i *= w_rate if(w_rate < 0.0)
2215 id = 0.0
2216 if(kt_d <= 0.22)
2217 id = i * (1 - (0.09 * kt_d))
2218 elsif((0.22 < kt_d)&&(kt_d <= 0.80))
2219 id = i * (0.9511 - (0.1604 * kt_d) + (4.388 * (kt_d**2)) - (16.638 * (kt_d**3)) + (12.336 * (kt_d**4)))
2220 else
2221 id = i * 0.165
2222 end
2223 seq_irrad[seq] = [i,id]
2224 }
2225 i_m = seq_irrad[0][0] + seq_irrad[1][0] + seq_irrad[2][0] + seq_irrad[3][0] + seq_irrad[4][0] + seq_irrad[5][0] + seq_irrad[6][0] + seq_irrad[7][0] + seq_irrad[8][0] + seq_irrad[9][0]
2226 id_m = seq_irrad[0][1] + seq_irrad[1][1] + seq_irrad[2][1] + seq_irrad[3][1] + seq_irrad[4][1] + seq_irrad[5][1] + seq_irrad[6][1] + seq_irrad[7][1] + seq_irrad[8][1] + seq_irrad[9][1]
2227 i_m /= 10.0
2228 id_m /= 10.0
2229 s_irrad = "#{time_h.strftime("%d/%m/%y %H:00")};#{i_m.ceil()};#{id_m.round_to(1)};"
2230 else
2231 s_irrad = "#{time_h.strftime("%d/%m/%y %H:00")};0;0.0;"
2232 end
2233 @irrad.push(s_irrad.gsub('.',','))
2234 }
2235 time_d += 86400
2236 end
2237 f = File.new(Sketchup.find_support_file('irrad.csv', 'Plugins/Solar3DBR'),'w')
2238 @irrad.each { |irrad| f.puts(irrad) }
2239 f.close()
2240 Site.set_irrad()
2241 end
2242
2243 end
2244
2245 class Geometrics
2246 def self.calc_face_area(vertices)
2247 area = 0.0
2248 k = vertices.size
2249 z = k - 2
2250 i = 0
2251 p0 = vertices[0]
2252 p1 = vertices[1]
2253 vb = p1.vector_to(p0)
2254 begin
2255 i += 1
2256 p1 = vertices[i + 1]
2257 va = vb
2258 vb = p1.vector_to(p0)
2259 vab = va * vb
2260 a = vab.length
2261 a *= -1 if(vab.z < 0)
2262 area += a
2263 end while(i < z)
2264 area = area.abs
2265 area = area / 2.0
2266 end
2267
2268 end
2269
2270 class Float
2271 def round_to(x)
2272 (self * 10**x).round.to_f / 10**x
2273 end
2274
2275 def ceil_to(x)
2276 (self * 10**x).ceil.to_f / 10**x
2277 end
2278
2279 def floor_to(x)
2280 (self * 10**x).floor.to_f / 10**x
2281 end
2282 end
2283
2284 class String
2285 def numeric?
2286 Float(self) != nil rescue false
2287 end
2288 end
2289
2290 # Código de inicialização
2291
2292 if( not $plugin_loaded )
2293 model = Sketchup.active_model
2294 layers = model.layers
2295 layers.add("Módulos") if (layers.at("Módulos") == nil)
2296 layers.add("Transparente") if (layers.at("Transparente") == nil)
2297
2298 $mod = Modules.new()
2299 Site.new()
2300
2301 cmd_show_surface = UI::Command.new("Mostrar superficies"){
2302 $mod.select_module_surfaces()
2303 $mod.show_face_direction()
2304 }
2305 cmd_show_surface.menu_text = "Mostrar superficies"
2306 cmd_show_surface.large_icon = Sketchup.find_support_file('show_surface_l.png', 'Plugins/Solar3DBR/Images')
2307 cmd_show_surface.small_icon = Sketchup.find_support_file('show_surface.png', 'Plugins/Solar3DBR/Images')
2308 cmd_show_surface.tooltip = "Mostrar superficies"
2309 cmd_show_surface.status_bar_text = "Mostrar la dirección de las superficies."
2310
2311 cmd_hide_surface = UI::Command.new("Ocultar superficies"){
2312 $mod.hide_face_direction()
2313 }
2314 cmd_hide_surface.menu_text = "Ocultar superficies"
2315 cmd_hide_surface.large_icon = Sketchup.find_support_file('hide_surface_l.png','Plugins/Solar3DBR/Images')
2316 cmd_hide_surface.small_icon = Sketchup.find_support_file('hide_surface.png','Plugins/Solar3DBR/Images')
2317 cmd_hide_surface.tooltip = "Ocultar superficies"
2318 cmd_hide_surface.status_bar_text = "Ocultar la dirección de las superficies."
2319
2320 cmd_invert_surface = UI::Command.new("Invertir superficies"){
2321 $mod.invert_face_direction()
2322 }
2323 cmd_invert_surface.menu_text = "Invertir superficies"
2324 cmd_invert_surface.large_icon = Sketchup.find_support_file('invert_surface_l.png', 'Plugins/Solar3DBR/Images')
2325 cmd_invert_surface.small_icon = Sketchup.find_support_file('invert_surface.png', 'Plugins/Solar3DBR/Images')
2326 cmd_invert_surface.tooltip = "Invertir superficies"
2327 cmd_invert_surface.status_bar_text = "Invertir la dirección de las superficies seleccionadas."
2328
2329 cmd_show_area = UI::Command.new("Calcular área"){
2330 sel = Sketchup.active_model.selection
2331 area = 0.0
2332 sel.each { |item|
2333 points = Array.new()
2334 item.outer_loop.vertices.each { |v| points.push(v.position)}
2335 area += Geometrics.calc_face_area(points)
2336 area *= 0.00064516
2337 }
2338 UI.messagebox("Área: #{area.round_to(2)} m²")
2339 }
2340 cmd_show_area.menu_text = "Calcular área"
2341 cmd_show_area.large_icon = Sketchup.find_support_file('show_area_l.png','Plugins/Solar3DBR/Images')
2342 cmd_show_area.small_icon = Sketchup.find_support_file('show_area.png','Plugins/Solar3DBR/Images')
2343 cmd_show_area.tooltip = "Calcular área"
2344 cmd_show_area.status_bar_text = "Calcular el área de las superficies seleccionadas."
2345
2346 cmd_irrad = UI::Command.new("Irradiación"){
2347 prompts = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
2348 d_h = Site.get_h()
2349 defaults = [d_h[0].to_s(),d_h[1].to_s(),d_h[2].to_s(),d_h[3].to_s(),d_h[4].to_s(),d_h[5].to_s(),d_h[6].to_s(),d_h[7].to_s(),d_h[8].to_s(),d_h[9].to_s(),d_h[10].to_s(),d_h[11].to_s()]
2350 input = UI.inputbox(prompts, defaults, "Irradiación (kWh/m²)")
2351 unless((input.nil? == true)||(input == false))
2352 erro = false
2353 h = Array.new()
2354 input.each { |irrad|
2355 i_s = irrad.gsub(',','.')
2356 if(i_s.numeric? == true)
2357 i = i_s.to_f()
2358 if(i >= 0.0)
2359 h.push(i)
2360 else
2361 erro = true
2362 UI.messagebox("Entrada inválida! Ingrese números positivos.")
2363 break
2364 end
2365 else
2366 erro = true
2367 UI.messagebox("Entrada inválida! Ingrese solo valores numéricos.")
2368 break
2369 end
2370 }
2371 if(erro == false)
2372 Site.set_h(h)
2373 Sketchup.status_text = "Generando serie sintética de irradiación horaria. Espere!!!"
2374 SyntheticIrrad.new()
2375 Sketchup.status_text = "Finalizado!!!"
2376 end
2377 end
2378 }
2379 cmd_irrad.menu_text = "Irradiação"
2380 cmd_irrad.large_icon = Sketchup.find_support_file('irrad_l.png', 'Plugins/Solar3DBR/Images')
2381 cmd_irrad.small_icon = Sketchup.find_support_file('irrad.png', 'Plugins/Solar3DBR/Images')
2382 cmd_irrad.tooltip = "Irradiação"
2383 cmd_irrad.status_bar_text = "Ingresar datos de irradiación global diaria promedio mensual."
2384
2385 cmd_albedo = UI::Command.new("Albedo"){
2386 prompts = ["Albedo"]
2387 defaults = [Site.get_albedo().to_s()]
2388 input = UI.inputbox(prompts, defaults, "Albedo")
2389 unless((input.nil? == true)||(input == false))
2390 albedo_s = input[0].gsub(',','.')
2391 if(albedo_s.numeric? == true)
2392 albedo = albedo_s.to_f()
2393 if(albedo >= 0.0)
2394 Site.set_albedo(albedo)
2395 else
2396 UI.messagebox("Entrada inválida! Ingrese números positivos.")
2397 end
2398 else
2399 UI.messagebox("Entrada inválida! Ingrese solo valores numéricos.")
2400 end
2401 end
2402 }
2403 cmd_albedo.menu_text = "Albedo"
2404 cmd_albedo.large_icon = Sketchup.find_support_file('albedo_l.png','Plugins/Solar3DBR/Images')
2405 cmd_albedo.small_icon = Sketchup.find_support_file('albedo.png', 'Plugins/Solar3DBR/Images')
2406 cmd_albedo.tooltip = "Albedo"
2407 cmd_albedo.status_bar_text = "Ingresar valor del albedo del lugar."
2408
2409 cmd_shadow = UI::Command.new("Máscara de sombreado"){
2410 prompts = ["Seleccione:"]
2411 defaults = ["5°x5°"]
2412 list = ["1°x1°|2°x2°|5°x5°|10°x10°"]
2413 input = UI.inputbox(prompts, defaults, list, "Resolución")
2414 unless((input.nil? == true)||(input == false))
2415 Sketchup.status_text = "Generando máscara de sombreado. Espere!!!"
2416 $mod.select_module_surfaces()
2417 $mod.submit_module_surfaces(input[0])
2418 Sketchup.status_text = "Finalizado!!!"
2419 end
2420 }
2421 cmd_shadow.menu_text = "Generar máscara"
2422 cmd_shadow.large_icon = Sketchup.find_support_file('shadow_mask_l.png','Plugins/Solar3DBR/Images')
2423 cmd_shadow.small_icon = Sketchup.find_support_file('shadow_mask.png','Plugins/Solar3DBR/Images')
2424 cmd_shadow.tooltip = "Máscara de sombreado"
2425 cmd_shadow.status_bar_text = "Generar máscara de sombreado."
2426
2427 cmd_sim_inst = UI::Command.new("Simular Instante"){
2428 Simulation.new(Simulation::NOW,$mod)
2429 }
2430 cmd_sim_inst.menu_text = "Momento"
2431 cmd_sim_inst.large_icon = Sketchup.find_support_file('sim_inst_l.png','Plugins/Solar3DBR/Images')
2432 cmd_sim_inst.small_icon = Sketchup.find_support_file('sim_inst.png','Plugins/Solar3DBR/Images')
2433 cmd_sim_inst.tooltip = "Simular momento"
2434 cmd_sim_inst.status_bar_text = "Ejecutar una simulación del momento seleccionado."
2435
2436 cmd_sim_hour = UI::Command.new("Simular horario"){
2437 Simulation.new(Simulation::HOUR,$mod)
2438 }
2439 cmd_sim_hour.menu_text = "Hora"
2440 cmd_sim_hour.large_icon = Sketchup.find_support_file('sim_hour_l.png','Plugins/Solar3DBR/Images')
2441 cmd_sim_hour.small_icon = Sketchup.find_support_file('sim_hour.png',
'Plugins/Solar3DBR/Images')
2442 cmd_sim_hour.tooltip = "Simular hora"
2443 cmd_sim_hour.status_bar_text = "Ejecutar una simulación del horario seleccionado."
2444
2445 cmd_sim_day = UI::Command.new("Simular día"){
2446 Simulation.new(Simulation::DAY,$mod)
2447 }
2448 cmd_sim_day.menu_text = "Dia"
2449 cmd_sim_day.large_icon = Sketchup.find_support_file('sim_day_l.png','Plugins/Solar3DBR/Images')
2450 cmd_sim_day.small_icon = Sketchup.find_support_file('sim_day.png','Plugins/Solar3DBR/Images')
2451 cmd_sim_day.tooltip = "Simular dia"
2452 cmd_sim_day.status_bar_text = "Ejecutar una simulación del día seleccionado."
2453
2454 cmd_sim_month = UI::Command.new("Simular Mês"){
2455 Simulation.new(Simulation::MONTH,$mod)
2456 }
2457 cmd_sim_month.menu_text = "Mês"
2458 cmd_sim_month.large_icon = Sketchup.find_support_file('sim_month_l.png','Plugins/Solar3DBR/Images')
2459 cmd_sim_month.small_icon = Sketchup.find_support_file('sim_month.png','Plugins/Solar3DBR/Images')
2460 cmd_sim_month.tooltip = "Simular mes"
2461 cmd_sim_month.status_bar_text = "Ejecutar una simulación del mes seleccionado."
2462
2463 cmd_sim_year = UI::Command.new("Simular año"){
2464 Simulation.new(Simulation::YEAR,$mod)
2465 }
2466 cmd_sim_year.menu_text = "Ano"
2467 cmd_sim_year.large_icon = Sketchup.find_support_file('sim_year_l.png','Plugins/Solar3DBR/Images')
2468 cmd_sim_year.small_icon = Sketchup.find_support_file('sim_year.png','Plugins/Solar3DBR/Images')
2469 cmd_sim_year.tooltip = "Simular ano"
2470 cmd_sim_year.status_bar_text = "Ejecutar una simulación del año seleccionado."
2471
2472 cmd_sim_save = UI::Command.new("Guardar"){
2473 $mod.file_save()
2474 }
2475 cmd_sim_save.set_validation_proc {
2476 if($mod.file_empty? == true)
2477 MF_GRAYED
2478 else
2479 MF_ENABLED
2480 end
2481 }
2482 cmd_sim_save.menu_text = "Guardar"
2483 cmd_sim_save.large_icon = Sketchup.find_support_file('sim_save_l.png','Plugins/Solar3DBR/Images')
2484 cmd_sim_save.small_icon = Sketchup.find_support_file('sim_save.png','Plugins/Solar3DBR/Images')
2485 cmd_sim_save.tooltip = "Guardar resultados"
2486 cmd_sim_save.status_bar_text = "Guardar el resultado de las simulaciones realizadas."
2487
2488 plugin_menu = UI.menu("Plugins")
2489 solar_3d_br_menu = plugin_menu.add_submenu($exStrings.GetString("Solar 3DBR"))
2490
2491 mod_menu = solar_3d_br_menu.add_submenu($exStrings.GetString("Módulos"))
2492 mod_menu.add_item(cmd_show_surface)
2493 mod_menu.add_item(cmd_hide_surface)
2494 mod_menu.add_item(cmd_invert_surface)
2495 mod_menu.add_item(cmd_show_area)
2496
2497 solar_3d_br_menu.add_separator()
2498 irrad_menu = solar_3d_br_menu.add_submenu($exStrings.GetString("Datos"))
2499 irrad_menu.add_item(cmd_irrad)
2500 irrad_menu.add_item(cmd_albedo)
2501
2502 solar_3d_br_menu.add_separator()
2503 shad_menu = solar_3d_br_menu.add_submenu($exStrings.GetString("Sombreado"))
2504 shad_menu.add_item(cmd_shadow)
2505
2506 solar_3d_br_menu.add_separator()
2507 sim_menu = solar_3d_br_menu.add_submenu($exStrings.GetString("Simular"))
2508 sim_menu.add_item(cmd_sim_inst)
2509 sim_menu.add_item(cmd_sim_hour)
2510 sim_menu.add_item(cmd_sim_day)
2511 sim_menu.add_item(cmd_sim_month)
2512 sim_menu.add_item(cmd_sim_year)
2513 sim_menu.add_item(cmd_sim_save)
2514
2515 toolbar = UI::Toolbar.new "Barra Solar3DBR"
2516 toolbar = toolbar.add_separator()
2517 toolbar = toolbar.add_item(cmd_show_surface)
2518 toolbar = toolbar.add_item(cmd_hide_surface)
2519 toolbar = toolbar.add_item(cmd_invert_surface)
2520 toolbar = toolbar.add_item(cmd_show_area)
2521 toolbar = toolbar.add_separator()
2522 toolbar = toolbar.add_item(cmd_irrad)
2523 toolbar = toolbar.add_item(cmd_albedo)
2524 toolbar = toolbar.add_separator()
2525 toolbar = toolbar.add_item(cmd_shadow)
2526 toolbar = toolbar.add_separator()
2527 toolbar = toolbar.add_item(cmd_sim_inst)
2528 toolbar = toolbar.add_item(cmd_sim_hour)
2529 toolbar = toolbar.add_item(cmd_sim_day)
2530 toolbar = toolbar.add_item(cmd_sim_month)
2531 toolbar = toolbar.add_item(cmd_sim_year)
2532 toolbar = toolbar.add_item(cmd_sim_save)
2533 toolbar.show
2534
2535 Sketchup.active_model.shadow_info["Latitud"] = -23.556936
2536 Sketchup.active_model.shadow_info["Longitud"] = -46.730765
2537 $mod.select_module_surfaces()
2538 $plugin_loaded = true
2539 end
2540
2541 # OBSERVERS --------------------------------------------------------------------
2542
2543 class MyShadowInfoObserver < Sketchup::ShadowInfoObserver
2544 def onShadowInfoChanged(shadow_info, type)
2545 Site.set_latlong(shadow_info["Latitud"],shadow_info["Longitud"])
2546 Site.set_datetime(shadow_info["Tiempo sombreado"].utc)
2547 Site.set_timezone(shadow_info["TZOffset"])
2548 end
2549 end
2550
2551 Sketchup.active_model.shadow_info.add_observer(MyShadowInfoObserver.new)
2552
2553 #-----------------------------------------------------------------------------
