.PHONY: pip install-pip deb deb-termux clean

all: pip deb deb-termux

pip:
	mkdir -p build/pip
	cp date.py __init__.py pip/pyproject.toml LICENSE build/pip/
	cd build/pip && python3 -m build --outdir .

deb:
	$(MAKE) -f debian/rules deb

deb-termux:
	$(MAKE) -f debian/rules deb-termux

clean:
	rm -rf build

install-pip:
	python3 -m pip install build/pip/*.whl

install-pkg:
	dpkg --install build/dist/termux/python*.deb
