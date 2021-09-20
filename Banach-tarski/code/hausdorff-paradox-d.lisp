
(in-package "ACL2")

(include-book "hausdorff-paradox")

(defthmd disjoint-lemmas-1-1
  (implies (m-= (m-* m1 m2) (m-* m3 m4))
           (m-= (m-* (m-* m5 m1) m2)
                (m-* (m-* m5 m3) m4))))

(defthmd disjoint-lemmas-1-2
  (implies (and (m-= (m-* (m-* inv-y x) p)
                     (m-* (m-* inv-y y) q))
                (m-= (m-* inv-y x) c-inv-y-x)
                (m-= (m-* inv-y y) id)
                (m-= (m-* id q) q))
           (m-= q (m-* c-inv-y-x p))))

(defthmd disjoint-lemmas-1
  (implies (and (reducedwordp x)
                (reducedwordp y)
                (point-in-r3 p)
                (point-in-r3 q)
                (m-= (m-* (rotation x (acl2-sqrt 2)) p)
                     (m-* (rotation y (acl2-sqrt 2)) q)))
           (m-= q (m-* (rotation (compose (word-inverse y) x) (acl2-sqrt 2)) p)))
  :hints (("goal"
           :use ((:instance disjoint-lemmas-1-1
                            (m1 (rotation x (acl2-sqrt 2)))
                            (m3 (rotation y (acl2-sqrt 2)))
                            (m2 p)
                            (m4 q)
                            (m5 (rotation (word-inverse y) (acl2-sqrt 2))))
                 (:instance rot-a*rot-b-= (a (word-inverse y))
                            (b x)
                            (x (acl2-sqrt 2)))
                 (:instance rot-a*rot-b-= (a (word-inverse y))
                            (b y)
                            (x (acl2-sqrt 2)))
                 (:instance reducedwordp-word-inverse (x y))
                 (:instance reduced-inverse (x (word-inverse y)))
                 (:instance inv-inv-x=x (x y))
                 (:instance reducedwordp=>weak-wordp (x y))
                 (:instance rotation (w nil) (x (acl2-sqrt 2)))
                 (:instance m-*point-id=point (p1 q))
                 (:instance disjoint-lemmas-1-2 (inv-y (rotation (word-inverse y) (acl2-sqrt 2)))
                            (x (rotation x (acl2-sqrt 2)))
                            (p p)
                            (q q)
                            (y (rotation y (acl2-sqrt 2)))
                            (c-inv-y-x (rotation (compose (word-inverse y) x) (acl2-sqrt 2)))
                            (id (id-rotation)))
                 )
           :in-theory nil
           )))

(defthmd disjoint-lemmas-2
  (implies (and (reducedwordp wx)
                (reducedwordp wy)
                (reducedwordp wa)
                (reducedwordp wb)
                (equal (choice-set-s2-d-p p1) cp1)
                (equal (choice-set-s2-d-p p2) cp2)
                (s2-d-p p1)
                (s2-d-p p2)
                (point-in-r3 p)
                (m-= (m-* (rotation wa (acl2-sqrt 2)) cp1) p)
                (m-= (m-* (rotation wb (acl2-sqrt 2)) cp2) p)
                (m-= (m-* (rotation wx (acl2-sqrt 2)) p1) cp1)
                (m-= (m-* (rotation wy (acl2-sqrt 2)) p2) cp2))
           (and (orbit-point-p-q cp1 p2)
                (orbit-point-p-q cp2 p1)
                (orbit-point-p-q p1 p1)
                (orbit-point-p-q p2 p2)
                (orbit-point-p-q p p)))
  :hints (("goal"
           :use ((:instance orbit-point-p-q-suff (point p) (o-point p) (w nil))
                 (:instance rotation (w nil) (x (acl2-sqrt 2)))
                 (:instance m-*point-id=point (p1 p))
                 (:instance orbit-point-p-q-suff (point p1) (o-point p1) (w nil))
                 (:instance m-*point-id=point (p1 p1))
                 (:instance orbit-point-p-q-suff (point p2) (o-point p2) (w nil))
                 (:instance m-*point-id=point (p1 p2))
                 (:instance choice-set-s2-d-p-rewrite (o-p p) (p p))
                 (:instance disjoint-lemmas-1 (x wa) (y wb) (p cp1) (q cp2))
                 (:instance disjoint-lemmas-1 (x wy) (y (compose (word-inverse wb) wa)) (p p2) (q cp1))
                 (:instance disjoint-lemmas-1 (x wb) (y wa) (p cp2) (q cp1))
                 (:instance disjoint-lemmas-1 (x wx) (y (compose (word-inverse wa) wb)) (p p1) (q cp2))
                 (:instance s2-d-p-equiv-2-lemma2 (w nil))
                 (:instance s2-d-p (point p1))
                 (:instance s2-def-p (point p1))
                 (:instance s2-d-p (point p2))
                 (:instance s2-def-p (point p2))
                 (:instance choice-set-s2-d-p-rewrite (o-p p1) (p p1))
                 (:instance choice-set-s2-d-p-rewrite (o-p p2) (p p2))
                 (:instance reducedwordp-word-inverse (x wa))
                 (:instance reducedwordp-word-inverse (x wb))
                 (:instance closure-prop (x (word-inverse wb)) (y wa))
                 (:instance closure-prop (x (word-inverse wa)) (y wb))
                 (:instance orbit-point-p-q-suff (o-point (choice-set-s2-d-p p2))
                            (point p1)
                            (w (compose (word-inverse (compose (word-inverse wa) wb))
                                        wx)))
                 (:instance reducedwordp-word-inverse (x (compose (word-inverse wa) wb)))
                 (:instance closure-prop (x (word-inverse (compose (word-inverse wa) wb)))
                            (y wx))
                 (:instance orbit-point-p-q-suff (o-point (choice-set-s2-d-p p1))
                            (point p2)
                            (w (compose (word-inverse (compose (word-inverse wb) wa))
                                        wy)))
                 (:instance reducedwordp-word-inverse (x (compose (word-inverse wb) wa)))
                 (:instance closure-prop (x (word-inverse (compose (word-inverse wb) wa)))
                            (y wy))
                 )
           :in-theory nil
           )))

(defthmd disjoint-lemmas-3
  (implies (and (orbit-point-p-q (choice-set-s2-d-p p1) p2)
                (orbit-point-p-q (choice-set-s2-d-p p2) p1))
           (equal (choice-set-s2-d-p p1) (choice-set-s2-d-p p2)))
  :hints (("goal"
           :use ((:instance choice-set-s2-d-p (c-point (choice-set-s2-d-p p1)) (p p1))
                 (:instance choice-set-s2-d-p (c-point (choice-set-s2-d-p p2)) (p p2)))
           :in-theory nil
           )))

(defthmd disjoint-lemmas-4-1
  (implies (equal x y)
           (equal (compose z x) (compose z y))))

(defthmd disjoint-lemmas-4-2
  (implies (reducedwordp x)
           (equal (compose nil x) x))
  :hints (("Goal"
           :use ((:instance word-fix=reducedwordp (x x)))
           )))

(defthmd disjoint-lemmas-4-3
  (implies (reducedwordp y)
           (equal (compose y nil) y))
  :hints (("Goal"
           :use ((:instance word-fix=reducedwordp (x y)))
           )))

(defthmd disjoint-lemmas-4
  (implies (and (a-wordp x)
                (b-wordp y))
           (not (equal (compose (word-inverse y) x) nil)))
  :hints (("Goal"
           :use ((:instance assoc-prop (x y) (y (word-inverse y)) (z x))
                 (:instance reducedwordp-word-inverse (x y))
                 (:instance reduced-inverse (x y))
                 (:instance s2-d-p-equiv-2-lemma2 (w y))
                 (:instance s2-d-p-equiv-2-lemma2 (w x))
                 (:instance a-wordp-equivalent (a x))
                 (:instance disjoint-lemmas-4-2)
                 (:instance disjoint-lemmas-4-3)
                 (:instance disjoint-lemmas-4-1 (x (compose (word-inverse y) x)) (y nil)))
           :in-theory nil
           )))

(defthmd disjoint-lemmas-5
  (implies (and (s2-def-p p)
                (word-exists p))
           (d-p p)))

(defthmd disjoint-lemmas-6
  (implies (and (reducedwordp x)
                (reducedwordp y)
                (point-in-r3 p)
                (point-in-r3 q)
                (m-= (m-* (rotation x (acl2-sqrt 2)) p)
                     (m-* (rotation y (acl2-sqrt 2)) q)))
           (m-= (m-* (rotation (compose (word-inverse y) x) (acl2-sqrt 2)) p) q))
  :hints (("goal"
           :use (:instance disjoint-lemmas-1)
           )))

(defthmd dijoint-1
  (implies (diff-a-s2-d-p p)
           (not (diff-b-s2-d-p p)))
  :hints (("goal"
           :use (
                 (:instance disjoint-lemmas-4 (y (diff-b-s2-d-p-q-1-witness
                                                  (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                                  p))
                            (x (diff-a-s2-d-p-q-1-witness
                                (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                p)))
                 (:instance diff-a-s2-d-p (p p))
                 (:instance diff-a-s2-d-p-q-equiv (p p))
                 (:instance diff-a-s2-d-p-q-1-equiv (cp1 (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p)))
                            (p p))
                 (:instance diff-b-s2-d-p (p p))
                 (:instance diff-b-s2-d-p-q-equiv (p p))
                 (:instance diff-b-s2-d-p-q-1-equiv (cp1 (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p)))
                            (p p))
                 (:instance disjoint-lemmas-2
                            (wx (orbit-point-p-q-witness (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                         (diff-a-s2-d-p-q-witness p)))
                            (wy (orbit-point-p-q-witness (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                                         (diff-b-s2-d-p-q-witness p)))
                            (wa (diff-a-s2-d-p-q-1-witness (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                           p))
                            (wb (diff-b-s2-d-p-q-1-witness (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                                           p))
                            (p1 (diff-a-s2-d-p-q-witness p))
                            (cp1 (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p)))
                            (p2 (diff-b-s2-d-p-q-witness p))
                            (cp2 (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p)))
                            (p p))
                 (:instance choice-set-s2-d-p-rewrite
                            (o-p (diff-a-s2-d-p-q-witness p))
                            (p (diff-a-s2-d-p-q-witness p)))
                 (:instance s2-d-p (point (diff-a-s2-d-p-q-witness p)))
                 (:instance s2-def-p (point (diff-a-s2-d-p-q-witness p)))
                 (:instance rotation (w nil) (x (acl2-sqrt 2)))
                 (:instance m-*point-id=point (p1 (diff-a-s2-d-p-q-witness p)))
                 (:instance orbit-point-p-q-suff (point (diff-a-s2-d-p-q-witness p)) (o-point (diff-a-s2-d-p-q-witness p)) (w nil))
                 (:instance s2-d-p-equiv-2-lemma2 (w nil))
                 (:instance orbit-point-p-q-equiv
                            (o-p (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p)))
                            (p (diff-a-s2-d-p-q-witness p)))
                 (:instance s2-d-p-equiv-2-lemma2 (w (diff-b-s2-d-p-q-1-witness
                                                      (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                                      p)))
                 (:instance s2-d-p-equiv-2-lemma2 (w (diff-a-s2-d-p-q-1-witness
                                                      (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                      p)))

                 (:instance choice-set-s2-d-p-rewrite
                            (o-p (diff-b-s2-d-p-q-witness p))
                            (p (diff-b-s2-d-p-q-witness p)))
                 (:instance s2-d-p (point (diff-b-s2-d-p-q-witness p)))
                 (:instance s2-def-p (point (diff-b-s2-d-p-q-witness p)))
                 (:instance rotation (w nil) (x (acl2-sqrt 2)))
                 (:instance m-*point-id=point (p1 (diff-b-s2-d-p-q-witness p)))
                 (:instance orbit-point-p-q-suff (point (diff-b-s2-d-p-q-witness p)) (o-point (diff-b-s2-d-p-q-witness p)) (w nil))
                 (:instance s2-d-p-equiv-2-lemma2 (w nil))
                 (:instance orbit-point-p-q-equiv
                            (o-p (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p)))
                            (p (diff-b-s2-d-p-q-witness p)))
                 (:instance disjoint-lemmas-3 (p1 (diff-a-s2-d-p-q-witness p))
                            (p2 (diff-b-s2-d-p-q-witness p)))
                 (:instance s2-d-p=>p (w (diff-a-s2-d-p-q-1-witness
                                          (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                          p))
                            (point (diff-a-s2-d-p-q-witness p)))
                 (:instance s2-def-p-p=>p1 (p (m-*
                                               (rotation
                                                (orbit-point-p-q-witness (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                                         (diff-a-s2-d-p-q-witness p))
                                                (acl2-sqrt 2))
                                               (diff-a-s2-d-p-q-witness p)))
                            (p1 (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))))
                 (:instance s2-d-p=>p (w (orbit-point-p-q-witness (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                                  (diff-a-s2-d-p-q-witness p)))
                            (point (diff-a-s2-d-p-q-witness p)))
                 (:instance s2-d-p (point (m-*
                                           (rotation
                                            (orbit-point-p-q-witness (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                                     (diff-a-s2-d-p-q-witness p))
                                            (acl2-sqrt 2))
                                           (diff-a-s2-d-p-q-witness p))))
                 (:instance s2-def-p (point (m-*
                                             (rotation
                                              (orbit-point-p-q-witness (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                                       (diff-a-s2-d-p-q-witness p))
                                              (acl2-sqrt 2))
                                             (diff-a-s2-d-p-q-witness p))))
                 (:instance d-p-p=>d-p-p1-1 (p (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p)))
                            (p1 (m-*
                                 (rotation
                                  (orbit-point-p-q-witness (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                                           (diff-a-s2-d-p-q-witness p))
                                  (acl2-sqrt 2))
                                 (diff-a-s2-d-p-q-witness p))))
                 (:instance s2-def-p-equiv (p (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))))
                 (:instance word-exists-suff
                            (w (compose (word-inverse (diff-b-s2-d-p-q-1-witness
                                                       (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                                       p))
                                        (diff-a-s2-d-p-q-1-witness
                                         (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                         p)))
                            (point (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))))
                 (:instance closure-prop (x (word-inverse (diff-b-s2-d-p-q-1-witness
                                                           (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                                           p)))
                            (y (diff-a-s2-d-p-q-1-witness
                                (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                p)))
                 (:instance reducedwordp-word-inverse
                            (x (diff-b-s2-d-p-q-1-witness
                                (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                p)))
                 (:instance disjoint-lemmas-6
                            (y (diff-b-s2-d-p-q-1-witness
                                (choice-set-s2-d-p (diff-b-s2-d-p-q-witness p))
                                p))
                            (x (diff-a-s2-d-p-q-1-witness
                                (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))
                                p))
                            (p (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p)))
                            (q (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))))
                 (:instance disjoint-lemmas-5 (p (choice-set-s2-d-p (diff-a-s2-d-p-q-witness p))))

                 )
           :in-theory nil
           )))
