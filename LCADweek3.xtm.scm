;;;week3 globals

(sys:load "libs/core/pc_ivl.xtm")

(define scale (pc:scale 8 'phrygian))

(define wave
  (lambda (min max wavelength)
    (let ((freq (/ 1 wavelength)) (range (- max min)))
      (let ((sinNorm (+ 0.5 (* 0.5 (sin (* (now) freq))))))
        (+ min (* sinNorm range)) 
    ))))

(define root 3)
(define pcr
  (lambda ()
    (pc:relative 48 root scale))) 

(define cb
  (lambda (beat dur func)
    (callback (*metro* (+ beat (* .5 dur))) func (+ beat dur))))

;;;;;;;;; harmony

(define key-change
  (lambda (beat)
    (cond ((= (modulo beat 64) 0) (set! scale (pc:scale 8 'aeolian)))
          ((= (modulo beat 64) 16) (set! scale (pc:scale 11 'ionian)))
          ((= (modulo beat 64) 32) (set! scale (pc:scale 8 'aeolian)))
          ((= (modulo beat 64) 48) (set! scale (pc:scale 11 'ionian))))

    (callback (*metro* (+ beat (* .5 1))) 'key-change (+ beat 1))
    ; (cb beat dur 'keychange)
    ))

(key-change (*metro* 'get-beat 1))
(chords (*metro* 'get-beat 1) 1)
(scale)

(define chords
  (lambda (beat dur)

    (if (= (modulo beat 4) 0)
      (set! root (random (cdr (assoc root '((1 2) (2 3) (3 5) (5 1) ) )))))

    ; (if (= (modulo beat 2) 0)
    ;   (play shimmer (+ (pcr) 0) (wave 20 40 1) 1))

    (if (*metre1* beat 1)
      (for-each (lambda (p)
                (play piano p (wave 140 160 (* 3 dur)) dur))
                (pc:make-chord (pcr) (+ (pcr) 24) (random '(3 2)) scale)))

    (callback (*metro* (+ beat (* .5 dur))) 'chords (+ beat dur) dur)
    ; (cb beat dur 'chords)
    ))


(chords (*metro* 'get-beat 1) 1)

(define bassline
  (lambda (beat dur)
    (if (< (modulo beat 4) 3)
      (play sawbass ( - (pcr) 12) 100 1/4))
    (callback (*metro* (+ beat (* .5 dur))) 'bassline (+ beat dur) dur)
    ))

(bassline (*metro* 'get-beat 1) 1/2)

(define bassline
  (lambda (beat dur)
    (if (= (modulo beat 4) 0)
      (play sawbass ( + (pcr) 12) 100 2))
    (callback (*metro* (+ beat (* .5 dur))) 'bassline (+ beat dur) dur)
    ))

(bassline (*metro* 'get-beat 1) 1)

(define melody
  (lambda (beat dur octave)
    (if (= (modulo beat 1) 0)
      (set! dur (random '(3/2 1/2))))
    (play fmsynth (pc:relative (+ (pcr) (* octave 12)) 
                  (* (random '(-1 1 2)) ( modulo  (/ (modulo beat 8) dur) 8)) scale) 
                  (random '(50 0)) dur)
    (callback (*metro* (+ beat (* .6 dur))) 'melody (+ beat dur) dur octave )
    ))

(melody (*metro* 'get-beat 1) 1 3)


(define bassline
  (lambda (beat dur)
    (if (= (modulo beat 1) 0)
      (set! dur (random '(2 3))))
    (play subbass (pc:relative (+ (pcr) 0) 
                  (* (random '(-1 1 2)) ( modulo  (/ (modulo beat 8) dur) 8)) scale) 
                  (random '(90 110)) dur)
    ;(callback (*metro* (+ beat (* .6 dur))) 'bassline (+ beat dur) dur)
    ))

(bassline (*metro* 'get-beat 1) 1)


;;;;; drums



(define kick
  (lambda (beat dur)
  	(if  (= (modulo beat 3) 0)  
    	(play edrums 13 140 dur))
    ;(callback (*metro* (+ beat (* .5 dur))) 'kick (+ beat dur) dur)
    ))


(kick (*metro* 'get-beat 1) 1)

(define kick2
  (lambda (beat dur)
    ; (if  (= (modulo beat 1) 0)  
      (play edrums 18 (wave 80 100 (random '(5/2 4/3))) dur)
    ;(callback (*metro* (+ beat (* .5 dur))) 'kick2 (+ beat dur) dur)
    ))


(kick2 (*metro* 'get-beat 1) 1/4)

(define snare
  (lambda (beat dur)
    (if (or (= (modulo beat 3/4) 1/4) (= (modulo beat (random 3 8)) 2/2))
      (play  edrums (random '(40 41 46)) (wave 80 120 (random '(7/2 4/7))) 1))
   ; (callback (*metro* (+ beat (* .5 dur))) 'snare (+ beat dur) dur)
    ))

(snare (*metro* 'get-beat 1) 1/4)

(define snare2
  (lambda (beat dur)
    (if (= (modulo beat 1/2) 1/4)
      (play  edrums (random '(47 44 46)) (wave 60 100 5/4) 1))
   ;(callback (*metro* (+ beat (* .5 dur))) 'snare2 (+ beat dur) 1/8)
    ))

(snare2 (*metro* 'get-beat 1) 1/4)

(define hihats
  (lambda (beat dur)
    (play edrums (random '( 20 21 22)) (wave 70 80 2) dur)
   ;callback (*metro* (+ beat (* .5 dur))) 'hihats (+ beat dur) dur)
    ))

(hihats (*metro* 'get-beat 1) 1/2)

(define hihats2
  (lambda (beat dur)
    (play edrums (random 21 21 22 23) (wave 80 110 1) dur)
   ;(callback (*metro* (+ beat (* .5 dur))) 'hihats2 (+ beat dur) dur)
    ))

(hihats2 (*metro* 'get-beat 1) 1/4)

(define ride
  (lambda (beat dur)
    (play drums (random '(30 30 30 31)) (random '(0 80)) 1)
   (callback (*metro* (+ beat (* .5 dur))) 'ride (+ beat dur) dur)
    ))

(ride (*metro* 'get-beat 1) 1/4)

(define toms
  (lambda (beat dur)
    (if (= (modulo beat 1) 0) 
      (play drums (random '(11 12 13 14)) (random '(0 0 90)) dur))
    (callback (*metro* (+ beat (* .5 dur))) 'toms (+ beat dur) dur)
    ))


(toms (*metro* 'get-beat 1) 1)


;;percussion

(define perc1
  (lambda (beat dur)
    (if (< (modulo beat 5) 3) 
      (play conga (wave 12 17 5/2) (wave 70 100 5) dur))
    (callback (*metro* (+ beat (* .5 dur))) 'perc1 (+ beat dur) dur)
    ))


(perc1 (*metro* 'get-beat 1) 1/4)



(define perc2
  (lambda (beat dur)
    ;(if (or (= (modulo beat 1) 0) (= (modulo beat 2) 1) (= (modulo beat 3) 2)) 
      (play djembe (random '(12 13 14 15)) (wave 70 100 (random '(3/4 5/2)) dur))
    ;(callback (*metro* (+ beat (* .5 dur))) 'perc2 (+ beat dur) dur)
    ))


(perc2 (*metro* 'get-beat 1) 1/2)

(define bells
  (lambda (beat dur)
   ; (play drums  (if (< (modulo beat 3) 2) 36 41) 80 dur)
    (callback (*metro* (+ beat (* .5 dur))) 'bells (+ beat dur) dur)
    ))


(bells (*metro* 'get-beat 1) 1)

(define guimbard
  (lambda (beat dur)
    (if (or (= (modulo beat 8) 0) (= (modulo beat 4) 1/2) (= (modulo beat 16) 7/4)) 
      ;(play jawharp (random 10 17) (wave 70 90 2) dur)
      (play jawharp (random 17 21) (wave 70 90 3) dur))
   ; (callback (*metro* (+ beat (* .5 dur))) 'guimbard (+ beat dur) dur)
    ))


(guimbard (*metro* 'get-beat 1) 1/4)


(scale)


