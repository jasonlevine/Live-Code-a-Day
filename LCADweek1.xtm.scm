;hey whats up?  my name is JASON. I'm trying something NEW tonight. soooooooooo. ON WITH IT

(define scale (pc:scale 0 'dorian))

(define wave
  (lambda (min max wavelength)
    (let ((freq (/ 1 wavelength)) (range (- max min)))
      (let ((cosNorm (+ 0.5 (* 0.5 (cos (* (now) freq))))))
        (+ min (* cosNorm range)) 
    ))))

(define root 60)


(define kick
  (lambda (beat dur)
  	(if (or (= (modulo beat 4) 0) (= (modulo beat 4) 3/4) (= (modulo beat 4) 6/4)) 
    	(play drums 10 130 dur))
    (callback (*metro* (+ beat (* .5 dur))) 'kick (+ beat dur) dur)
    ))


(kick (*metro* 'get-beat 1) 1)

(define perc1
  (lambda (beat dur)
    (if (> (modulo beat 8) 3) 
      (play conga (wave 10 17 5/2) (wave 20 130 5/4) dur))
    (callback (*metro* (+ beat (* .5 dur))) 'perc1 (+ beat dur) dur)
    ))


(perc1 (*metro* 'get-beat 1) 1/3)

(define toms
  (lambda (beat dur)
    (if (< (modulo beat 8) 7) 
      (play drums (wave 12 16 4) (wave 50 80 5/4) dur))
    (callback (*metro* (+ beat (* .5 dur))) 'toms (+ beat dur) dur)
    ))


(toms (*metro* 'get-beat 1) 1/3)


(define perc2
  (lambda (beat dur)
    (if (or (= (modulo beat 1) 0) (= (modulo beat 2) 1) (= (modulo beat 3) 2)) 
      (play drums (random '(12 13 14 15 16 17)) 60 dur))
    (callback (*metro* (+ beat (* .5 dur))) 'perc2 (+ beat dur) dur)
    ))


(perc2 (*metro* 'get-beat 1) 1)

(define guimbard
  (lambda (beat dur)
    (if (or (= (modulo beat 6) 0) (= (modulo beat 6/2) 1/2) (= (modulo beat 6/2) 7/4)) 
      (play jawharp (random 10 17) (wave 70 90 2) dur)
    (play jawharp (random 17 21) (wave 70 90 3) dur))
    (callback (*metro* (+ beat (* .5 dur))) 'guimbard (+ beat dur) dur)
    ))


(guimbard (*metro* 'get-beat 1) 1/4)


(define guimbard2
  (lambda (beat dur) 
    (play jawharp (wave 20 22 5)  (wave 0 80 3) dur)
   ; (callback (*metro* (+ beat (* .5 dur))) 'guimbard2 (+ beat dur) dur)
    ))


(guimbard2 (*metro* 'get-beat 1) 1/4)

(define bells
  (lambda (beat dur)
    (play drums  (if (< (modulo beat 8) 2) 40 36) (wave 70 90 4/5) dur)
    (callback (*metro* (+ beat (* .5 dur))) 'bells (+ beat dur) dur)
    ))


(bells (*metro* 'get-beat 1) 1)


(define snare
  (lambda (beat dur)
    (if (= (modulo beat 4) 2)
    	(play  drums (random '( 43 )) 120 dur))
  (callback (*metro* (+ beat (* .5 dur))) 'snare (+ beat dur) dur)
    ))

(snare (*metro* 'get-beat 1) 1)

(define hihats
  (lambda (beat dur)
    (play  drums 25 (wave 30 60 (/ dur 4)) dur)
   (callback (*metro* (+ beat (* .5 dur))) 'hihats (+ beat dur) dur)
    ))

(hihats (*metro* 'get-beat 1) 1/2)

(define snareRolls
  (lambda (beat dur)
    (play drums (random '(37 38 39)) (wave 80 120 8/3) dur)
   ; (callback (*metro* (+ beat (* .5 dur))) 'snareRolls (+ beat dur) 1/2)
    ))

(snareRolls (*metro* 'get-beat 1) 1/4) 
(hihats (*metro* 'get-beat 1) 1)


(define melody
  (lambda (beat dur octave)
    (play fmsynth (pc:relative (+ root (* (- octave 4) 12)) (+ (wave 0 12 8) (wave 0 3 2)) scale) (wave 5 40 4/4) dur)
    ;(play piano (pc:relative (* octave 12) (wave 0 12 octave) scale) (wave 90 125 3) dur)
    (callback (*metro* (+ beat (* .6 dur))) 'melody (+ beat (+ 0.5 dur)) dur octave )
    ))

(melody (*metro* 'get-beat 1) 1/8 6)


(define bassline
  (lambda (beat dur)
    (play fuzzbass (+ root (random '(-24 -24 -17))) 5 dur)
    (callback (*metro* (+ beat (* .5 dur))) 'bassline (+ beat dur) (random '(2 1 1/2)))
    ))

(bassline (*metro* 'get-beat 1) 1)

(define harmony
  (lambda (beat dur octave)
    ;(play piano (pc:relative (+ (* octave 12)) (wave 0 7 7) scale) (wave 0 170 1) (* 2 dur))
    ;(play piano (pc:relative (+ (* octave 12)) (wave 2 9 6) scale) (wave 0 150 2) dur)
    ;(play  piano (pc:relative (+ (* octave 12)) (wave 4 11 5) scale) (wave 0 150 3) dur)
    ;(play  piano (pc:relative (+ (* octave 12)) (wave 6 13 4) scale) (wave 0 150 4) dur)
    ;(play  piano (pc:relative (+ (* octave 12)) (wave 8 15 3) scale) (wave 0 150 5) dur)
    ;(callback (*metro* (+ beat (* .5 dur))) 'harmony (+ beat dur) dur octave )
    ))

(harmony (*metro* 'get-beat 1) 1/4 5)


(define chords
  (lambda (beat dur)
    (set! root (random (cdr (assoc root '((60 58)
                                        (58 67)
                                        (67 63 62)
                                        (63 60 69)
                                        (62 60 67)
                                        (69 67 60))))))
    (for-each (lambda (p)
                (play piano p 140 dur))
              (pc:make-chord root (+ root 12) 3 scale))
    (callback (*metro* (+ beat (* .5 dur))) 'chords (+ beat dur) dur)
    ))

(chords (*metro* 'get-beat 1) 2)

(snare (*metro* 'get-beat 1) )
(kick 35 1)

(kick (*metro* 'get-beat 1) 1/4)
(snare (*metro* 'get-beat 1) 1)




(wave 1 10 1)
