(bind-func osc_c ; osc_c is the same as last time
  (lambda (phase)
    (lambda (amp freq)
      (let ((inc:SAMPLE (* 3.141592 (* 2.0 (/ freq 44100.0)))))
        (set! phase (+ phase inc))
        (* amp (sin phase))))))

; remember that the dsp closure is called for every sample
; also, for convenience, let's make a type signature for the
; DSP closure

(bind-alias DSP [SAMPLE,SAMPLE,i64,i64,SAMPLE*]*)

(bind-func dsp:DSP ; note the use of the type signature 'DSP'
  (let ((osc1 (osc_c 0.0))
        (osc2 (osc_c 0.0))
        (osc3 (osc_c 0.0)))
    (lambda (in time channel data)
      (cond ((= channel 1) 
             (+ (osc1 0.5 220.0)
                (osc2 0.5 350.0)))
            ((= channel 0)
             (osc3 0.5 210.0))
            (else 0.0)))))