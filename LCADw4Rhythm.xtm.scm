;;;;; drums
;; define me first!
(define *metro* (make-metro 140))

(define *subdiv* 1/2)
(define *metre1* (make-metre '(8 4 2 2) *subdiv*))
(define *metre2* (make-metre '(6 3 2 1) *subdiv*))
(define *metre3* (make-metre '( 4 ) *subdiv*))
(define *metre4* (make-metre '( 4 2 1 1) 1/2))



(define *degree* 0.0)
(let ((vtk 0.0) (seconds 15))
  (set-signal! *degree* vtk seconds))

(set-signal! *kickVel* 0 15)

(define rampDegree
  (lambda (degree)
    (set! *degree* degree)
    (let ((vtk (- degree 10)) (seconds 0.3))
    (set-signal! *degree* vtk seconds))))

(rampDegree 43.0)

(define kit
  (lambda (beat dur)

      (cond ((*metre1* beat 1.0) (play edrums 10 140 dur))
            ((*metre1* beat 2.0) (play edrums 21 140 dur))
            ((*metre1* beat 3.0) (play edrums 23 130 dur))
            ((*metre1* beat 4.0) (play edrums 46 150 dur)))

      (cond ((*metre1* beat 1.0) (rampDegree 10.0))
            ((*metre2* beat 1.0) (rampDegree 21.0))
            ((*metre3* beat 3.0) (rampDegree 23.0))
            ((*metre3* beat 4.0) (rampDegree 46.0)))

      ; (play doumbek (cosr 20 10 dur) 140 dur)

    ; )

    ;(play doumbek (rampr 20 10 1/8) 140 dur)
    

   (callback (*metro* (+ beat (* 0.5 dur))) 'kit (+ beat dur) dur)
))


(kit (*metro* 'get-beat 1) 1/2) 




(define kit2
  (lambda (beat dur)
      (cond ((*metre2* beat 1.0) (play doumbek (random 10 15) 140 dur))
             ((*metre2* beat 2.0) (play doumbek (random 16 21) 100 dur))
             ((*metre2* beat 3.0) (play doumbek (random 22 35) 150 dur)))

      ;(play edrums (random 20 22) 100 dur)

    

   (callback (*metro* (+ beat (* 0.5 dur))) 'kit2 (+ beat dur) dur)
))

(kit2 (*metro* 'get-beat 1) 1/4)


(define perc1
  (lambda (beat dur)
      (if (*metre1* beat 3.0) (play conga (random 15 20) (random '(120 140)) dur))
      (if (*metre2* beat 2.0) (play djembe (random 10 15) (random '(120 140)) dur))
      ; (if (*metre1* beat 1.0) (play conga (random 15 20) (random '(100 120)) dur))
      ; (if (*metre1* beat 1.0) (play edrums 15 120 dur))
             
   (callback (*metro* (+ beat (* 0.5 dur))) 'perc1 (+ beat dur) dur)
))

(perc1 (*metro* 'get-beat 1) 1/4)

(define metre-change
  (lambda (beat)
    (if (= (modulo beat 40) 0)
      (set! *subdiv* (random '(1/2 1/6))))

     (if (= (modulo beat 40) 10)
      (set! *subdiv* (random '(1/5 1/3))))

      (if (= (modulo beat 40) 20)
      (set! *subdiv* 1/4))

     (if (= (modulo beat 40) 36)
      (set! *subdiv* (random '(1/8 1))))


    (if (= (modulo beat 80) 0)
      (set! *metre1* (make-metre '(2 1 2 2 1 2 1 1 2 2 1 1 2) *subdiv*))
      (set! *metre2* (make-metre '( 1 1 1 2  ) *subdiv*))
      (set! *metre3* (make-metre '( 6 6 4 4 ) *subdiv*)))
 
    (if (= (modulo beat 80) 40)
      (set! *metre3* (make-metre '(2 1 2 2 1 2 1 1 2 2 1 1 2) *subdiv*))
      (set! *metre1* (make-metre '( 1 1 1 2  ) *subdiv*))
      (set! *metre2* (make-metre '( 6 6 4 4 ) *subdiv*)))
      ; (println *subdiv*)
   (callback (*metro* (+ beat 0.5)) 'metre-change (+ beat 1))))

(metre-change (*metro* 'get-beat 1) 1)

