PYPI_TOKEN ?= ~/pypi.txt

.PHONY: pip install-pip deb install-deb upload clean

pip:
	rm -rf build
	mkdir -p build
	cp date.py __init__.py pip/pyproject.toml LICENSE build/
	( cd build && python3 -m build --outdir . )

install-pip:
	python3 -m pip install build/*.whl

deb:
	rm -rf build/deb
	mkdir -p build/deb
	cp -r debian build/deb/
	cp date.py __init__.py pip/pyproject.toml LICENSE README.md build/deb/
	( cd build/deb && dpkg-buildpackage -us -uc -b )

install-deb:
	dpkg -i build/python3-date_*.deb

upload:
	TWINE_USERNAME=__token__ TWINE_PASSWORD=$$(cat $(PYPI_TOKEN)) twine upload build/*.whl build/*.tar.gz

clean:
	rm -rf build
