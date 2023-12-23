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
