-- Copyright (C) 2023 Doug Torrance

-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

newPackage("ComintMime",
    Headline => "comint-mime for Macaulay2",
    Authors => {{
	    Name => "Doug Torrance",
	    Email => "dtorrance@piedmont.edu",
	    HomePage => "https://webwork.piedmont.edu/~dtorrance"}},
    Version => "0.1")

export {
    "restoreShow",
    "updateShow"}

-- save the old show(URL) in ZZ in case we reload the package
if not ZZ#?"oldshow" then ZZ#"oldshow" = lookup(show, URL)
oldshow = ZZ#"oldshow"

-- try several options for getting mime type
typecmd = (
    if run "command -v xdg-mime > /dev/null" == 0
    then "!xdg-mime query filetype "
    else if run "command -v mimetype > /dev/null" == 0
    then "!mimetype -b "
    else if run "command -v file > /dev/null" == 0
    then "!file --mime -b "
    else error "cannot find command for determining mime type")

newshow = url -> (
    if (m := regex("^file://(.*)", first url)) =!= null
    then (
	file := substring(m#1, first url);
	type := first lines get(typecmd | file);
	if match({"^image", "^text"}, type)
	then (
	    printerr("showing \033]8;;", first url, "\033\\", file,
		"\033]8;;\033\\");
	    print "";
	    print("\033]5151;{\"type\": \"" | type | "\"}\n" |
		first url | "\033\\\n"))
	else oldshow url)
    else oldshow url);

updateShow = () -> (show URL := newshow;)
restoreShow = () -> (show URL := oldshow;)

updateShow()

beginDocumentation()

doc ///
  Key
    ComintMime
  Headline
    comint-mime for Macaulay2
  Description
    Text
      This Macaulay2 package adds support for the Emacs package
      @HREF{"https://github.com/astoff/comint-mime", "comint-mime"}@,
      which displays graphics and other MIME attachments in Emacs shells.
      In particular, it redefines @TO (show, URL)@ to emit a special
      escape sequence, which will be interpreted by comint-mime, instead
      of opening the file in the default system viewer.

      This package should not be loaded manually.  Instead, it will be loaded
      automatically after running @KBD "M"@-@KBD "x"@ @SAMP "comint-mime-setup"@
      in Emacs.

      To restore @SAMP "show"@ to its default behavior, run @TO restoreShow@,
      and to go back to the updated behavior, run @TO updateShow@.
///

doc ///
  Key
    updateShow
  Headline
    update the definition of show(URL) for comint-mime support
  Usage
    updateShow()
  Description
    Text
      This function is run automatically after loading the @TO ComintMime@
      package.  It redefines @TO (show, URL)@ to emit a special escape sequence,
      which will be interpreted by comint-mime to display the given file in
      the Emacs buffer instead of using the default system viewer.

      To restore the default behavior of @SAMP "show"@, run @TO restoreShow@.
  SeeAlso
    restoreShow
///

doc ///
  Key
    restoreShow
  Headline
    restore the default definition of show(URL)
  Usage
    restoreShow()
  Description
    Text
      This function restores the behavior of @TO (show, URL)@ to the default,
      i.e., to display the given file using the default system viewer instead
      of in the Emacs buffer.
  SeeAlso
    updateShow
///

TEST ///
assert match("ComintMime\\.m2$", first locate(show, URL))
restoreShow()
assert match("html\\.m2$", first locate(show, URL))
updateShow()
assert match("ComintMime\\.m2$", first locate(show, URL))

-- check that reloading works
loadPackage("ComintMime", FileName => ComintMime#"source file", Reload => true)
assert match("ComintMime\\.m2$", first locate(show, URL))
restoreShow()
assert match("html\\.m2$", first locate(show, URL))
///
