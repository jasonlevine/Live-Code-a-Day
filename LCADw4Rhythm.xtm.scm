;;;;; drums
;; define me first!
(define *metro* (make-metro 90))

(define *subdiv* 1/2)
(define *metre1* (make-metre '( 4 2 3 1 3 ) *subdiv*))
(define *metre2* (make-metre '( 3 2 1) *subdiv*))
(define *metre3* (make-metre '( 3 3 1 2) *subdiv*))
(define *metre4* (make-metre '( 3 3 1 3 3 2) *subdiv*))


(define *degree* 0.0)
(let ((vtk 0.0) (seconds 15))
  (set-signal! *degree* vtk seconds))

(set-signal! *kickVel* 0 15)

(define rampDegree
  (lambda (degree)
    (set! *degree* degree)
    (let ((vtk (- degree 10)) (seconds 0.3))
    (set-signal! *degree* vtk seconds))))


(bind-val degree double 0.0)

(bind-func ramp_degree
  (lambda (val:double)
    (set! degree 1.0)
    (let ((vtk (- val 10)) (seconds 0.3))
    (set-signal! degree vtk seconds))))


(ramp_degree 43.0)

(define kit
  (lambda (beat dur)

      (cond ((*metre1* beat 1.0) (play edrums (random 14 18) 150 dur))
            ((*metre1* beat 2.0) (play perc 11 130 dur))
            ((*metre1* beat 3.0) (play perc (random '(10 14)) 100 dur))
            ((*metre1* beat 4.0) (play drums 46 150 dur)))

      (if (*metre4* beat 1.0) (play perc 16 100 dur))

       (cond ((*metre1* beat 1.0) (set_curr_note -14))
             ((*metre2* beat 1.0) (set_curr_note 11))
             ((*metre3* beat 3.0) (set_curr_note 24))
             ((*metre3* beat 4.0) (set_curr_note 96)))

      ;(play doumbek (cosr 20 10 dur) 140 dur)

    ; )

    ;(play doumbek (rampr 20 10 1/8) 140 dur)
    (play edrums 20 (cosr 100 20 1/4) dur)
    

   (callback (*metro* (+ beat (* 0.5 dur))) 'kit (+ beat dur) 1/4)
))


(kit (*metro* 'get-beat 1) 1/4) 




(define kit2
  (lambda (beat dur)
      (cond ((*metre1* beat 1.0) (play djembe (random 10 11) (random '(140 0)) dur))
             ((*metre2* beat 1.0) (play djembe (random 16 17) (random '(120 0)) dur))
             ((*metre3* beat 1.0) (play djembe (random 22 13) (random '(120 0)) dur)))

     ; (play djembe (random 20 25) (random 80 130) 1/4)

    

   (callback (*metro* (+ beat (* 0.5 dur))) 'kit2 (+ beat dur) dur)
))

(kit2 (*metro* 'get-beat 1) 1/2)

(play conga (random 10 15) 140 1)


(define perc1
  (lambda (beat dur)
      (if (*metre3* beat 1.0) (play piano (random 50 54) (random '(100 130)) dur))
      (if (*metre2* beat 1.0) (play piano (rampr 30 12 dur) (random '(130 110)) dur))
      (if (*metre1* beat 1.0) (play piano (rampr 20 13 dur) (random '(100 130)) dur))
     (if (*metre1* beat 2.0) (play piano (random 10 17) (random '(100 130)) dur))
             
   (callback (*metro* (+ beat (* 0.5 dur))) 'perc1 (+ beat dur) dur)
))

(perc1 (*metro* 'get-beat 1) 1/4)

(define metre-change
  (lambda (beat)
    (if (= (modulo beat 20) 0)
      (set! *subdiv* (random '(1/2 1/6))))

     (if (= (modulo beat 20) 5)
      (set! *subdiv* (random '(1/5 1/3))))

      (if (= (modulo beat 20) 15)
      (set! *subdiv* 1/4))

     (if (= (modulo beat 20) 17)
      (set! *subdiv* (random '(1/8 1))))


    (if (= (modulo beat 40) 0)
      (set! *metre1* (make-metre '(2 1 2 2 1 2 1 1 2 2 1 1 2) *subdiv*))
      (set! *metre2* (make-metre '( 1 1 1 2  ) *subdiv*))
      (set! *metre3* (make-metre '( 6 6 4 4 ) *subdiv*)))
 
    (if (= (modulo beat 40) 20)
      (set! *metre3* (make-metre '(2 1 2 2 1 2 1 1 2 2 1 1 2) *subdiv*))
      (set! *metre2* (make-metre '( 1 1 1 2  ) *subdiv*))
      (set! *metre1* (make-metre '( 6 6 4 4 ) *subdiv*)))
      ; (println *subdiv*)
   (callback (*metro* (+ beat 0.5)) 'metre-change (+ beat 1))))

(metre-change (*metro* 'get-beat 1) 1)

