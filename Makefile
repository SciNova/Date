PYPI_TOKEN ?= ~/pypi.txt

VERSION := 0.$(shell git rev-list --count HEAD)

.PHONY: pip install-pip upload clean deb deb-termux

pip:
	rm -rf build
	mkdir -p build
	cp date.py __init__.py pip/pyproject.toml LICENSE build/
	( cd build && python3 -m build --outdir . )

install-pip:
	python3 -m pip install build/*.whl

upload:
	TWINE_USERNAME=__token__ TWINE_PASSWORD=$$(cat $(PYPI_TOKEN)) twine upload build/*.whl build/*.tar.gz

deb:
	rm -rf build/staging/deb/python-date
	rm -rf build/*.whl build/*.tar.gz
	mkdir -p build
	cp date.py __init__.py pip/pyproject.toml LICENSE build/
	( cd build && python3 -m build --wheel --outdir . )
	python3 -m pip install --root=build/staging/deb/python-date --prefix=/usr build/*.whl
	mkdir -p build/staging/deb/python-date/usr/share/doc/python-date
	cp LICENSE README.md build/staging/deb/python-date/usr/share/doc/python-date/
	mkdir -p build/staging/deb/python-date/DEBIAN
	chmod 755 build/staging/deb/python-date/DEBIAN
	sed -e 's/@VERSION@/$(VERSION)/' \
	    -e "s/@SIZE@/$$(du -sk build/staging/deb/python-date | cut -f1)/" \
	    -e 's/@DEPENDS@/python3/' \
	    -e 's/@ARCH@/all/' \
	    debian/control.in > build/staging/deb/python-date/DEBIAN/control
	echo "" >> build/staging/deb/python-date/DEBIAN/control
	find build/staging/deb/python-date -type d -exec chmod 0755 {} +
	find build/staging/deb/python-date -type f -exec chmod 0644 {} +
	mkdir -p build/dist/deb
	dpkg-deb -b -Zgzip -z6 build/staging/deb/python-date build/dist/deb/python-date_$(VERSION)_all.deb

deb-termux:
	rm -rf build/staging/termux/python-date
	rm -rf build/*.whl build/*.tar.gz
	mkdir -p build
	cp date.py __init__.py pip/pyproject.toml LICENSE build/
	( cd build && python3 -m build --wheel --outdir . )
	python -m pip install --root=build/staging/termux/python-date --prefix=/data/data/com.termux/files/usr build/*.whl
	mkdir -p build/staging/termux/python-date/data/data/com.termux/files/usr/share/doc/python-date
	cp LICENSE README.md build/staging/termux/python-date/data/data/com.termux/files/usr/share/doc/python-date/
	mkdir -p build/staging/termux/python-date/DEBIAN
	chmod 755 build/staging/termux/python-date/DEBIAN
	sed -e 's/@VERSION@/$(VERSION)/' \
	    -e "s/@SIZE@/$$(du -sk build/staging/termux/python-date | cut -f1)/" \
	    -e 's/@DEPENDS@/python/' \
	    -e 's/@ARCH@/all/' \
	    debian/control.in > build/staging/termux/python-date/DEBIAN/control
	echo "" >> build/staging/termux/python-date/DEBIAN/control
	find build/staging/termux/python-date -type d -exec chmod 0755 {} +
	find build/staging/termux/python-date -type f -exec chmod 0644 {} +
	mkdir -p build/dist/termux
	dpkg-deb -b -Zgzip -z6 build/staging/termux/python-date build/dist/termux/python-date_$(VERSION)_all.deb

clean:
	rm -rf build