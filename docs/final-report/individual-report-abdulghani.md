# Individuell slutrapport

**Namn:** Abdulghani Fkhir  
**Projekt/team:** Team 1, Avancerad IT-säkerhet (ITSX25)  
**Datum:** 2026-11-15  
**Repository:** [ITSX25-Chas/team1-infra](https://github.com/ITSX25-Chas/team1-infra)

Mina tre filer är den här rapporten, [kpi-abdulghani.md](./kpi-abdulghani.md) och [lessons-learned-abdulghani.md](./lessons-learned-abdulghani.md). Rapporten knyter an till kursmål 4, 9, 10, 11 och 13.

---

## 1. Professionell sammanfattning

Team 1 har byggt en molnmiljö i Google Cloud, härdat den och testat säkerheten genom att leta efter flaggor och brister i övningsmiljöerna. Det här är vad ledningen behöver veta.

Läget är att vi är bra på att stänga dörrar men dåliga på att höra när någon försöker öppna dem. I intrångstestet kom en angripare utan inloggning åt interna personuppgifter i målmiljön, och det upptäcktes inte i realtid. En av våra kontroller kunde dessutom vara ur funktion i upp till tio dygn innan någon upptäckte det. I en riktig verksamhet hade det kunnat vara ett dataintrång som vi inte visste om, med risk för regelbrott och förlorat förtroende.

Förbättringsarbetet visar samma mönster. Antalet för breda åtkomstregler i vår egen kod gick från tre till noll, och två av tre driftsättningsflöden körs nu utan sparade nycklar. Men det tog i median 19 dagar från att en svaghet var dokumenterad tills den var borta ur koden, och ingen av de sju bristerna från intrångstestet var åtgärdad och omtestad i tid.

Mina tre lärdomar är att loggar inte är larm, att tystnad inte är trygghet och att manuella steg med hemligheter läcker.

Jag rekommenderar att ledningen prioriterar i den här ordningen: larm i realtid, ett livstecken från varje kontroll, frister för åtgärder med omtest och en städning av hemligheter som ligger i repot. Dessutom behövs ett beslut om vem som äger de breda behörigheterna i den delade molnmiljön. Det kan teamet inte lösa själv eftersom bara miljöns ägare kan ändra dem.

---

## 2. Kontext och avgränsning

Vi började från ett färdigt Terraform-projekt i Google Cloud som vi tog över den 7 september. Det innehöll tre för breda regler: en state-bucket som alla inloggade Google-konton kunde läsa, ett CI/CD-konto med rollen editor och en brandvägg som släppte in all trafik från internet. Vi byggde vidare med GitHub Actions, Workload Identity Federation, OS Login och en jumphost, och i mitten av oktober flyttades infrastrukturen till Comerits miljö ([commit 1426802](https://github.com/ITSX25-Chas/team1-infra/commit/1426802)).

Vi testade också säkerheten genom att hitta flaggor i övningsmiljön Spectre och genom ett intrångstest enligt PTES mot en tilldelad målmiljö. Målmiljön var avsiktligt sårbar och ägs av uppdragsgivaren. Underlaget är repots historik, infraloggen och teamets mätningar. Det är en skolmiljö, men jag bedömer konsekvenserna som om personuppgifterna hade varit verkliga. Behörigheter i den delade molnmiljön ligger utanför vårt mandat.

---

## 3. Mitt individuella bidrag

Jag arbetade nära mina lagkamrater i stället för att ta egna delar. Vi satt tillsammans när vi letade efter flaggor och brister i miljöerna, och det är där det mesta av mitt arbete ligger. Vi hittade båda flaggorna i Spectre, den ena via LookingGlass och den andra genom det som lämnats kvar i Terraform-state, och vi hittade de sju bristerna i målmiljön. Efteråt granskade jag det vi hittat och provade det en gång till för att se om det stämde, och jag var med i arbetet med att åtgärda det.

Den senaste tiden har det mest varit självstudier. Jag tittade på genomgångar på YouTube om red team och CTF, gick igenom det som mitt lag skrev och provade lite på TryHackMe och Hack The Box, eftersom miljöerna liknar de upplägget.

Ett konkret tillfälle är min SSH-nyckel. Jag fick Permission denied trots att nyckeln såg rätt ut, och vi felsökte tills vi såg att fingeravtrycket på servern inte var samma som det klienten erbjöd, troligen eftersom nyckeln ändrats när den skickades via Discord. Jag skapade ett nytt nyckelpar vars publika nyckel lades in genom en separat pull request, och därefter fungerade SSH (infraloggen, fas 7, och [commit 9173e2a](https://github.com/ITSX25-Chas/team1-infra/commit/9173e2a), som Malcolm committade).

Teamets ändringar står mest på Malcolm och Kristoffer, och vid commit ea4756f finns inga commits under mitt eget namn i repot. Mina identifierbara bidrag är därför den här rapporten med KPI-beräkningarna ur git-historiken och SSH-felsökningen ovan. Jag har använt Claude för att gå igenom repots historik och räkna fram siffrorna (se avsnitt 7 och bilagan).

---

## 4. Viktigaste projektresultat och evidens

### Resultat 1: Intrångstestet nådde personuppgifter utan inloggning

**Resultat.** En angripare utan inloggning kunde ta sig hela vägen till interna personuppgifter i målmiljön, och angreppet upptäcktes inte i realtid.

**Evidens.** Teamets testresultat, sammanfattade på slide 6 i ledningspresentationen. Någon separat testrapport ligger inte i `team1-infra`. I Red Team-arbetet kopplades fynden till MITRE ATT&CK, CWE och OWASP.

**Verksamhets- och säkerhetsbetydelse.** I en riktig verksamhet hade personuppgifter kunnat exponeras utan att någon visste om det. Enligt GDPR ska en personuppgiftsincident anmälas till tillsynsmyndigheten inom 72 timmar från att man fått kännedom om den, och det går inte att göra i tid om man aldrig upptäcker incidenten.

**Rekommendation.** Larm i realtid för kända angreppsmönster. Hög prioritet.

### Resultat 2: Hemligheter fanns kvar i Terraform-state och i en incheckad planfil

**Resultat.** Den andra flaggan i Spectre hittades i `terraform.tfstate`, som en base64-kodad hemlighet. Base64 är kodning och inte kryptering. Vid min granskning den 15 november (commit ea4756f) ligger dessutom planfilen `bootstrap/tfplan` incheckad i det publika repot. Den är ett zip-arkiv med kopior av state, och i kopiorna finns nyckelmaterial för CI/CD-kontots gamla nyckel. Jag har inte läst ut nyckeln och kan inte se om den är återkallad.

**Evidens.** Infraloggen, `lag1-infra-logg.md`, avsnitt 10–12. Planfilen lades till i [commit dc1fd59](https://github.com/ITSX25-Chas/team1-infra/commit/dc1fd59), och `.gitignore` utesluter bara `.terraform/` och state-filer (`*.tfstate` och `*.tfstate.*`), inte planfiler.

**Verksamhets- och säkerhetsbetydelse.** Vem som helst kan ladda ner ett publikt repo. Om nyckeln fortfarande är giltig kan den användas utanför GitHub Actions, och den här sortens läcka syns inte i en vanlig kodgranskning.

**Rekommendation.** Ta bort filen ur repot och historiken, återkalla nyckeln och lägg plan-filer i `.gitignore`. Hög prioritet, gör det nu.

### Resultat 3: De breda reglerna försvann, men långsamt

**Resultat.** Av de tre för breda reglerna vi började med var två kvar den 16 september och ingen den 5 oktober. Från dokumenterat fynd till åtgärd i koden tog det 6, 19 och 25 dagar.

**Evidens.** Git-historiken. Commits för [state-bucketen](https://github.com/ITSX25-Chas/team1-infra/commit/bb586a3), [den gamla nyckeln](https://github.com/ITSX25-Chas/team1-infra/commit/dc1fd59), [rollen editor](https://github.com/ITSX25-Chas/team1-infra/commit/674ee01) och [brandväggen](https://github.com/ITSX25-Chas/team1-infra/commit/9d798a8). Kommandon för att kontrollera finns i bilagan.

**Verksamhets- och säkerhetsbetydelse.** Så länge en känd svaghet ligger kvar i koden är den en öppen risk. Dessutom ersattes editor av fyra administratörsroller (`compute.instanceAdmin.v1`, `compute.networkAdmin`, `compute.securityAdmin` och `storage.objectAdmin`), så det blev smalare men är inte minsta behörighet.

**Rekommendation.** Sätt en frist på 14 dagar för kritiska och höga fynd och granska rollerna en gång till. Medel prioritet.

### Resultat 4: Vi har loggar men inga larm

**Resultat.** Signaturkontrollen var ur funktion i upp till tio dygn innan någon upptäckte det. I Terraform-koden finns inga larm eller övervakningsresurser.

**Evidens.** Teamets mätning av tid till upptäckt i `docs/final-report/kpi.md` (Malcolm Skoglund). Loggrättigheten för jumphosten ([commit abb6743](https://github.com/ITSX25-Chas/team1-infra/commit/abb6743)) visar att vi samlar loggar. Jag sökte i `.tf`- och `.yml`-filerna efter alert, notification_channel, monitoring, uptime och alarm utan träff.

**Verksamhets- och säkerhetsbetydelse.** Under de dygnen fanns inget fungerande skydd från den kontrollen, och ett intrång som den skulle ha fångat hade kunnat passera obemärkt.

**Rekommendation.** Ett livstecken från varje kontroll som larmar när det uteblir. Hög prioritet.

---

## 5. KPI:er och ledningsrapportering

Jag har tre KPI:er, en för varje förmåga vi bedömde: förebygga, åtgärda och upptäcka. De fullständiga definitionerna finns i [kpi-abdulghani.md](./kpi-abdulghani.md).

| KPI | Läge | Mål | Mottagare |
|-----|------|-----|-----------|
| 1. Breda åtkomstregler kvar i vår kod | 3, sedan 2, sedan 0 (7/9, 16/9, 5/10) | 0, och aldrig uppåt igen | IT-chef och CISO |
| 2. Tid från dokumenterat fynd till åtgärd | Median 19 dagar, längsta 25 | Kritiska och höga fynd inom 14 dagar | IT-chef och systemägare |
| 3. Tid till upptäckt när en kontroll slutar fungera | Upp till 10 dygn | Högst ett dygn, sedan minuter till timmar | CISO och IT-chef |

KPI:erna visar hur öppna vi är, hur snabbt vi stänger hål och hur länge vi kan sakna ett skydd utan att veta om det. De är begripliga för en icke-teknisk beslutsfattare eftersom de är antal och dagar och inte tekniska mått, och alla går att kontrollera mot repot eller loggarna. Tillsammans visar de att vi har blivit bra på att minska exponeringen men är långsamma på att stänga fynd och på att upptäcka. Det stödjer beslutet att lägga resurser på larm och på en frist för åtgärder före fler förebyggande skydd.

Begränsningarna är att underlaget är litet (tre mätpunkter i KPI 2 och en mätning i KPI 3), att KPI 1 mäter koden och inte allt som körs i molnet, och att 0 av 7 omtestade brister är ett utgångsläge i en miljö vi inte äger. KPI:erna säger inget om hur allvarliga fynden är eller vad ett intrång skulle kosta.

---

## 6. Incidentrespons, post-mortem och förbättringsarbete

Post-mortemen finns i [lessons-learned-abdulghani.md](./lessons-learned-abdulghani.md) och gäller intrångstestet mot den tilldelade målmiljön, där en angripare utan inloggning nådde personuppgifter utan att det upptäcktes i realtid. Händelsen granskades i efterhand utifrån testresultaten och loggarna.

Den viktigaste orsaken är att loggarna samlades in men ingen regel reagerade på dem i realtid, medan vårt arbete främst låg på att förebygga. Konsekvensen är att ett intrång kan pågå obemärkt och att en GDPR-anmälan inom 72 timmar då inte går att göra i tid. Jag drar tre lärdomar: loggar är inte larm, tystnad är inte trygghet och manuella steg med hemligheter läcker.

Förbättringarna är larm i realtid med en rutin för vem som reagerar, ett livstecken från varje kontroll och färre manuella steg med hemligheter, med plan-filer ut ur Git och secret-skanning i pipelinen. De följs upp med KPI 3 och KPI 1 och med ett nytt intrångstest där vi mäter tiden tills larmet går. Det organisationen behöver lära sig är att fråga vem som reagerar när ett skydd slår till, och inte bara om skyddet finns.

---

## 7. AI i säkerhetsarbetet

### Konkreta användningsfall

Jag har använt Claude (Anthropic) i chatten som stöd för den här slutrapporten. Claude hjälpte mig att strukturera rapporten efter kursmallarna, gå igenom repots historik och filer för att hitta evidens, räkna fram KPI:erna ur git-historiken och formulera texten på svenska utifrån det jag berättade om mitt arbete. Claude kontrollerade också filerna mot lärarens krav, till exempel länkar och att inga uppgifter om credentials finns i texten. Vad jag gjorde i projektet, hur jag ser på resultaten och vilka prioriteringar jag föreslår kommer från mig och teamets repo, och jag står för innehållet.

### När AI var lämpligt

Att gå igenom 84 commits och räkna fram datum och före/efter-värden var ett bra uppdrag för AI. Det är mekaniskt och går att kontrollera mot git. AI hittade också att mina filnamn skulle ha skrivit över Malcolms filer och att planfilen `bootstrap/tfplan` låg incheckad med nyckelmaterial i kopior av state. Det hade tagit mig mycket längre tid för hand.

### När AI var olämpligt eller otillräckligt

Första utkastet byggde bara på ledningspresentationen och blev fel på tre punkter. Det påstod att intrångstestet var mot vår egen miljö, när det var mot en målmiljö som uppdragsgivaren äger. Det beskrev 67 % som andel inloggningar, när det är två av tre driftsättningsflöden som körs utan sparade nycklar. Det antog också att det fanns evidens som repot inte har. Det rättades först när AI fick läsa repot och teamets KPI-underlag. Dessutom kan AI inte avgöra om nyckeln i planfilen är återkallad, för det kräver att någon kollar i molnkonsolen. Det är en bedömning som en människa ansvarar för.

### Verifiering och mänsklig kontroll

Alla länkade commits finns i repot och har kontrollerats mot historiken. Siffrorna har räknats om med `git log -S` och `git grep` (kommandon i bilagan) och jämförts med infraloggen och teamets KPI-fil. Planfilen kontrollerades bara på om nyckelmaterial finns, utan att något värde visades i chatten, och filen är redan publik. I den här chatten har jag inte klistrat in några hemligheter.

### Risker och professionella gränser

Hallucinationer är den största risken, och mitt första utkast är ett bra exempel: texten lät säker trots att den var fel. Informationsläckage är en annan, för det som skrivs i en chattjänst lämnar min miljö, så nycklar, lösenord, loggar med personuppgifter och interna adresser ska aldrig klistras in. Det hänger ihop med lärdomen om manuella steg, eftersom att kopiera en hemlighet till en AI-tjänst vore ännu ett sådant steg. AI-texter från samma underlag kan dessutom bli lika varandra, så originalitet och att redovisa AI-användningen är mitt ansvar. Spårbarhet och upphovsrätt är också risker, och man kan börja lita för mycket på resultatet.

### Professionell slutsats

Jag skulle använda AI för att förklara, sammanfatta, strukturera och göra tidsödande men kontrollerbart arbete, som att räkna ur historik eller läsa loggar. Jag skulle inte använda AI ensam för att bedöma risk, för att avgöra om en kontroll faktiskt fungerar eller på material med hemligheter och personuppgifter. Allt AI-genererat som påverkar en miljö ska testas i en testmiljö och kontrolleras mot officiell dokumentation, och jag står själv för resultatet. På en arbetsplats skulle jag vilja ha en policy för vad som får delas med AI-verktyg och att användningen dokumenteras.

---

## 8. Prioriterade rekommendationer

| Nr | Vad som bör göras | Varför och risk | Prioritet | Förslag på ägare |
|----|-------------------|-----------------|-----------|------------------|
| 1 | Städa hemligheter ur repot: ta bort `bootstrap/tfplan` ur repot och historiken, återkalla nyckeln, lägg plan-filer i `.gitignore` och inför secret-skanning | Nyckelmaterial ligger i ett publikt repo (resultat 2) | Hög, nu | Teamet, med driftansvarig som kontrollerar att nyckeln är återkallad |
| 2 | Larm i realtid för kända angreppsmönster | Intrångstestet nådde personuppgifter utan att det upptäcktes i realtid (KPI 3) | Hög | IT-chef eller CISO beslutar, driftteamet genomför |
| 3 | Livstecken från varje kontroll som larmar när det uteblir | En kontroll låg nere i upp till tio dygn (KPI 3) | Hög | Driftansvarig |
| 4 | Frist på 14 dagar för kritiska och höga fynd, med omtest, och granska de nya administratörsrollerna | Median 19 dagar och 0 av 7 omtestade (KPI 2) | Medel till hög | Systemägare |
| 5 | Besluta vem som äger de breda behörigheterna i den delade molnmiljön, med en frist | Bara miljöns ägare kan ändra dem och teamet saknar mandat | Hög, kräver beslut | Ledningsgruppen och ägaren av molnmiljön |

Jag har hållit listan kort. Nummer 1 är akut eftersom den gäller något som redan ligger publikt, 2 och 3 gäller den svagaste förmågan (upptäcka), 4 gäller att åtgärda och 5 är ett ledningsbeslut. Prioritet och ägare är mina förslag.

---

## 9. Individuell reflektion

### Vad kan jag nu som jag inte kunde när kursen började?

Jag kan läsa Terraform-state, git-historik och loggar som bevismaterial. I Spectre följde vi ledtråden om vad som lämnats kvar, hittade en hemlighet i `terraform.tfstate` och avkodade den, och jag förstår varför state måste behandlas som känsligt. Jag kan också räkna fram enkla KPI:er direkt ur git, till exempel hur många dagar ett fynd låg kvar, och förklara dem för någon som inte är tekniker. Jag har också lärt mig att länka varje påstående till en commit eller en loggrad, så att en annan person kan kontrollera det själv i stället för att behöva lita på mig.

### Vilket moment har förändrat mitt sätt att arbeta med cybersäkerhet mest?

Att gå tillbaka och granska och prova om saker i efterhand. Det har ändrat hur jag ser på ordet klart, för något är inte klart förrän det är omtestat. Siffrorna 0 av 7 omtestade brister och en kontroll som kunde vara ur funktion i upp till tio dygn visar samma sak: det man inte testar om vet man inte.

### Vad skulle jag göra annorlunda om projektet började idag?

Jag skulle skapa egna commits och pull requests så att mitt bidrag syns i repot. Jag skulle samla bevis medan vi jobbar, för i `SECURITY-ISSUES.md` står det "Fylls i efter verifiering" i åtta av elva poster. Jag skulle sätta larm och livstecken från början och inte checka in planfiler. Och jag skulle jämföra fingeravtryck direkt när en SSH-nyckel inte fungerar, som i min egen felsökning.

### Vad tar jag med mig till LIA och min framtida yrkesroll?

För det första att fråga vem som reagerar när ett skydd slår till, och inte bara om skyddet finns. För det andra att mäta med enkla KPI:er som går att kontrollera i historik och loggar och att visa begränsningarna. För det tredje att aldrig lägga hemligheter, state eller plan-filer i Git, och att använda AI som hjälp med kontroll och ansvar och inte som ersättning för det.

---

## 10. Källor och referenser

Jag skiljer på projektets evidens **[P]**, kursmaterial **[K]**, externa källor **[E]**, AI-genererat material **[AI]** och egna bedömningar **[Egen]**.

- **[P]** Repositoryt [`team1-infra`](https://github.com/ITSX25-Chas/team1-infra) (läst på commit ea4756f): `.github/workflows/deploy.yml`, `main.tf`, `bootstrap/main.tf`, `network-hardening.tf`, `lag1-infra-logg.md` och `SECURITY-ISSUES.md`.
- **[P]** Teamets commits, främst av Malcolm Skoglund och Kristoffer Toivanen: [bb586a3](https://github.com/ITSX25-Chas/team1-infra/commit/bb586a3), [dc1fd59](https://github.com/ITSX25-Chas/team1-infra/commit/dc1fd59), [674ee01](https://github.com/ITSX25-Chas/team1-infra/commit/674ee01), [9d798a8](https://github.com/ITSX25-Chas/team1-infra/commit/9d798a8), [abb6743](https://github.com/ITSX25-Chas/team1-infra/commit/abb6743), [1426802](https://github.com/ITSX25-Chas/team1-infra/commit/1426802) och [9173e2a](https://github.com/ITSX25-Chas/team1-infra/commit/9173e2a).
- **[P]** Teamets KPI-underlag, `docs/final-report/kpi.md` (Malcolm Skoglund): källa till 2 av 3 nyckellösa driftsättningsflöden, tio dygn och 0 av 7. Definitioner, mål och tolkning är mina.
- **[P]** Ledningspresentationen `Ledningsrapportering_Team1_professionell.pptx`, slide 4, 6, 7, 8, 9 och 10.
- **[P]** Teamets Red Team-material: presentationen om intrångstestet med fynd, attackkedja och åtgärder.
- **[P]** Teamets säkerhetsrapport från Blue Team-arbetet och sammanfattningen av Blue Teams arbete (åtgärder, verifiering och lärdomar).
- **[K]** Kursens instruktion för slutarbetet och mallarna för KPI:er, lessons learned och individuell slutrapport.
- **[E]** [PTES](http://www.pentest-standard.org/) (Penetration Testing Execution Standard), metoden för intrångstestet.
- **[E]** [MITRE ATT&CK](https://attack.mitre.org/), [CWE](https://cwe.mitre.org/) och [OWASP](https://owasp.org/), som användes för att beskriva och klassa fynden i Red Team-arbetet.
- **[E]** Videor på YouTube om red team och CTF som jag tittade på under självstudierna för att förstå metoderna.
- **[E]** Övningsplattformarna [TryHackMe](https://tryhackme.com/) och [Hack The Box](https://www.hackthebox.com/), där jag har provat lite på flaggbaserade miljöer.
- **[E]** Europaparlamentets och rådets förordning (EU) 2016/679 (GDPR), artikel 33, om anmälan av personuppgiftsincident.
- **[AI]** Claude (Anthropic) som stöd för struktur, genomgång av repot, uträkning av KPI:erna och formulering av texten utifrån det jag berättat. Se avsnitt 7.
- **[Egen]** Mina bedömningar: målvärden, prioriteringar, förslag på ägare och valet av KPI 1 och 2, som jag har räknat fram ur git-historiken med stöd av AI.

---

## Bilaga: så kontrollerar du siffrorna

```bash
git clone https://github.com/ITSX25-Chas/team1-infra && cd team1-infra

# När de tre breda reglerna infördes och togs bort
git log -S'roles/editor'          --format='%h %ad %an %s' --date=short -- '*.tf'
git log -S'allAuthenticatedUsers' --format='%h %ad %an %s' --date=short -- '*.tf'
git log -S'0.0.0.0/0'             --format='%h %ad %an %s' --date=short -- '*.tf'

# Antal träffar idag (förväntat 0) och den 16 september (förväntat 1, 0 och 2 rader)
for p in 'roles/editor' 'allAuthenticatedUsers' '0.0.0.0/0'; do
  git grep -F "$p" -- '*.tf' | wc -l
  git grep -F "$p" $(git rev-list -1 --before='2026-09-16 23:59' HEAD) -- '*.tf' | wc -l
done

# Bevisfält som inte är ifyllda: 8 av 11 poster
grep -c 'Fylls i efter verifiering' SECURITY-ISSUES.md
```

Raden för `0.0.0.0/0` den 16 september visar två rader eftersom den även räknar standardrutten via jumphosten, men det är brandväggsregeln som är det breda hålet.
