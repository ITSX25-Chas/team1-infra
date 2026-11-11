# KPI:er och säkerhetsmätningar

**Namn:** Malcolm Skoglund
**Team:** Team 1, ITSX25 kurs 6, Avancerad IT-säkerhet
**Mottagare:** ledningsgrupp och systemägare (icke-teknisk)

## Syfte

Tre KPI:er som följer upp effekten av säkerhetsarbetet. De är valda så att en beslutsfattare utan teknisk bakgrund kan se om risken går åt rätt håll, och vet när ett värde kräver ett beslut.

KPI:erna mäter säkerhetsläge och effekt, inte antal utförda aktiviteter. Alla tre bygger på mätningar vi redan gjort i projektet. De tre täcker leden förebygga, upptäcka och åtgärda, och var och en motsvarar ett etablerat branschmått.

## Utfall framför aktivitet

Vi skiljer på två sorters mått. Aktivitetsmått räknar vad man gjort, till exempel antal skanningar körda eller antal regler skrivna. De säger inget om man faktiskt är säkrare. Utfallsmått mäter verklig riskminskning, till exempel minskad angreppsyta, bekräftat lägre exponering och kortare tid till upptäckt.

Alla våra tre KPI:er är utfallsmått. Det är ett medvetet val: en ledning ska kunna läsa dem som svar på frågan "är vi säkrare", inte "har vi varit aktiva".

---

## KPI 1

### Namn

Andel av våra utrullningar som sker utan lösenord eller sparade nycklar

### Branschmått

Minskad angreppsyta (attack surface reduction). Ett utfallsmått, inte ett aktivitetsmått.

### Syfte och mottagare

Mäter hur stor del av vår automatiska driftsättning som fortfarande är beroende av långlivade lösenord eller nycklar. En sparad nyckel är farlig på samma sätt som en bortglömd huvudnyckel till kontoret: läcker den får obehöriga samma åtkomst som systemet självt. Mottagare är systemägaren och IT-chefen, som behöver veta hur stor den risken är.

### Definition och beräkning

`Antal driftsättningsflöden som använder kortlivad, automatisk identitet / totalt antal driftsättningsflöden × 100`

Kompletterande mått: antal sparade nycklar med administratörsbehörighet. Ska alltid vara 0.

| Tidpunkt | Nyckellösa flöden | Andel | Sparade admin-nycklar |
|---|---|---|---|
| Projektstart | 0 av 3 | 0 % | 3 |
| Projektslut | 2 av 3 | 67 % | 0 |

### Datakälla och datakvalitet

Källa: inställningarna i vårt kodförråd (GitHub) och i molnplattformen (GCP), som visar vilka flöden som använder sparade nycklar. Data är tillförlitlig eftersom den läses direkt ur systemens egen konfiguration, inte ur enkäter eller uppskattningar. Begränsning: måttet säger inget om hur väl den kortlivade identiteten är avgränsad, bara att den inte är en sparad nyckel.

### Målvärde eller önskad riktning

100 % nyckellösa flöden, och 0 sparade nycklar med administratörsbehörighet, hela tiden.

### Mätfrekvens

Månadsvis, samt varje gång ett nytt driftsättningsflöde skapas.

### Tolkning och åtgärd vid avvikelse

Ett stigande värde är bra. Sjunker det, eller dyker en sparad admin-nyckel upp, har någon infört en genväg som ökar risken. Åtgärd: nyckeln återkallas omgående och ersätts med en kortlivad identitet. En ny sparad nyckel ska alltid ha en namngiven ägare och ett datum då den tas bort.

---

## KPI 2

### Namn

Tid innan vi upptäcker att en säkerhetskontroll har slutat fungera

### Branschmått

Besläktat med MTTD (Mean Time to Detect), alltså genomsnittlig tid till upptäckt. Här mätt på att en kontroll tystnat, inte på ett aktivt angrepp, eftersom vi ännu saknar övervakning i realtid.

### Syfte och mottagare

Mäter hur länge ett skydd kan vara trasigt utan att någon märker det. En kontroll som tyst slutat fungera ger falsk trygghet: vi tror att vi är skyddade, men är det inte. I projektet var två kontroller ur funktion i flera dygn innan vi upptäckte det. Mottagare är driftansvarig och säkerhetsansvarig.

### Definition och beräkning

`Tid i timmar = tidpunkt då felet upptäcktes − tidpunkt då kontrollen slutade fungera`

Rapporteras som längsta tid per period, för alla säkerhetskontroller (sårbarhetsskanning, signaturkontroll, loggning).

| Händelse i projektet | Tid innan upptäckt |
|---|---|
| Sårbarhetsskannern larmade inte (tom inställning) | minst 46 timmar |
| Signaturkontrollen var ur funktion | upp till 10 dygn |

### Datakälla och datakvalitet

Källa: systemens egna statusloggar, som visar när ett jobb senast lyckades och hur många gånger en tjänst startat om. Data är tillförlitlig eftersom tidsstämplarna sätts automatiskt. Begränsning: måttet fångar bara fel vi till slut upptäckte; ett fel som aldrig upptäcks syns inte förrän ett larm införs.

### Målvärde eller önskad riktning

Högst 24 timmar på kort sikt, och högst 1 timme när automatiska larm är på plats.

### Mätfrekvens

Löpande per händelse, sammanställt månadsvis.

### Tolkning och åtgärd vid avvikelse

Ett lågt värde betyder att vi märker fel snabbt. Ett högt värde betyder att vi är blinda under tiden. Åtgärd vid avvikelse: inför ett livstecken, så att varje kontroll hör av sig även när allt är bra, och larma när ett säkerhetsjobb misslyckas. Då blir tystnad ett larm i stället för en falsk trygghet.

---

## KPI 3

### Namn

Andel allvarliga brister som åtgärdats och verifierats i tid

### Branschmått

Besläktat med MTTR (Mean Time to Remediate), alltså åtgärdstid, och med patch-latens. Skillnaden: vi räknar en brist som klar först efter ett godkänt omtest, inte bara efter en påstådd fix.

### Syfte och mottagare

Mäter om ett säkerhetstest faktiskt leder till lägre risk, eller bara till en rapport. En brist räknas som stängd först när ett omtest visar att den inte längre går att utnyttja. Mottagare är systemägaren, som behöver veta om kända brister verkligen blir åtgärdade.

### Definition och beräkning

`Antal kritiska och höga brister som åtgärdats och godkänts i omtest inom tidsgränsen / totalt antal kritiska och höga brister vars tidsgräns passerat × 100`

Tidsgräns: 7 dagar för kritiska, 30 dagar för höga brister.

Utgångsläge från vårt penetrationstest: 0 av 7 åtgärdade och omtestade. Tre kritiska brister låg kvar oförändrade en vecka efter att de upptäcktes. (Målmiljön var avsiktligt sårbar och ägs av uppdragsgivaren, så värdet visar hur KPI:n fungerar, inte uppdragsgivarens arbete.)

### Datakälla och datakvalitet

Källa: penetrationstestrapporten (vilka brister som hittades, med risknivå och datum) och ärendesystemet (när de öppnades och stängdes). För att stänga en brist krävs ett omtest där samma angrepp misslyckas. Begränsning: måttet mäter åtgärdstakt, inte hur allvarlig varje enskild brist är.

### Målvärde eller önskad riktning

100 % åtgärdade och omtestade inom tidsgränsen, och 0 kritiska brister äldre än 7 dagar.

### Mätfrekvens

Veckovis för kritiska brister, månadsvis sammanställning för alla.

### Tolkning och åtgärd vid avvikelse

Ett lågt värde betyder att vi hittar brister men inte stänger dem. Åtgärd: en passerad tidsgräns eskaleras till systemägaren. Går bristen inte att åtgärda i tid införs en tillfällig skyddsåtgärd, eller en dokumenterad och signerad riskacceptans med nytt granskningsdatum.

---

## Kompletterande mått att införa

De tre KPI:erna ovan är de vi faktiskt mätt i projektet. Följande etablerade mått rekommenderar vi att införa när övervakning (SIEM) och incidenthantering finns på plats. De kräver förmågor vi ännu saknar, så vi redovisar dem som nästa steg, inte som mätta värden.

| Mått | Vad det mäter | Kräver |
|---|---|---|
| MTTA (Mean Time to Acknowledge) | Tid från larm till att någon börjar hantera det | Larm och en bemannad process |
| MTTC (Mean Time to Contain) | Tid att hindra ett hot från att sprida sig | Incidenthantering och segmentering |
| Patch-latens | Tid från att en kritisk uppdatering släpps till att den är installerad | Inventering och uppdateringsrutin |
| Andel enheter uppdaterade | Andel system med aktuell programvara och skydd | Central enhetsöversikt |
| Efterlevnad i revision | Andel interna och lagstadgade kontroller som uppfylls | Kontrollramverk och granskning |

Dessa är branschstandard och gör det möjligt att jämföra oss över tid och mot andra. Att vi listar dem som framtida mått är ett medvetet val: vi redovisar bara det vi kan belägga.

---

## Samlad ledningsrapportering

De tre KPI:erna svarar tillsammans på tre frågor en ledningsgrupp kan förstå utan teknisk bakgrund: Hur stor är vår exponering? (KPI 1). Märker vi när skyddet slutar fungera? (KPI 2). Blir kända brister faktiskt stängda? (KPI 3). De täcker de tre leden förebygga, upptäcka och åtgärda.

Trenden som bör uppmärksammas är att exponeringen minskat (nyckellös autentisering från 0 till 67 procent), men att både upptäcktsförmågan och åtgärdstakten har tydliga luckor: kontroller kunde vara trasiga i upp till tio dygn, och inga testfynd hade stängts med omtest. KPI:erna stödjer beslutet att prioritera larm och övervakning (KPI 2) och en rutin för att följa upp och omtesta brister (KPI 3) före ytterligare nya skydd.

KPI:erna visar inte hela bilden. De säger inget om risker som ligger utanför vårt mandat, till exempel breda behörigheter i den delade molnmiljön som bara ägaren kan åtgärda. De säger inte heller något om hot vi ännu inte infört övervakning för. Kompletterande underlag är därför en central behörighetsgranskning och införandet av säkerhetsövervakning (SIEM), som ännu saknas.
