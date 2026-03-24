xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace xrx = "http://www.monasterium.net/NS/xrx";
declare namespace eag = "http://www.archivgut-online.de/eag";
declare namespace tei = "http://www.tei-c.org/ns/1.0/";
declare namespace ead="urn:isbn:1-931666-22-9";

let $enns := collection('/db/mom-data/metadata.charter.public/AT-OOeLA/Enns')/atom:entry

(:for $charter in collection('/db/mom-data/metadata.charter.public/AT-OOeLA/Enns')/atom:entry
where empty($charter//cei:witnessOrig)
return $charter/atom:content/cei:text/cei:body/cei:idno/@id/data():)

for $entry in doc('/db/niklas/import/enns/enns_regesten.xml')//Charter
let $date := $entry/Date/Numeric/text()
let $found-chars := $enns[atom:id[contains(text(), $date)]]
where count($found-chars) eq 1
return (
    update delete $found-chars//cei:date/text(),
    update delete $found-chars//cei:diplomaticAnalysis,
    update delete $found-chars//cei:abstract,
    update delete $found-chars//cei:traditioForm,
    update delete $found-chars//cei:auth,
    update insert $entry/Date/Modern/text() into $found-chars/atom:content/cei:text/cei:body/cei:chDesc/cei:issued/cei:date,
    update insert <cei:diplomaticAnalysis><cei:quoteOriginaldatierung>{$entry/Date/AsWritten/text()}</cei:quoteOriginaldatierung><cei:listBibl>{$entry/Date/Bibliography/text()}<cei:bibl/></cei:listBibl></cei:diplomaticAnalysis> into $found-chars/atom:content/cei:text/cei:body/cei:chDesc,
    update insert <cei:abstract>{$entry/Abstract/text()}</cei:abstract> preceding $found-chars/atom:content/cei:text/cei:body/cei:chDesc/cei:issued,
    update insert (<cei:traditioForm>{$entry/Tradition/text()}</cei:traditioForm>, <cei:auth><cei:sealDesc>{$entry/Seal/text()}</cei:sealDesc></cei:auth>) into $found-chars/atom:content/cei:text/cei:body/cei:chDesc/cei:witnessOrig
    )

(:for $entry in doc('/db/niklas/import/enns/enns_regesten.xml')//Charter
let $date := $entry/Date/Numeric/text()
let $found-chars := $enns[atom:id[contains(text(), $date)]]
where count($found-chars) gt 1
order by $date
return $date:)