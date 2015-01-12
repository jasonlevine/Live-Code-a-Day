;;;; Much of the content in this file is taken from various Extempore
;;;; blog posts by Ben Swift which are indexed here:
;;;;   http://benswift.me/extempore-docs/index.html
;;;;

;;; Load the needed libraries -- this will take several minutes
;;;

(sys:set-default-timeout (* 2 13953200))

(sys:load "libs/core/pc_ivl.xtm")
(sys:load "libs/external/instruments_ext.xtm")

;;; Set up the constants we're going to need
;;;
(define sample-path "/Users/jasonlevine/Code/extempore/assets/")
(define edrum-path (string-append sample-path "biolabsDubstepKit3/"))
(define conga-path (string-append sample-path "Conga/"))
(define djembe-path (string-append sample-path "Djembe/"))


;;; Add the samplers/instruments we're going to need to the dsp output
;;; callback
;;;
(define-sampler edrums sampler_note_hermite_c sampler_fx)
(define-sampler conga sampler_note_hermite_c sampler_fx)
(define-sampler djembe sampler_note_hermite_c sampler_fx)

(define-sampler piano sampler_note_hermite_c sampler_fx)


(bind-func dsp:DSP 1000000
  (lambda (in time chan dat)
    (cond ((< chan 2)
           (+ 
           (edrums in time chan dat) 

            (djembe in time chan dat)
            (conga in time chan dat)
             (piano in time chan dat)
           ))
          (else 0.0))))

(dsp:set! dsp)


;;; Set up e drum samples
;;;
(define add-edrum-sample
  (lambda (file-name const-name)
    (set-sampler-index edrums
                       (string-append edrum-path file-name)
                       const-name
                       0 0 0 1)))

(define edrum-sample-data
  (list
    (list "Dubstep-Kick0001.wav" 10)
    (list "Dubstep-Kick0005.wav" 11)
    (list "Dubstep-Kick0006.wav" 12)
    (list "Dubstep-Kick0007.wav" 13)
    (list "Dubstep-Kick0015.wav" 14)
    (list "Dubstep-Kick0018.wav" 15)
    (list "Dubstep-Kick0006.wav" 16)
    (list "Dubstep-Kick0007.wav" 17)
    (list "Dubstep-Kick0015.wav" 18)
    (list "Dubstep-Kick0018.wav" 19)
    (list "Dubstep-Hats0014.wav" 20)
    (list "Dubstep-Hats0017.wav" 22)
    (list "Dubstep-Hats0019.wav" 23)
    (list "Dubstep-Hats0020.wav" 24)
    (list "Dubstep-Hats0026.wav" 25)
    (list "Dubstep-Hats0039.wav" 26)
    (list "Dubstep-Cym0030.wav" 30)
    (list "Dubstep-Cym0035.wav" 31)
    (list "Dubstep-Snare0003.wav" 40)
    (list "Dubstep-Snare0008.wav" 41)
    (list "Dubstep-Snare0009.wav" 42)
    (list "Dubstep-Snare0010.wav" 43)
    (list "Dubstep-Snare0011.wav" 44)
    (list "Dubstep-Snare0013.wav" 45)
    (list "Dubstep-Snare0016.wav" 46)
    (list "Dubstep-Snare0022.wav" 47)
    (list "Dubstep-Snare0023.wav" 48)
    (list "Dubstep-Snare0025.wav" 49)
    (list "Dubstep-Snare0027.wav" 50)
    (list "Dubstep-Snare0029.wav" 51)
    (list "Dubstep-Snare0033.wav" 52)
    (list "Dubstep-Snare0036.wav" 53)
    (list "Dubstep-Snare0037.wav" 54)))


(play-note (now) edrums 12 180 44100)

(define add-edrum-samples
  (lambda (data)
    (map (lambda (sample-pair)
           (add-edrum-sample (car sample-pair) (cadr sample-pair)))
         data)))

(add-edrum-samples edrum-sample-data)


;;conga
(define add-conga-sample
  (lambda (file-name const-name)
    (set-sampler-index conga
                       (string-append conga-path file-name)
                       const-name
                       0 0 0 1)))

(define conga-sample-data
  (list
    (list "Single_Hit_01.wav" 10)
    (list "Single_Hit_02.wav" 11)
    (list "Single_Hit_03.wav" 12)
    (list "Single_Hit_04.wav" 13)
    (list "Single_Hit_05.wav" 14)
    (list "Single_Hit_06.wav" 15)
    (list "Single_Hit_07.wav" 16)
    (list "Single_Hit_08.wav" 17)
    (list "Single_Hit_09.wav" 18)
    (list "Single_Hit_10.wav" 19)
    (list "Single_Hit_11.wav" 20)
    (list "Single_Hit_12.wav" 21)
    (list "Single_Hit_13.wav" 22)
    (list "Single_Hit_14.wav" 23)
    (list "Single_Hit_15.wav" 24)))



(play-note (now) conga 24 180 44100)

(define add-conga-samples
  (lambda (data)
    (map (lambda (sample-pair)
           (add-conga-sample (car sample-pair) (cadr sample-pair)))
         data)))

(add-conga-samples conga-sample-data)



(define add-djembe-sample
  (lambda (file-name const-name)
    (set-sampler-index djembe
                       (string-append djembe-path file-name)
                       const-name
                       0 0 0 1)))

(define djembe-sample-data
  (list
    (list "Djembe_SingleHit01.wav" 10)
    (list "Djembe_SingleHit02.wav" 11)
    (list "Djembe_SingleHit03.wav" 12)
    (list "Djembe_SingleHit04.wav" 13)
    (list "Djembe_SingleHit05.wav" 14)
    (list "Djembe_SingleHit06.wav" 15)))
 


(play-note (now) djembe 10 180 44100)

(define add-djembe-samples
  (lambda (data)
    (map (lambda (sample-pair)
           (add-djembe-sample (car sample-pair) (cadr sample-pair)))
         data)))

(add-djembe-samples djembe-sample-data)


;;; Set up piano samples
;;;
(define piano-regex "^.*([ABCDEFG][#b]?[0-9])v([0-9]+)\.wav$")

(define parse-salamander-piano
  (lambda (file-list)
    (map (lambda (fname)
           (let ((result (regex:matched fname piano-regex)))
             (if (null? result)
                 #f
                 ;; load 4th velocity layer only
                 (if (= (string->number (caddr result)) 4)
                     (list fname
                           (note-name-to-midi-number (cadr result))
                           0
                           0)
                     #f))))
         file-list)))

(load-sampler
  piano
  ;; Can't use a variable here; need the actual path string
  "/Users/jasonlevine/Code/extempore/LCAD/salamander/SalamanderGrandPianoV3_44.1khz16bit/44.1khz16bit"
  ;; 'sound bank' index
  0
  parse-salamander-piano)



;; Now that everything is loaded, try out some notes ...
(play-note (now) conga 15 90 44100)
(play-note (now) piano 24 180 44100)


