(define-module (gnu packages fonts)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system font)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils))

(define-public font-b612
  (package
    (name "font-b612")
    (version "1.003")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/polarsys/b612/archive/" version ".tar.gz"))
              (sha256
               (base32
                "13xhv1f9dh9z19k3ynsl8dfpj4nvyzg2bhgp07zkxa4al6j2vawx"))))
    ;; As for Gentium (see above), the TTF files are considered source.
    (build-system font-build-system)
    (synopsis "Highly legible open source font family designed and tested to be used on aircraft cockpit screens.")
    (description
     "B612 is an highly legible open source font family designed and tested to be used on aircraft cockpit screens.
Main characteristics are:

    Maximize the distance between the forms of the characters
    Respect the primitives of the different letters
    Harmonize the forms and their spacing")
    (home-page "https://b612-font.com/")
    (license license:silofl1.1))) ;; TODO change license
