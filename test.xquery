xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace xrx = "http://www.monasterium.net/NS/xrx";
declare namespace eag = "http://www.archivgut-online.de/eag";
declare namespace tei = "http://www.tei-c.org/ns/1.0/";
declare namespace ead="urn:isbn:1-931666-22-9";

(:for $charter in collection('/db/mom-data/metadata.charter.public/AT-OOeLA/Enns')/atom:entry
order by $charter/atom:content/cei:text/cei:body/cei:idno/@id/data()
return $charter/atom:content/cei:text/cei:body/cei:idno/@id/data():)

let $enns := collection('/db/mom-data/metadata.charter.public/AT-OOeLA/Enns')/atom:entry

for $entry in doc('/db/niklas/import/enns/enns_regesten.xml')//Charter
let $date := $entry/Date/Numeric/text()
where count($enns/atom:id[contains(text(), $date)]) gt 1
return $date