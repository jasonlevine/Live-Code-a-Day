;;;week2

(define scale (pc:scale 7 'ionian))

(define wave
  (lambda (min max wavelength)
    (let ((freq (/ 1 wavelength)) (range (- max min)))
      (let ((cosNorm (+ 0.5 (* 0.5 (cos (* (now) freq))))))
        (+ min (* cosNorm range)) 
    ))))

(define root 0)
(define pcr
  (lambda ()
    (pc:relative 48 root scale))) 

;;;;;;;;; harmony

(define key-change
  (lambda (beat)
    (if (= (modulo beat 16) 0)
      (set! scale (pc:scale 0 'lydian)))

    (if (= (modulo beat 16) 8)
      (set! scale (pc:scale 0 'wholetone)))

    (callback (*metro* (+ beat (* .5 1))) 'key-change (+ beat 1))
    ))

(key-change (*metro* 'get-beat 1) 1)

(define chords
  (lambda (beat dur)

    (if (= (modulo beat 4) 0)
      (set! root (random (cdr (assoc root '((0 2) (2 4) (4 6) (6 0)) )))))

    (if (= (modulo beat 4) 0) 
      (for-each (lambda (p)
                (play fmsynth p 12 4))
                (pc:make-chord (pcr) (+ (pcr) 24) 4 scale)))

    (callback (*metro* (+ beat (* .5 dur))) 'chords (+ beat dur) dur)
    ))

(chords (*metro* 'get-beat 1) 1)

(define bassline
  (lambda (beat dur)
    (if  (or (= (modulo beat 8) 0) (= (modulo beat 8) 3/4) (= (modulo beat 8) 6/4))
      (play fuzzbass (pc:relative ( - (pcr) 24) (/ (modulo beat 8) 1/4) scale) 5 dur))

    (if  (= (modulo beat 8) 4) 
      (play fuzzbass  ( - (pcr) 24)  5 4))
    (callback (*metro* (+ beat (* .5 dur))) 'bassline (+ beat dur) dur)
    ))

(bassline (*metro* 'get-beat 1) 1/4)

(define melody
  (lambda (beat dur octave)
    (if (< (modulo beat 4) 2)
      (play piano 
        (pc:relative (+ (pcr) (* octave 12)) (* (random '(-1 1 3/2 2)) (modulo (/ (modulo beat 8) dur) 4)) scale) 
        (random '(0 120)) (random '(1/4 1 1/2))))
    (callback (*metro* (+ beat (* .6 dur))) 'melody (+ beat dur)  dur  octave )
    ))

(melody (*metro* 'get-beat 1) 1/8 1)


;;;;; drums



(define kick
  (lambda (beat dur)
  	(if  (or (= (modulo beat 2) 0) (= (modulo beat (random 1 3)) 3/8) (= (modulo beat (random 2 7)) 6/8))  
    	(play drums 10 (random 90 110) dur))
    ;(callback (*metro* (+ beat (* .5 dur))) 'kick (+ beat dur) dur)
    ))


(kick (*metro* 'get-beat 1) 1/8)

(define snare
  (lambda (beat dur)
    (if (= (modulo beat 1) 1/8) 
      (play  drums (random '(36 46)) 120 1))
    ;(callback (*metro* (+ beat (* .5 dur))) 'snare (+ beat dur) dur)
    ))

(snare (*metro* 'get-beat 1) 1/8)

(define hihats
  (lambda (beat dur)
    (play drums (random '(24)) (wave 60 80 3/2) dur)
   ;(callback (*metro* (+ beat (* .5 dur))) 'hihats (+ beat dur) dur)
    ))

(hihats (*metro* 'get-beat 1) 1/4)

(define ride
  (lambda (beat dur)
    (play drums (random '(30 30 30 31)) (random '(0 50 70)) 2)
   ;(callback (*metro* (+ beat (* .5 dur))) 'ride (+ beat dur) dur)
    ))

(ride (*metro* 'get-beat 1) 1/4)

(define toms
  (lambda (beat dur)
    (if (< (modulo beat (random 5)) 4) 
      (play drums (wave 12 16 1) (wave 0 80 5/6) 1))
    ;(callback (*metro* (+ beat (* .5 dur))) 'toms (+ beat dur) dur)
    ))


(toms (*metro* 'get-beat 1) 1/6)


;;percussion

(define perc1
  (lambda (beat dur)
    (if (< (modulo beat 7) 3) 
      (play conga (random 12 20) (random '(0 80 100)) dur))
    ;(callback (*metro* (+ beat (* .5 dur))) 'perc1 (+ beat dur) dur)
    ))


(perc1 (*metro* 'get-beat 1) 1/4)



(define perc2
  (lambda (beat dur)
    (if (or (= (modulo beat 1) 0) (= (modulo beat 2) 1) (= (modulo beat 3) 2)) 
      (play drums (random '(12 13 14 15 16 17)) 60 dur))
    (callback (*metro* (+ beat (* .5 dur))) 'perc2 (+ beat dur) dur)
    ))


(perc2 (*metro* 'get-beat 1) 1)

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


