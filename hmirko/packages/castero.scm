(define-module (hmirko packages castero)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages python)
  #:use-module (gnu packages video)
  #:use-module (gnu packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python))

(define-public castero
  (package
    (name "castero")
    (version "0.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/xgi/castero/archive/v"
			   version
			   ".tar.gz"))
       (sha256
        (base32
         "0py0gnzbj590lynpln1x4sqnx2fch6l6p6yqmjz8rgnz94ghxcis"))))
    (build-system python-build-system)
    (inputs
     `(("mpv" ,mpv)
       ("python-mpv" ,python-mpv)
       ))
    (arguments
     `(#:tests? #f                      ;no tests
       ))
    (home-page "https://xgi.github.io/castero")
    (synopsis "castero is a TUI podcast client for the terminal")
    (description "castero is a TUI podcast client for the terminal. This version supports playback in mpv.")
    (license license:mit)))

(define-public python-mpv
  (package
    (name "python-mpv")
    (version "0.3.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/jaseg/python-mpv/archive/v"
			   version
			   ".tar.gz"))
       (sha256
        (base32
         "109c6wv9c0a77ha7v1nzcx4xagj84yjpa993rb32xx2hvz8mdsii"))))
    (build-system python-build-system)
    (inputs
     `(("mpv" ,mpv)
       ))
    (arguments
     `(#:tests? #f                      ;no tests
       ))
    (home-page "https://github.com/jaseg/python-mpv")
    (synopsis "Python interface to the awesome mpv media player")
    (description "Python interface to the awesome mpv media player")
    (license license:agpl3+)))
