#!/usr/local/bin/gosh

(use gauche.test)

(load "lib/dir.scm")
(load "lib/rx.scm")

(test-section "files")

(test-end :exit-on-failure #t)