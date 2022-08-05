#!/usr/local/bin/gosh

(use gauche.test)

(test-section "files")

(load "files.scm")

(test-end :exit-on-failure #t)