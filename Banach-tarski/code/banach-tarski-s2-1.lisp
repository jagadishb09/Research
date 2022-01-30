; Banach-Tarski theorem
;
; Proof of the Banach-Tarski theorem on S^2.
;
;
; Copyright (C) 2022 University of Wyoming
;
; License: A 3-clause BSD license.  See the LICENSE file distributed with ACL2.
;
; Main Author: Jagadish Bapanapally (jagadishb285@gmail.com)
;
; Contributing Author:
;   Ruben Gamboa (ruben@uwyo.edu)

(in-package "ACL2")

; cert_param: (uses-acl2r)

(include-book "nonstd/nsa/trig" :dir :system)
(include-book "hausdorff-paradox-2")
(include-book "countable-sets")

(defun rotation-3d (angle point)
  `((:header :dimensions (3 3)
             :maximum-length 10)
    ((0 . 0) . ,(+ (acl2-cosine angle)
                   (* (point-in-r3-x1 point) (point-in-r3-x1 point) (- 1 (acl2-cosine angle)))) )
    ((0 . 1) . ,(- (* (point-in-r3-x1 point) (point-in-r3-y1 point) (- 1 (acl2-cosine angle)))
                   (* (point-in-r3-z1 point) (acl2-sine angle))) )
    ((0 . 2) . ,(+ (* (point-in-r3-x1 point) (point-in-r3-z1 point) (- 1 (acl2-cosine angle)))
                   (* (point-in-r3-y1 point) (acl2-sine angle))) )
    ((1 . 0) . ,(+ (* (point-in-r3-y1 point) (point-in-r3-x1 point) (- 1 (acl2-cosine angle)))
                   (* (point-in-r3-z1 point) (acl2-sine angle))) )
    ((1 . 1) . ,(+ (acl2-cosine angle)
                   (* (point-in-r3-y1 point) (point-in-r3-y1 point) (- 1 (acl2-cosine angle)))) )
    ((1 . 2) . ,(- (* (point-in-r3-y1 point) (point-in-r3-z1 point) (- 1 (acl2-cosine angle)))
                   (* (point-in-r3-x1 point) (acl2-sine angle))) )
    ((2 . 0) . ,(- (* (point-in-r3-z1 point) (point-in-r3-x1 point) (- 1 (acl2-cosine angle)))
                   (* (point-in-r3-y1 point) (acl2-sine angle))) )
    ((2 . 1) . ,(+ (* (point-in-r3-z1 point) (point-in-r3-y1 point) (- 1 (acl2-cosine angle)))
                   (* (point-in-r3-x1 point) (acl2-sine angle))) )
    ((2 . 2) . ,(+ (acl2-cosine angle)
                   (* (point-in-r3-z1 point) (point-in-r3-z1 point) (- 1 (acl2-cosine angle)))) )
    )
  )

(defthmd rotation-about-witness-values
  (and (equal (aref2 :fake-name (rotation-3d angle point) 0 0)
              (+ (acl2-cosine angle)
                 (* (point-in-r3-x1 point) (point-in-r3-x1 point) (- 1 (acl2-cosine angle)))))
       (equal (aref2 :fake-name (rotation-3d angle point) 0 1)
              (- (* (point-in-r3-x1 point) (point-in-r3-y1 point) (- 1 (acl2-cosine angle)))
                 (* (point-in-r3-z1 point) (acl2-sine angle))))
       (equal (aref2 :fake-name (rotation-3d angle point) 0 2)
              (+ (* (point-in-r3-x1 point) (point-in-r3-z1 point) (- 1 (acl2-cosine angle)))
                 (* (point-in-r3-y1 point) (acl2-sine angle))))
       (equal (aref2 :fake-name (rotation-3d angle point) 1 0)
              (+ (* (point-in-r3-y1 point) (point-in-r3-x1 point) (- 1 (acl2-cosine angle)))
                 (* (point-in-r3-z1 point) (acl2-sine angle))))
       (equal (aref2 :fake-name (rotation-3d angle point) 1 1)
              (+ (acl2-cosine angle)
                 (* (point-in-r3-y1 point) (point-in-r3-y1 point) (- 1 (acl2-cosine angle)))))
       (equal (aref2 :fake-name (rotation-3d angle point) 1 2)
              (- (* (point-in-r3-y1 point) (point-in-r3-z1 point) (- 1 (acl2-cosine angle)))
                 (* (point-in-r3-x1 point) (acl2-sine angle))))
       (equal (aref2 :fake-name (rotation-3d angle point) 2 0)
              (- (* (point-in-r3-z1 point) (point-in-r3-x1 point) (- 1 (acl2-cosine angle)))
                 (* (point-in-r3-y1 point) (acl2-sine angle))))
       (equal (aref2 :fake-name (rotation-3d angle point) 2 1)
              (+ (* (point-in-r3-z1 point) (point-in-r3-y1 point) (- 1 (acl2-cosine angle)))
                 (* (point-in-r3-x1 point) (acl2-sine angle))))
       (equal (aref2 :fake-name (rotation-3d angle point) 2 2)
              (+ (acl2-cosine angle)
                 (* (point-in-r3-z1 point) (point-in-r3-z1 point) (- 1 (acl2-cosine angle)))))
       )
  :hints (("goal"
           :in-theory (enable aref2)
           ))
  )

(defthmd r3-matrixp-r3d
  (implies (and (realp angle)
                (point-in-r3 u))
           (r3-matrixp (rotation-3d angle u)))
  :hints (("goal"
           :in-theory (enable aref2 header dimensions array2p)
           )))

(encapsulate
  ()

  (local (include-book "arithmetic-5/top" :dir :system))

  (defthmd r3-m-det-lemma-2
    (implies (and (equal y z))
             (equal (+ x y) (+ x z))))

  (defthm r3-m-det-lemma-3
    (implies (and (realp x)
                  (equal (+ x y) 1))
             (equal x (- 1 y)))
    :rule-classes nil)

  (defthmd r3-m-det-lemma-5
     (implies (and (realp s)
                   (realp c)
                   (equal (+ (* s s) (* c c)) 1))
              (and (equal (* C S S X X) (- (* C X X) (* c c c x x)))
                   (equal (* S S X X X X) (- (* x x x x) (* c c x x x x)))
                   (equal (- (* C S S X X X X))
                          (+ (- (* c x x x x))
                             (* c c c x x x x))))))
  )



(encapsulate
  ()

  (local (include-book "arithmetic-5/top" :dir :system))

  (defthmd r3-m-det-lemma-4
    (implies (and (realp x)
                  (realp s)
                  (realp c)
                  (equal (+ (* s s) (* c c)) 1))
             (equal (+ (* c c)
                       (* C S S X X)
                       (* C X X)
                       (- (* C X X x x))
                       (- (* 2 C C X X))
                       (* 2 C C X X x x)
                       (* S S X X X X)
                       (* C C C X X)
                       (- (* C C C X X x x))
                       (- (* C S S X X X X)))
                    (+ (* c c) (* 2 c x x) (- (* 2 c c x x)) (- (* 2 c x x x x))
                       (* c c x x x x) (* x x x x))
                    ))
    :hints (("Goal"
             :use ((:instance r3-m-det-lemma-5 (s s) (c c))
                   )
             )))

  (defthmd r3-m-det-lemma-1
    (implies (and (realp x)
                  (realp y)
                  (realp z)
                  (realp s)
                  (realp c)
                  (equal (+ (* x x) (* y y) (* z z)) 1)
                  (equal (+ (* s s) (* c c)) 1))
             (and (equal (* (+ c (* x x (- 1 c)))
                            (- (* (+ c (* y y (- 1 c)))
                                  (+ c (* z z (- 1 c))))
                               (* (- (* y z (- 1 c)) (* x s))
                                  (+ (* z y (- 1 c))
                                     (* x s)))))
                         (+ (* c c)
                            (* C S S X X)
                            (* C X X y y)
                            (* C X X z z)
                            (- (* C C X X Y Y))
                            (- (* C C X X Y Y))
                            (- (* C C X X Z Z))
                            (- (* C C X X Z Z))
                            (* S S X X X X)
                            (* C C C X X Y Y)
                            (* C C C X X Z Z)
                            (- (* C S S X X X X))))
                  (equal (+ (* c c)
                            (* C S S X X)
                            (* C X X y y)
                            (* C X X z z)
                            (- (* C C X X Y Y))
                            (- (* C C X X Y Y))
                            (- (* C C X X Z Z))
                            (- (* C C X X Z Z))
                            (* S S X X X X)
                            (* C C C X X Y Y)
                            (* C C C X X Z Z)
                            (- (* C S S X X X X)))
                         (+ (* c c)
                            (* C S S X X)
                            (* C X X)
                            (- (* C X X x x))
                            (- (* C C X X Y Y))
                            (- (* C C X X Y Y))
                            (- (* C C X X Z Z))
                            (- (* C C X X Z Z))
                            (* S S X X X X)
                            (* C C C X X Y Y)
                            (* C C C X X Z Z)
                            (- (* C S S X X X X)))
                         )
                  (equal (+ (* c c)
                            (* C S S X X)
                            (* C X X)
                            (- (* C X X x x))
                            (- (* C C X X Y Y))
                            (- (* C C X X Y Y))
                            (- (* C C X X Z Z))
                            (- (* C C X X Z Z))
                            (* S S X X X X)
                            (* C C C X X Y Y)
                            (* C C C X X Z Z)
                            (- (* C S S X X X X)))

                         (+ (* c c)
                            (* C S S X X)
                            (* C X X)
                            (- (* C X X x x))
                            (- (* 2 C C X X))
                            (* 2 C C X X x x)
                            (* S S X X X X)
                            (* C C C X X Y Y)
                            (* C C C X X Z Z)
                            (- (* C S S X X X X)))
                         )

                  (equal (+ (* c c)
                            (* C S S X X)
                            (* C X X)
                            (- (* C X X x x))
                            (- (* 2 C C X X))
                            (* 2 C C X X x x)
                            (* S S X X X X)
                            (* C C C X X Y Y)
                            (* C C C X X Z Z)
                            (- (* C S S X X X X)))
                         (+ (* c c)
                            (* C S S X X)
                            (* C X X)
                            (- (* C X X x x))
                            (- (* 2 C C X X))
                            (* 2 C C X X x x)
                            (* S S X X X X)
                            (* C C C X X)
                            (- (* C C C X X x x))
                            (- (* C S S X X X X)))
                         )
                  ))
    :hints (("Goal"
             :use (
                   (:instance r3-m-det-lemma-2
                              (y (+ (* C C X X) (* C C Y Y) (* C C Z Z)))
                              (z (* c c))
                              (x (+ (* C C C)
                                    (- (* C C C X X))
                                    (- (* C C C Y Y))
                                    (- (* C C C Z Z))
                                    (* C S S X X)
                                    (* C X X Y Y)
                                    (* C X X Z Z)
                                    (- (* C C X X Y Y))
                                    (- (* C C X X Y Y))
                                    (- (* C C X X Z Z))
                                    (- (* C C X X Z Z))
                                    (* S S X X X X)
                                    (* C C C X X Y Y)
                                    (* C C C X X Z Z)
                                    (- (* C S S X X X X))))
                              )
                   (:instance r3-m-det-lemma-2
                              (y (+ (* C X X Y Y)
                                    (* C X X Z Z)))
                              (z (- (* c x x) (* c x x x x)))
                              (x (+ (* c c)
                                    (* C S S X X)
                                    (- (* C C X X Y Y))
                                    (- (* C C X X Y Y))
                                    (- (* C C X X Z Z))
                                    (- (* C C X X Z Z))
                                    (* S S X X X X)
                                    (* C C C X X Y Y)
                                    (* C C C X X Z Z)
                                    (- (* C S S X X X X)))))

                   (:instance r3-m-det-lemma-2
                              (y (+ (- (* C C X X Y Y))
                                    (- (* C C X X Y Y))
                                    (- (* C C X X Z Z))
                                    (- (* C C X X Z Z))))
                              (z (+ (- (* 2 c c x x)) (* 2 c c x x x x)))
                              (x (+ (* c c)
                                    (* C S S X X)
                                    (* C X X)
                                    (- (* C X X x x))
                                    (* S S X X X X)
                                    (* C C C X X Y Y)
                                    (* C C C X X Z Z)
                                    (- (* C S S X X X X)))))
                   )
             )))
  )

(defthmd r3-m-det-1
  (implies (and (realp x)
                (realp y)
                (realp z)
                (realp s)
                (realp c)
                (equal (+ (* x x) (* y y) (* z z)) 1)
                (equal (+ (* s s) (* c c)) 1))
           (equal (* (+ c (* x x (- 1 c)))
                     (- (* (+ c (* y y (- 1 c)))
                           (+ c (* z z (- 1 c))))
                        (* (- (* y z (- 1 c)) (* x s))
                           (+ (* z y (- 1 c))
                              (* x s)))))
                  (+ (* c c) (* 2 c x x) (- (* 2 c c x x)) (- (* 2 c x x x x))
                     (* c c x x x x) (* x x x x))))
  :hints (("Goal"
           :use ((:instance r3-m-det-lemma-1)
                 (:instance r3-m-det-lemma-4)
                 )
           )))

  (+ (* (aref2 :fake-name m 0 0) (- (* (aref2 :fake-name m 1 1) (aref2 :fake-name m 2 2))
                                    (* (aref2 :fake-name m 1 2) (aref2 :fake-name m 2 1))))
     (* (- (aref2 :fake-name m 0 1)) (- (* (aref2 :fake-name m 1 0) (aref2 :fake-name m 2 2))
                                        (* (aref2 :fake-name m 1 2) (aref2 :fake-name m 2 0))))
     (* (aref2 :fake-name m 0 2) (- (* (aref2 :fake-name m 1 0) (aref2 :fake-name m 2 1))
                                    (* (aref2 :fake-name m 1 1) (aref2 :fake-name m 2 0))))
     )