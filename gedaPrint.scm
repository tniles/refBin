;; $Id$
;;
;; This file may be used to print gschem schematics from the
;; command line.  Typical usage is:
;;
;;   gschem -p -o mySch.ps -s /path/to/this/file/print.scm mySch.sch
;;
;; The schematic in "mysch.sch" will be printed to the file "mysch.ps"

;; Uncomment these to override defaults when printing from the command line
(paper-size 17.0 11.0)
(output-orientation "landscape")
(output-type "extents")
;(output-color "enabled")
;(output-text "ps")

;(print-command "gs")

; You need call this after you call any rc file function
(gschem-use-rc-values)

; filename is specified on the command line
(gschem-postscript "dummyfilename")

(gschem-exit)
