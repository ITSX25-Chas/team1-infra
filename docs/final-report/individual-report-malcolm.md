# Individuell slutrapport

**Namn:** Malcolm Skoglund
**Projekt/team:** Team 1, ITSX25 kurs 6, Avancerad IT-säkerhet
**Datum:** 2026-11-08

---

## 1. Professionell sammanfattning

Team 1 byggde och härdade en molnmiljö (webbapplikation, Kubernetes-kluster och automatiserad driftsättning) och genomförde därefter ett penetrationstest mot en tilldelad målmiljö. Den här rapporten sammanställer resultatet för en ledningsgrupp.

**Viktigaste resultat.** Vi gick från en miljö med flera allvarliga brister till en betydligt säkrare: en server som var öppen mot hela internet stängdes, och tre sparade nycklar med administratörsbehörighet ersattes med kortlivade identiteter. Av 20 identifierade brister är 19 helt eller delvis åtgärdade. I penetrationstestet visade vi samtidigt hur en angripare utan inloggning kunde ta sig till interna personuppgifter i en sårbar miljö, och att ett sådant angrepp inte upptäcktes medan det pågick.

**Viktigaste risker.** Den största kvarstående risken är breda behörigheter i den delade molnmiljön, som bara ägaren kan åtgärda. Därtill saknas realtidsövervakning, och vissa säkerhetskontroller kunde vara ur funktion i flera dygn utan att vi märkte det.

**Vad KPI:erna visar.** Exponeringen har minskat, men upptäcktsförmågan och åtgärdstakten har tydliga luckor.

**Viktigaste rekommendationer.** Prioritera (1) säkerhetsövervakning med realtidslarm, (2) larm när en säkerhetskontroll slutar fungera, och (3) en central behörighetsgranskning.

**Beslut som behövs.** Behörighetsgranskningen kräver beslut och mandat på ägarnivå, eftersom den ligger utanför lagets kontroll.

---

## 2. Kontext och avgränsning

Projektet var ett sammanhängande Blue Team- och Red Team-scenario. Som Blue Team byggde vi en molnmiljö som kod och härdade den: nätverk, åtkomst, driftsättningskedja, containrar och övervakning. Som Red Team genomförde vi ett penetrationstest mot en annan, tilldelad målmiljö.

Rapporten bygger på projektets egen dokumentation, kodförrådens historik, teamets säkerhetsrapport med 20 fynd, penetrationstestrapporten och försvarssidans loggar som vi fick ut efter testet.

**Avgränsning.** Rapporten är skriven för en icke-teknisk beslutsfattare och fokuserar på resultat, risk och rekommendationer. Risker som ligger utanför lagets mandat, framför allt i den delade molnmiljön, redovisas som observationer med förslag på ägarskap. Målmiljön i penetrationstestet var avsiktligt sårbar, så resultaten där visar vår metod och förmåga, inte en verklig kunds säkerhetsläge.

---

## 3. Mitt individuella bidrag

Jag ansvarade för stora delar av infrastrukturen, driftsättningskedjan och efterhandsanalysen. Mina bidrag går att följa i kodförrådens historik.

**Infrastruktur och åtkomst.** Jag satte upp grunden för infrastruktur som kod och tog bort den brandväggsregel som exponerade en server mot hela internet, och ersatte den med säker åtkomst via identitetsstyrd anslutning (F-01, F-08). Jag bytte driftsättningens inloggning från sparade nycklar till kortlivade, automatiska identiteter (F-03, F-05) och tog bort en bred administratörsroll från driftkontot (F-02). Commits: [nätverkshärdning](LÄNK), [nyckellös autentisering](LÄNK), [least privilege IAM](LÄNK).

**Container och applikation.** Jag härdade applikationens containrar så att de kör utan administratörsrättigheter och med skrivskyddat filsystem, och begränsade deras åtkomst till känsliga molntjänster (F-19). Jag tog bort en inloggningsbrist och införde åtkomstkontroll för användarprofiler (F-12, F-13, F-14). Commits: [NetworkPolicy](LÄNK), [applikationssäkerhet](LÄNK).

**Felsökning och analys.** Jag utredde varför två säkerhetskontroller tyst slutat fungera (F-07, F-15). I Red Team-fasen genomförde jag attackstegen och gjorde efterhandsanalysen av försvarssidans loggar, där jag knöt varje steg till en konkret loggrad. Commit: [loggning och felsökning](LÄNK).

**Samarbete.** Arbetet gjordes i lag. Allt granskades och godkändes gemensamt innan det slogs samman, och lagkamraterna bidrog med egna delar och rättade mina misstag på vägen.

---

## 4. Viktigaste projektresultat och evidens

### Resultat 1: Stängde en server som var öppen mot internet

**Resultat.** En brandväggsregel tillät trafik från hela internet till en central server. Regeln togs bort och åtkomsten går nu via en identitetsstyrd, loggad väg.

**Evidens.** Kodändring i infrastrukturförrådet ([commit](LÄNK)), och ett sluttest som bekräftade att ingen regel längre öppnade mot hela internet och att den publika inloggningen var stängd.

**Verksamhets- och säkerhetsbetydelse.** En öppen server är den första måltavlan för ett angrepp. Att stänga den tar bort den enklaste vägen in.

**Rekommendation.** Granska brandväggsregler automatiskt i varje ändring, så att en öppen regel aldrig kan smyga tillbaka. Ägs av driftteamet.

### Resultat 2: Tog bort sparade nycklar ur driftsättningen

**Resultat.** Tre sparade nycklar med administratörsbehörighet ersattes med kortlivade, automatiska identiteter. Driftkontots breda roll ersattes med smala roller.

**Evidens.** Molnplattformen visar noll sparade nycklar på driftkontot och ingen administratörsroll ([commit](LÄNK)). Driftsättningarna fungerar utan sparade hemligheter.

**Verksamhets- och säkerhetsbetydelse.** En läckt sparad nyckel med bred behörighet hade kunnat skada alla lags miljöer i det delade projektet. Nu finns ingen sådan nyckel att stjäla.

**Rekommendation.** Gör nyckellös inloggning till standard och följ upp med KPI 1. Ägs av plattformsteamet.

### Resultat 3: Visade en komplett angreppskedja i penetrationstestet

**Resultat.** Från webbsidan utan inloggning tog vi oss till kommandokörning, läsning av en root-skyddad fil och åtkomst till interna personuppgifter.

**Evidens.** Penetrationstestrapporten med reproduktionssteg och bevis ([rapport](LÄNK)), samt försvarssidans loggar där varje steg finns registrerat.

**Verksamhets- och säkerhetsbetydelse.** Kedjan krävde inga avancerade verktyg. Den visar hur snabbt flera små brister tillsammans leder till en personuppgiftsincident.

**Rekommendation.** Åtgärda rotorsaken (servern litar på data som användaren själv styr) och inför övervakning som upptäcker angreppet. Ägs av systemägaren.

### Resultat 4: Upptäckte att övervakningen inte reagerade

**Resultat.** Efter testet visade loggarna att hela angreppet fanns registrerat, men att inget larm hade gått och ingen respons påbörjats.

**Evidens.** Jämförelse mellan våra dokumenterade attackssteg och försvarssidans loggar ([post-mortem](LÄNK)).

**Verksamhets- och säkerhetsbetydelse.** Att samla in loggar är inte samma sak som att upptäcka ett angrepp. Utan övervakning som larmar hade ett skarpt intrång kunnat pågå oupptäckt.

**Rekommendation.** Inför realtidsövervakning. Ägs av säkerhetsansvarig.

---

## 5. KPI:er och ledningsrapportering

Jag valde tre KPI:er som motsvarar de tre största riskerna:

1. **Andel utrullningar utan sparade nycklar.** Visar hur stor vår exponering är. Från 0 till 67 procent, mål 100.
2. **Tid innan vi upptäcker att en kontroll slutat fungera.** Visar vår upptäcktsförmåga. Upp till tio dygn, mål under ett dygn.
3. **Andel allvarliga brister åtgärdade och omtestade i tid.** Visar om tester leder till lägre risk. Utgångsläge 0 av 7.

Tillsammans besvarar de tre frågor en ledningsgrupp kan förstå: hur stor är exponeringen, märker vi när skyddet sviktar, och blir brister stängda. De stödjer beslutet att prioritera övervakning och åtgärdsrutiner före nya skydd. KPI:erna visar inte risker utanför vårt mandat, till exempel i den delade molnmiljön, och de ersätter inte en säkerhetsövervakning som ännu saknas. Fullständiga definitioner: [`kpi.md`](./kpi.md).

---

## 6. Incidentrespons, post-mortem och förbättringsarbete

Post-mortem gäller penetrationstestet mot den tilldelade målmiljön, som fungerade som ett simulerat intrång. Angreppet lyckades men upptäcktes inte medan det pågick. Det blev synligt först i efterhand, när försvarssidans loggar visade att allt fanns registrerat men att ingen regel reagerat.

De viktigaste orsakerna var att övervakning saknades, att säkerhetskontroller kunde vara trasiga i flera dygn, och att hemligheter läckte i manuella arbetsmoment. Konsekvensen är att vår förmåga att förhindra var starkare än vår förmåga att upptäcka och agera.

De viktigaste förbättringarna är att införa realtidsövervakning, att ge varje kontroll ett livstecken så att tystnad blir ett larm, och att aldrig hantera hemligheter via terminal eller skärm. Förbättringarna följs upp med mätbara mål: tid till upptäckt och andel stängda brister. Fullständigt underlag: [`lessons-learned.md`](./lessons-learned.md).

---

## 7. AI i säkerhetsarbetet

### Konkreta användningsfall

Jag använde generativa AI-assistenter (Claude, ChatGPT och kodassistenten Cursor) genom hela projektet. De användes för att strukturera rapporterna enligt fyndmallar, formulera reproduktionssteg och åtgärdsförslag, diskutera kopplingen mellan brister och kända angreppstekniker (MITRE ATT&CK), och för att föreslå sök- och filtreringskommandon när jag analyserade stora loggfiler. I kodarbetet användes assistenten som stöd vid felsökning och vid härdning av konfiguration.

### När AI var lämpligt

AI tillförde mest värde i struktur, språk och idéer. Ett konkret exempel: när jag skulle koppla våra fynd till angreppstekniker hjälpte AI mig skilja på själva kodbristen och det beteende en angripare uppvisar, så att vi inte satte en teknik bara för att fylla ett fält. Ett annat exempel är logganalysen: AI föreslog hur jag kunde söka igenom tiotusentals loggrader effektivt, vilket sparade mycket tid utan att ersätta min egen bedömning av vad raderna betydde.

### När AI var olämpligt eller otillräckligt

Jag lät aldrig AI avgöra om ett test lyckats eller om en sårbarhet fanns. AI är olämpligt som ensam grund för att fastställa ett resultat, för att påstå att försvaret upptäckte ett angrepp, eller för att fylla luckor i underlag. När vi saknade loggbevis för en del av post-mortem lät jag inte AI gissa ett detektionsresultat, utan redovisade avsaknaden som en begränsning. Att låta AI fylla en sådan lucka hade varit samma falska trygghet som en tyst säkerhetskontroll.

### Verifiering och mänsklig kontroll

Varje slutsats verifierade jag mot faktiska data. När jag analyserade loggarna körde jag kommandona själv och läste utfallet med egna ögon innan jag skrev något, och jag kontrollerade loggpaketets äkthet mot dess kontrollsumma. Jag stämde också av AI:s påståenden mot källor: ett flaggnamn som antydde att data förts ut ur miljön bevisade i själva verket bara intern åtkomst, och det korrigerade jag.

### Risker och professionella gränser

De största riskerna med AI i säkerhetsarbete är övertro på resultat, påhittade men trovärdiga påståenden, och att känsligt material matas in i ett externt verktyg. Ett AI-genererat kommando bevisar inte att en sårbarhet finns, ett flaggnamn bevisar inte en större konsekvens än den som faktiskt observerades, och en välformulerad text kan dölja ett svagt underlag. Jag höll därför känsliga värden utanför verktygen och behandlade allt AI-genererat som utkast.

### Professionell slutsats

AI snabbar upp struktur, språk och idéer, men förskjuter inte beviskravet. Ett AI-genererat kommando är en hypotes tills jag kört det, och ett AI-formulerat påstående är ett utkast tills jag belagt det. Så länge jag behåller den gränsen är AI ett bra verktyg i säkerhetsarbete. Släpper jag den blir det en källa till falsk trygghet. Min princip framåt är att använda AI för struktur och hastighet, men att alltid själv verifiera resultat mot data och ta ansvar för slutsatserna.

---

## 8. Prioriterade rekommendationer

| Prio | Åtgärd | Varför | Risk som adresseras | Ägare |
|---|---|---|---|---|
| 1 | Inför säkerhetsövervakning med realtidslarm | Angrepp fanns i loggarna men upptäcktes inte | Oupptäckta intrång | Säkerhetsansvarig |
| 2 | Larm när en säkerhetskontroll slutar fungera | Kontroller var trasiga i flera dygn | Falsk trygghet | Driftansvarig |
| 3 | Central behörighetsgranskning i delad molnmiljö | Breda behörigheter utanför lagets mandat | Spridning vid ett läckt konto | Molnprojektets ägare |
| 4 | Rutin för att åtgärda och omtesta brister i tid | Inga testfynd hade stängts med omtest | Kända brister förblir öppna | Systemägaren |

Rekommendationerna är få och valda för tydlig effekt. Prio 1, 2 och 4 kan organisationen genomföra själv. Prio 3 kräver beslut på ägarnivå.

---

## 9. Individuell reflektion

### Vad kan jag nu som jag inte kunde när kursen började?

Jag kan bygga en driftsättningskedja helt utan sparade nycklar, något jag inte visste var möjligt tidigare. Jag kan också följa en angreppskedja från början till slut och förklara varje steg, och jag har lärt mig skilja på en kodbrist och den teknik en angripare använder för att utnyttja den.

### Vilket moment har förändrat mitt sätt att arbeta mest?

Logganalysen efter penetrationstestet. Att se hela vårt angrepp ligga registrerat utan att något larm gått lärde mig den viktigaste lärdomen i hela kursen: att samla in information är inte samma sak som att upptäcka ett angrepp. Sedan dess tänker jag alltid ett steg längre: inte bara "loggar vi det här", utan "skulle någon faktiskt reagera".

### Vad skulle jag göra annorlunda om projektet började idag?

Jag skulle börja med övervakning och inventering, inte med härdning. Vi upptäckte trasiga kontroller och oanvända nycklar först efter flera veckor. Med larm och en förteckning från dag ett hade vi sett det direkt.

### Vad tar jag med mig till LIA och yrkesrollen?

Två saker konkret. För det första: verifiera i stället för att anta. Jag kör data själv och litar inte på att något "ser rätt ut". För det andra: att översätta teknik till risk. Att skriva KPI:er lärde mig att "hundratals omstarter" säger lite till en chef, medan "skyddet var ur funktion i tio dygn" går att fatta beslut om. Den förmågan att kommunicera säkerhet till en icke-teknisk mottagare är det jag tar med mig tydligast.

---

## 10. Källor och referenser

**Projektets evidens**
- Teamets säkerhetsrapport med 20 fynd och verifieringsresultat.
- Penetrationstestrapport mot tilldelad målmiljö, 2026-10-27.
- Försvarssidans loggar (web, internal, db), mottagna 2026-11-04, verifierade mot SHA-256-manifest.
- Kodförråden `team1-infra`, `team1-company-website` och `team1-documentation` med commit-historik.

**Ramverk och standarder (externa fakta)**
- MITRE ATT&CK. https://attack.mitre.org/
- OWASP Top 10. https://owasp.org/www-project-top-ten/
- CIS Google Cloud Platform Benchmark. https://www.cisecurity.org/benchmark/google_cloud_computing_platform
- NIST SP 800-55, Measurement Guide for Information Security. https://csrc.nist.gov/pubs/sp/800/55/v1/final

**AI-genererat material**
- Generativa AI-assistenter (Claude, ChatGPT, Cursor) användes för struktur, formulering och förslag. Alla slutsatser och siffror är verifierade mot projektets egen evidens enligt avsnitt 7. AI-genererade förslag utgör inte självständiga bevis.

**Mina egna bedömningar**
- Risknivåer, prioritering av rekommendationer och tolkning av KPI:er är mina egna bedömningar utifrån ovanstående underlag.
