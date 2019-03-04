(define-module (hmirko packages web-browser)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages fltk)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages image)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages gcc)
  #:use-module (guix download)
  #:use-module (guix build-system python))

(define-public qutebrowser-new
  (package
    (name "qutebrowser-new")
    (version "1.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/The-Compiler/qutebrowser/archive/v"
			   version
			   ".tar.gz"))
       (sha256
        (base32
         "1bj8yaqkm6z7p1ic4713zac9n75hfr30g1k3mdl9axj1mvn3hp37"))))
    (build-system python-build-system)
    (native-inputs
     `(("asciidoc" ,asciidoc)))
    (inputs
     `(("python-attrs" ,python-attrs)
       ("python-colorama" ,python-colorama)
       ("python-cssutils" ,python-cssutils)
       ("python-jinja2" ,python-jinja2)
       ("python-markupsafe" ,python-markupsafe)
       ("python-pygments" ,python-pygments)
       ("python-pypeg2" ,python-pypeg2)
       ("python-pyyaml" ,python-pyyaml)
       ("python-pyqt" ,python-pyqt)
       ("qt" ,qt-with-qtwebengine)))
    (arguments
     `(#:tests? #f                      ;no tests
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'install-more
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (app (string-append out "/share/applications"))
                    (hicolor (string-append out "/share/icons/hicolor")))
               (invoke "a2x" "-f" "manpage" "doc/qutebrowser.1.asciidoc")
               (install-file "doc/qutebrowser.1"
                             (string-append out "/share/man/man1"))

               (for-each
                (lambda (i)
                  (let ((src  (format #f "icons/qutebrowser-~dx~d.png" i i))
                        (dest (format #f "~a/~dx~d/apps/qutebrowser.png"
                                      hicolor i i)))
                    (mkdir-p (dirname dest))
                    (copy-file src dest)))
                '(16 24 32 48 64 128 256 512))
               (install-file "icons/qutebrowser.svg"
                             (string-append hicolor "/scalable/apps"))
               
               (substitute* "misc/qutebrowser.desktop"
                 (("Exec=qutebrowser")
                  (string-append "Exec=" out "/bin/qutebrowser")))
               (install-file "misc/qutebrowser.desktop" app)
               #t))))))
    (home-page "https://qutebrowser.org/")
    (synopsis "Minimal, keyboard-focused, vim-like web browser")
    (description "qutebrowser is a keyboard-focused browser with a minimal
GUI.  It is based on PyQt5 and QtWebKit.")
    (license license:gpl3+)))


(define-public qt-with-qtwebengine
  (package
    (name "qt-with-qtwebengine")
    (version "5.11.3")
    (outputs '("out" "examples"))
    (source (origin
             (method url-fetch)
             (uri
               (string-append
                 "http://download.qt.io/official_releases/qt/"
                 (version-major+minor version)
                 "/" version
                 "/single/qt-everywhere-src-"
                 version ".tar.xz"))
             (sha256
              (base32
               "0kgzy32s1fr22fxxfhcyncfryb3qxrznlr737r4y5khk4xj1g545"))
             (modules '((guix build utils)))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("mesa" ,mesa)))
    (inputs
     `(("alsa-lib" ,alsa-lib)
       ("bluez" ,bluez)
       ("cups" ,cups)
       ("dbus" ,dbus)
       ("double-conversion" ,double-conversion)
       ("expat" ,expat)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("glib" ,glib)
       ("gstreamer" ,gstreamer)
       ("gst-plugins-base" ,gst-plugins-base)
       ("harfbuzz" ,harfbuzz)
       ("icu4c" ,icu4c)
       ("jasper" ,jasper)
       ("libinput" ,libinput-minimal)
       ("libjpeg" ,libjpeg)
       ("libmng" ,libmng)
       ("libpci" ,pciutils)
       ("libpng" ,libpng)
       ("libtiff" ,libtiff)
       ("libwebp" ,libwebp)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)
       ("libxcursor" ,libxcursor)
       ("libxext" ,libxext)
       ("libxfixes" ,libxfixes)
       ("libxi" ,libxi)
       ("libxinerama" ,libxinerama)
       ("libxkbcommon" ,libxkbcommon)
       ("libxml2" ,libxml2)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxslt" ,libxslt)
       ("libxtst" ,libxtst)
       ("mtdev" ,mtdev)
       ("mariadb" ,mariadb)
       ("nss" ,nss)
       ("openssl" ,openssl)
       ("postgresql" ,postgresql)
       ("pulseaudio" ,pulseaudio)
       ("pcre2" ,pcre2)
       ("sqlite" ,sqlite-with-column-metadata)
       ("udev" ,eudev)
       ("unixodbc" ,unixodbc)
       ("wayland" ,wayland)
       ("xcb-util" ,xcb-util)
       ("xcb-util-image" ,xcb-util-image)
       ("xcb-util-keysyms" ,xcb-util-keysyms)
       ("xcb-util-renderutil" ,xcb-util-renderutil)
       ("xcb-util-wm" ,xcb-util-wm)
       ("zlib" ,zlib)))
    (native-inputs
     `(("bison" ,bison)
       ("flex" ,flex)
       ("gperf" ,gperf)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python-2)
       ("ruby" ,ruby)
       ("vulkan-headers" ,vulkan-headers)
       ("which" ,(@ (gnu packages base) which))))
    (arguments
     `(#:parallel-build? #f ; Triggers race condition in qtbase module on Hydra.
       #:phases
       (modify-phases %standard-phases
         (add-after 'configure 'patch-bin-sh
           (lambda _
             (substitute* '("qtbase/configure"
                            "qtbase/mkspecs/features/qt_functions.prf"
                            "qtbase/qmake/library/qmakebuiltins.cpp")
                          (("/bin/sh") (which "sh")))
             #t))
         (replace 'configure
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out      (assoc-ref outputs "out"))
                   (examples (assoc-ref outputs "examples")))
               (substitute* '("configure" "qtbase/configure")
                 (("/bin/pwd") (which "pwd")))
               (substitute* "qtbase/src/corelib/global/global.pri"
                 (("/bin/ls") (which "ls")))
               ;; do not pass "--enable-fast-install", which makes the
               ;; configure process fail
               (invoke
                 "./configure"
                 "-verbose"
                 "-prefix" out
                 "-docdir" (string-append out "/share/doc/qt5")
                 "-headerdir" (string-append out "/include/qt5")
                 "-archdatadir" (string-append out "/lib/qt5")
                 "-datadir" (string-append out "/share/qt5")
                 "-examplesdir" (string-append
                                  examples "/share/doc/qt5/examples") ; 151MiB
                 "-opensource"
                 "-confirm-license"

                 ;; These features require higher versions of Linux than the
                 ;; minimum version of the glibc.  See
                 ;; src/corelib/global/minimum-linux_p.h.  By disabling these
                 ;; features Qt5 applications can be used on the oldest
                 ;; kernels that the glibc supports, including the RHEL6
                 ;; (2.6.32) and RHEL7 (3.10) kernels.
                 "-no-feature-getentropy"  ; requires Linux 3.17
                 "-no-feature-renameat2"   ; requires Linux 3.16

                 ;; Do not build examples; for the time being, we
                 ;; prefer to save the space and build time.
                 "-no-compile-examples"
                 ;; Most "-system-..." are automatic, but some use
                 ;; the bundled copy by default.
                 "-system-sqlite"
                 "-system-harfbuzz"
                 "-system-pcre"
                 ;; explicitly link with openssl instead of dlopening it
                 "-openssl-linked"
                 ;; explicitly link with dbus instead of dlopening it
                 "-dbus-linked"
                 ;; don't use the precompiled headers
                 "-no-pch"
                 ;; drop special machine instructions not supported
                 ;; on all instances of the target
                 ,@(if (string-prefix? "x86_64"
                                       (or (%current-target-system)
                                           (%current-system)))
                       '()
                       '("-no-sse2"))
                 "-no-mips_dsp"
                 "-no-mips_dspr2"))))
           (add-after 'install 'patch-mkspecs
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (archdata (string-append out "/lib/qt5"))
                      (mkspecs (string-append archdata "/mkspecs"))
                      (qt_config.prf (string-append
                                      mkspecs "/features/qt_config.prf")))
                 ;; For each Qt module, let `qmake' uses search paths in the
                 ;; module directory instead of all in QT_INSTALL_PREFIX.
                 (substitute* qt_config.prf
                   (("\\$\\$\\[QT_INSTALL_HEADERS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../include/qt5))")
                   (("\\$\\$\\[QT_INSTALL_LIBS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../lib))")
                   (("\\$\\$\\[QT_HOST_LIBS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../lib))")
                   (("\\$\\$\\[QT_INSTALL_BINS\\]")
                    "$$clean_path($$replace(dir, mkspecs/modules, ../../bin))"))

                 ;; Searches Qt tools in the current PATH instead of QT_HOST_BINS.
                 (substitute* (string-append mkspecs "/features/qt_functions.prf")
                   (("cmd = \\$\\$\\[QT_HOST_BINS\\]/\\$\\$2")
                    "cmd = $$system(which $${2}.pl 2>/dev/null || which $${2})"))

                 ;; Resolve qmake spec files within qtbase by absolute paths.
                 (substitute*
                     (map (lambda (file)
                            (string-append mkspecs "/features/" file))
                          '("device_config.prf" "moc.prf" "qt_build_config.prf"
                            "qt_config.prf" "winrt/package_manifest.prf"))
                   (("\\$\\$\\[QT_HOST_DATA/get\\]") archdata)
                   (("\\$\\$\\[QT_HOST_DATA/src\\]") archdata))
                 #t)))
           (add-after 'unpack 'patch-paths
             ;; Use the absolute paths for dynamically loaded libs, otherwise
             ;; the lib will be searched in LD_LIBRARY_PATH which typically is
             ;; not set in guix.
             (lambda* (#:key inputs #:allow-other-keys)
               ;; libresolve
               (let ((glibc (assoc-ref inputs ,(if (%current-target-system)
                                                   "cross-libc" "libc"))))
                 (substitute* '("qtbase/src/network/kernel/qdnslookup_unix.cpp"
                                "qtbase/src/network/kernel/qhostinfo_unix.cpp")
                   (("^\\s*(lib.setFileName\\(QLatin1String\\(\")(resolv\"\\)\\);)" _ a b)
                  (string-append a glibc "/lib/lib" b))))
               ;; X11/locale (compose path)
               (substitute* "qtbase/src/plugins/platforminputcontexts/compose/generator/qtablegenerator.cpp"
                 ;; Don't search in /usr/…/X11/locale, …
                 (("^\\s*m_possibleLocations.append\\(QStringLiteral\\(\"/usr/.*/X11/locale\"\\)\\);" line)
                  (string-append "// " line))
                 ;; … but use libx11's path
                 (("^\\s*(m_possibleLocations.append\\(QStringLiteral\\()X11_PREFIX \"(/.*/X11/locale\"\\)\\);)" _ a b)
                  (string-append a "\"" (assoc-ref inputs "libx11") b)))
               ;; libGL
               (substitute* "qtbase/src/plugins/platforms/xcb/gl_integrations/xcb_glx/qglxintegration.cpp"
                 (("^\\s*(QLibrary lib\\(QLatin1String\\(\")(GL\"\\)\\);)" _ a b)
                  (string-append a (assoc-ref inputs "mesa") "/lib/lib" b)))
               ;; libXcursor
               (substitute* "qtbase/src/plugins/platforms/xcb/qxcbcursor.cpp"
                 (("^\\s*(QLibrary xcursorLib\\(QLatin1String\\(\")(Xcursor\"\\), 1\\);)" _ a b)
                  (string-append a (assoc-ref inputs "libxcursor") "/lib/lib" b))
                 (("^\\s*(xcursorLib.setFileName\\(QLatin1String\\(\")(Xcursor\"\\)\\);)" _ a b)
                  (string-append a (assoc-ref inputs "libxcursor") "/lib/lib" b)))
               #t)))))
      (native-search-paths
       (list (search-path-specification
              (variable "QMAKEPATH")
              (files '("lib/qt5")))
             (search-path-specification
              (variable "QML2_IMPORT_PATH")
              (files '("lib/qt5/qml")))
             (search-path-specification
              (variable "QT_PLUGIN_PATH")
              (files '("lib/qt5/plugins")))
             (search-path-specification
              (variable "XDG_DATA_DIRS")
              (files '("share")))
             (search-path-specification
              (variable "XDG_CONFIG_DIRS")
              (files '("etc/xdg")))))
      (home-page "https://www.qt.io/")
      (synopsis "Cross-platform GUI library")
      (description "Qt is a cross-platform application and UI framework for
  developers using C++ or QML, a CSS & JavaScript like language.")
      (license (list license:lgpl2.1 license:lgpl3))

    ;; Qt 4: 'QBasicAtomicPointer' leads to build failures on MIPS;
    ;; see <http://hydra.gnu.org/build/112828>.
    ;; Qt 5: assembler error; see <http://hydra.gnu.org/build/112526>.
    (supported-systems (delete "mips64el-linux" %supported-systems))))
