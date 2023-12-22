newPackage "ComintMime"

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
	print("\e]5151;{\"type\": \"" | type | "\"}\n" |
	    first url | "\e\\\n"))
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
