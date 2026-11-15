# Post-mortem, lessons learned och professionell sammanfattning

**Namn:** Abdulghani Fkhir  
**Projekt/team:** Team 1, Avancerad IT-säkerhet (ITSX25)  
**Datum:** 2026-11-15  
**Repository:** [ITSX25-Chas/team1-infra](https://github.com/ITSX25-Chas/team1-infra)

Den här filen hör ihop med [individual-report-abdulghani.md](./individual-report-abdulghani.md) och [kpi-abdulghani.md](./kpi-abdulghani.md). Den knyter an till kursmål 9 och 13. Jag har använt AI som stöd för att formulera texten, se avsnitt 7 i den individuella rapporten.

---

## Händelse och avgränsning

Post-mortemen gäller intrångstestet mot den tilldelade målmiljön. Där simulerades en angripare utan inloggning som tog sig hela vägen till interna personuppgifter. Målmiljön var avsiktligt sårbar och ägs av uppdragsgivaren. Det som påverkades var vår förmåga att upptäcka, eftersom intrånget inte upptäcktes i realtid. Det granskades i efterhand utifrån testresultaten och loggarna.

Jag tittar också på vår egen miljö och på Spectre-övningen, där vi själva hittade en hemlighet i Terraform-state, eftersom samma mönster finns där. Min del i incidentresponsen var att sitta med teamet när vi letade efter flaggor och brister, att granska och prova om det vi hittat i efterhand och att vara med i arbetet med att åtgärda det.

---

## Lesson learned 1

### Observation

Loggar är inte larm. Testet nådde personuppgifter utan att det upptäcktes i realtid. Samma mönster finns hos oss: vi samlar loggar men har inga larmresurser i koden.

### Orsak

Loggarna samlades in men ingen regel reagerade på dem i realtid, och vårt arbete låg främst på att förebygga och inte på att upptäcka. Insamling av loggar är inte detsamma som upptäckt.

### Konsekvens

Ett intrång hade kunnat pågå utan att någon märkte det, och vi hade inte kunnat begränsa skadan eller anmäla i tid.

### Förbättring

Larm i realtid för kända angreppsmönster, och en kort rutin som säger vem som tar emot larmet och vad den personen gör.

### Uppföljning

KPI 3, och ett nytt intrångstest där vi mäter tiden tills larmet går.

---

## Lesson learned 2

### Observation

Tystnad är inte trygghet. Signaturkontrollen låg nere i upp till tio dygn och tystnaden tolkades som att allt var bra.

### Orsak

Kontrollen signalerade inte själv när den slutade fungera, så ingen märkte att den var tyst.

### Konsekvens

Vår starka förebyggande sida kunde ge falsk trygghet, och ett intrång under den tiden hade kunnat passera obemärkt.

### Förbättring

Låt varje kontroll skicka ett livstecken och larma när det uteblir. Börja med de viktigaste.

### Uppföljning

KPI 3. Stäng av en kontroll i testmiljön och mät hur lång tid det tar tills någon larmas.

---

## Lesson learned 3

### Observation

Manuella steg med hemligheter läcker. Hemligheter exponerades när de hanterades för hand och inte i koden.

### Orsak

Den första CI/CD-nyckeln hämtades ur en Terraform-output och lades in som GitHub-secret för hand, och den hamnade också i state. Min SSH-nyckel blev sannolikt ändrad när den skickades via Discord (infraloggen, fas 7). En planfil med kopior av state checkades in, och `.gitignore` stoppade den inte.

### Konsekvens

En exponerad hemlighet kan användas av någon annan, och en kodgranskning hittar den inte. Den manuella överföringen kostade också tid när nyckeln skulle felsökas.

### Förbättring

Färre manuella steg, hemligheter med kort giltighetstid, plan-filer ut ur Git, secret-skanning i pipelinen och jämförelse av fingeravtryck i stället för text när nycklar förs över.

### Uppföljning

KPI 1 (och att andelen nyckellösa driftsättningsflöden går mot 100 %), samt stickprov på att inga hemligheter hanteras manuellt.

---

## Professionell sammanfattning

I intrångstestet kom en angripare utan inloggning åt interna personuppgifter i målmiljön, och det upptäcktes inte i realtid. Det är det viktigaste resultatet, eftersom det visar att vi är bättre på att förebygga än på att upptäcka. I en riktig verksamhet hade personuppgifter kunnat exponeras utan att någon visste om det, och då hade en anmälan till tillsynsmyndigheten inom 72 timmar inte gått att göra i tid.

Våra egna mätningar pekar åt samma håll. En av kontrollerna kunde vara ur funktion i upp till tio dygn innan någon upptäckte det. Det tog i median 19 dagar att ta bort en känd svaghet ur koden, och ingen av de sju bristerna från testet var åtgärdad och omtestad i tid. Vid min granskning den 15 november låg dessutom en planfil med nyckelmaterial i det publika repot.

Det organisationen bör prioritera först är att städa hemligheterna ur repot och återkalla nyckeln. Därefter behövs larm i realtid och ett livstecken från varje kontroll, så att tystnad blir ett larm och inte en trygghet. Sedan behövs en frist på 14 dagar för kritiska och höga fynd, med omtest.

Två saker kräver beslut av ledningen: vem som ska ta emot och agera på larm, och vem som äger de breda behörigheterna i den delade molnmiljön, som teamet inte kan ändra själv. Uppföljningen sker varje månad med mina tre KPI:er.
