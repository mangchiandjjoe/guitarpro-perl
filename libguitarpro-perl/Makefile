test:
	set -e; for f in `find GuitarPro -name '*.pm'`; do perl -c $$f; done
	perl -c gpcheck
	prove t/*.t
	mkdir -p man
	pod2man gpcheck man/gpcheck.1

install:
	mkdir -p $(DESTDIR)/usr/bin/
	cp gpcheck $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/perl5
	cp -r GuitarPro $(DESTDIR)/usr/share/perl5/

clean:
	rm -rf man
