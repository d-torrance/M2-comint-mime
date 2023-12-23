VERSION := $(shell grep Version M2-comint-mime.el | cut -d " " -f3 )
PKG_DIR = M2-comint-mime-$(VERSION)
PKG_FILES = M2-comint-mime.el ComintMime.m2 M2-comint-mime-pkg.el

all: $(PKG_DIR).tar

install: $(PKG_DIR).tar
	emacs --batch --eval "(require 'package)" \
		--eval "(package-install-file \"$(PKG_DIR).tar\")"

%.tar: % $(patsubst %, $(PKG_DIR)/%, $(PKG_FILES))
	tar -cf $@ $<

$(PKG_DIR):
	mkdir -p $@

$(PKG_DIR)/%: % | $(PKG_DIR)
	cp $< $@

M2-comint-mime-pkg.el: M2-comint-mime.el
	emacs --batch --eval "(require 'package)"               \
		--eval "(package-generate-description-file      \
		(with-temp-buffer (insert-file-contents \"$<\") \
		(package-buffer-info)) \"$@\")"

clean:
	rm -rf $(PKG_DIR) *.tar M2-comint-mime-pkg.el
