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

newshow = url -> (
    if (m := regex("^file://(.*)", first url)) =!= null
    then (
	file := substring(m#1, first url);
	type := first lines get("!file -b --mime " | file);
	print("\033]5151;{\"type\": \"" | type | "\"}\n" |
	    first url | "\033\\\n"))
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
