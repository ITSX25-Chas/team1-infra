# Individuell slutrapport

**Namn:** Kristoffer Toivanen  
**Projekt/team:** ITSX25, kurs 6 – Avancerad IT-säkerhet, Team 1  
**Datum:** 2026-11-15

## Syfte och kursmål

Rapporten omsätter projektets tekniska säkerhetsarbete till ett beslutsunderlag för en fiktiv ledningsgrupp. Den behandlar kursmål 4, 9, 10, 11 och 13 genom evidensbaserad rapportering, KPI:er, post-mortem, professionell AI-användning och prioriterat förbättringsarbete.

## 1. Professionell sammanfattning

Projektet omfattade både säkerhetshärdning av Team 1:s egen molnbaserade miljö och penetrationstest av en separat, avsiktligt sårbar internportal. Syftet var att identifiera risker, verifiera säkerhetsbrister och ta fram underlag för förbättringar.

Blue Team dokumenterade 20 säkerhetsfynd, varav fyra kritiska och sex höga. För 19 fynd redovisades helt eller delvis genomförda åtgärder. Slutverifieringen visade 27 av 28 godkända infrastrukturkontroller och 15 av 15 godkända applikationstester. Kvarstående risker rör bland annat behörigheter i det delade molnprojektet och reproducerbar konfiguration.

Red Team verifierade sex huvudsakliga fyndgrupper på målservern, tre kritiska och tre höga, och återfann fem flaggor. Bristerna möjliggjorde förbikoppling av autentisering, administrativ åtkomst, kommandokörning och läsning av intern information och en skyddad fil. Fullständigt övertagande av molnservern verifierades inte. Resultaten visar varför säkerhetskontroller behöver fungera tillsammans och varför intern nätåtkomst inte automatiskt bör innebära förtroende.

Jag prioriterar återställningsförmåga i ledningsrapporteringen. Tre föreslagna KPI:er mäter faktisk återställningstid, möjlig dataförlust och andel kritiska återställningsobjekt med verifierad återställning. Tillgängligt underlag räcker inte för att fastställa dessa mätvärden. De redovisade säkerhetstesterna får inte förväxlas med ett bevis på katastrofåterställning.

Ledningen bör prioritera åtgärder mot kritiska brister i målmiljön, central granskning av molnbehörigheter i den egna miljön, testade detektionsregler och en isolerad återställningsövning. Systemägaren behöver fastställa acceptabel avbrottstid och dataförlust samt tilldela ansvar för uppföljning. Resultat ska bedömas utifrån verifierad effekt, inte enbart genomförda aktiviteter. Förslagen avser laborationsprojektet och behöver anpassas till verksamhetens faktiska kritikalitet innan de används som produktionskrav.

## 2. Kontext och avgränsning

Projektet genomfördes inom kurs 6 och omfattade två säkerhetskontexter. Blue Team granskade Team 1:s egen GCP-miljö med Terraform, IAM, SSH, Headscale, Kubernetes/k3s, Flask, CI/CD och säkerhetsövervakning. Red Team genomförde ett avgränsat penetrationstest av Acme Corp Internportal i den tilldelade målmiljön, separat från den egna applikationen.

Underlaget består av teamets tekniska rapporter, dokumenterade HTTP-svar, terminalutdata, sammanställda konfigurationskontroller och den efterföljande redovisningen av försvarsloggar. Testet mot Acme följde avgränsningar i Rules of Engagement; inga överbelastningsangrepp eller beständig åtkomst ingick. Rapporten gör inga nya anspråk på genomförda tester eller åtgärder. Riskbedömningarna är kvalitativa och inte CVSS-poäng. KPI-målen är förslag, eftersom verksamhetens faktiska kontinuitetskrav inte är fastställda. De två miljöernas fynd och verifieringsresultat hålls åtskilda för att undvika felaktiga slutsatser om vilken miljö som har åtgärdats.

## 3. Mitt individuella bidrag

Mitt arbete har framför allt omfattat praktisk säkerhetsanalys och dokumentation av penetrationstestet. Jag deltog i undersökningen av målmiljön och arbetade med att förstå hur en angripare kan gå från en oautentiserad webbåtkomst till åtkomst på system- och datanivå. I arbetet använde jag HTTP-anrop och terminalutdata för att bedöma vad som faktiskt hade verifierats och vilka slutsatser som kunde dras.

En viktig del av mitt bidrag var att skilja mellan kommandokörning som applikationsanvändare, läsning av en root-skyddad fil via SUID och ett fullständigt root-övertagande. Dessa är olika säkerhetsresultat och bör inte rapporteras som likvärdiga. Jag har även arbetat med att sammanställa tekniska fynd i en rapportstruktur där reproduktion, bevis, konsekvens och rekommenderad åtgärd går att följa.

Samarbetet har bestått i att använda teamets gemensamma testunderlag och jämföra resultat från olika testtillfällen. Jag har valt att inte tillskriva mig själv samtliga tekniska aktiviteter eller Blue Team-åtgärder, eftersom de är gemensamma resultat.

I slutleveransen har jag tagit fram en sammanhängande redovisning av Red Team och Blue Team samt föreslagit återställningsförmåga som grund för ledningens KPI-uppföljning. Mina identifierbara dokumentationsbidrag är pentest­rapporten daterad 27 oktober, sammanställningen av de två säkerhetsrapporterna och denna individuella leverans med [KPI:er](./kpi.md) och [lessons learned](./lessons-learned.md). Individuella commit-referenser anges inte eftersom de inte har verifierats i underlaget.

## 4. Viktigaste projektresultat och evidens

### Resultat 1 – Förbikopplad autentisering och kommandokörning

**Resultat:** SQL-injektion och manipulerad rollcookie gav alternativa vägar till administrativ åtkomst. Diagnostikfunktionen möjliggjorde kommandokörning som appuser.

**Evidens:** [R], F-01–F-03, bevis E-04–E-06; [P], tekniska fynd och reproduktionssteg.

**Verksamhets- och säkerhetsbetydelse:** En oautentiserad angripare kan få åtkomst till administrativa funktioner och använda tjänsten för vidare angrepp. Kombinationen ger större konsekvens än en isolerad brist.

**Rekommendation:** Applikationsägaren åtgärdar parametrisering, serverbaserad auktorisering och osäker skalexekvering. Prioritet P0; återtest krävs före stängning.

### Resultat 2 – Intern dataåtkomst och privilegierad filläsning

**Resultat:** Den komprometterade applikationen kunde nå en intern exporttjänst. En SUID-satt find-binär gjorde det möjligt att läsa en root-skyddad fil. Ingen interaktiv root-shell eller containerescape verifierades i det senare testet.

**Evidens:** [R], F-04–F-05, avsnitt 6 och bevis E-07–E-08.

**Verksamhets- och säkerhetsbetydelse:** Interna tjänster kan exponeras trots att de inte nås direkt utifrån. Felaktiga lokala privilegier ökar omfattningen av en kompromettering.

**Rekommendation:** Plattformsteamet tar bort onödiga SUID-rättigheter (P0) och applikationsägaren inför tjänsteautentisering, nätbegränsning och dataminimering (P1).

### Resultat 3 – Verifierad härdning med kvarstående IAM-risk

**Resultat:** Blue Team dokumenterade 20 fynd och helt eller delvis genomförda åtgärder för 19. Sluttestet godkände 27 av 28 infrastrukturkontroller och 15 av 15 applikationstester, inklusive fyra åtkomstkontrolltester. Breda IAM-rättigheter i det delade projektet kvarstår delvis utanför teamets mandat.

**Evidens:** [B], sammanfattning, F-02 och slutverifiering den 8 oktober 2026.

**Verksamhets- och säkerhetsbetydelse:** Härdningen har verifierad effekt inom testernas omfattning. Den kvarvarande behörighetsrisken kan däremot möjliggöra ändringar av resurser och kräver beslut på en högre ansvarsnivå.

**Rekommendation:** Molnprojektets ägare genomför central IAM-granskning och tillämpar minsta privilegium. Prioritet P1. Dokumentera kvarstående risk och ansvar.

### Resultat 4 – Spårbarhet och otillräckligt styrkt återställningsförmåga

**Resultat:** Försvarsloggar möjliggjorde enligt Red Team-rapporten efterhandskorrelation av testaktiviteter. Underlaget fastställer inte realtidsdetektion eller uppmätt återställningsförmåga.

**Evidens:** [R], avsnitt 7 och E-10; [B], sammanfattning och verifieringsresultat. [K] redovisar föreslagen mätning, inte nya testresultat.

**Verksamhets- och säkerhetsbetydelse:** Organisationen kan inte enbart utifrån loggarnas existens eller godkända säkerhetstester bedöma incidentresponsens snabbhet eller tiden till återställd verksamhet.

**Rekommendation:** Säkerhetsansvarig testar larmkedjan och driftansvarig genomför en isolerad återställningsövning. Prioritet P1.

## 5. KPI:er och ledningsrapportering

Jag har valt tre KPI:er som tillsammans mäter organisationens återställningsförmåga. Fullständiga definitioner och uppföljningsrutiner finns i [kpi.md](./kpi.md).

| KPI | Föreslaget mål | Nuläge |
| --- | --- | --- |
| Faktisk återställningstid (RTA) | RTO ≤ 4 timmar | Ej uppmätt |
| Faktiskt dataförlustfönster | RPO ≤ 24 timmar | Ej uppmätt |
| Verifierad återställningstäckning | 100 % av kritiska objekt | Ej beräkningsbar |

För en beslutsfattare motsvarar måtten tre konkreta frågor: hur länge kan vi vara utan tjänsten, hur mycket data kan vi förlora och hur vet vi att vi kan återställa den? RTO och RPO är mål, inte uppmätta resultat. Jag vill undvika att ett lyckat backupjobb felaktigt rapporteras som bevis på återställningsbarhet.

Ledningen kan använda utvecklingen för att prioritera automatisering, tätare backup, isolerad lagring och återställningsövningar. Avvikelser ska leda till en utsedd ansvarig, analys och nytt verifieringstest. Saknad evidens rapporteras som okänd status, inte som grönt resultat eller noll procent utan nämnare. Målen behöver godkännas av systemägaren och anpassas till tjänstens kritikalitet.

KPI:erna visar inte förmågan att förebygga intrång, förhindra informationsläckage eller upptäcka en komprometterad backup. Därför kompletteras de med säkerhetskontroller, sårbarhetsuppföljning, loggning och skydd av backupmiljön. Det handlar om att mäta återställning som en faktisk förmåga, inte bara aktivitet.

## 6. Incidentrespons, post-mortem och förbättringsarbete

Post-mortem gäller penetrationstestet av Acme Corp i oktober 2026. Bristerna upptäcktes genom avgränsade HTTP-anrop och teknisk verifiering. Testet visade att en angripare kunde kringgå inloggning och erhålla system- och dataåtkomst. Försvarsloggar som mottogs den 4 november analyserades enligt rapportunderlaget i efterhand. Det är inte fastställt vilka händelser som genererade larm under testet. Ändringsstoppet innebar att avhjälpande åtgärder inte skulle utföras på målmiljön under testfönstret.

De tre centrala lärdomarna i [lessons-learned.md](./lessons-learned.md) är att serverbaserade säkerhetskontroller måste fungera även vid manipulerad klientdata, att loggning behöver kompletteras med verifierad detektion och att återställningsförmåga måste testas separat från förebyggande säkerhet. Rotorsakerna som kan styrkas är främst brister i validering, auktorisering och privilegier. Organisatoriska orsaker och realtidsrespons är inte fullt fastställda.

Förbättringsarbetet bör därför bestå av säkerhetsregressionstester, övning av larm- och incidentkedjan samt en isolerad återställningsövning. Kritiska fynd stängs först efter godkänt återtest; detektion följs upp med bekräftade larm och tidsstämplar. Återställningen följs upp med de tre föreslagna kontinuitetsmåtten. Denna struktur gör det möjligt att skilja mellan observerade händelser, hypotetiska konsekvenser och verifierad förbättring.

## 7. AI i säkerhetsarbetet

### Konkreta användningsfall

Jag har använt generativa AI-assistenter, bland annat ChatGPT, som stöd för teknisk analys och dokumentation. I pentestarbetet har AI hjälpt mig att strukturera frågeställningar kring HTTP-svar, autentisering, kommandokörning och rättighetseskalering. Vid rapporteringen har jag använt AI för att organisera fynd, skilja observationer från slutsatser och formulera rekommendationer. AI har även använts vid sammanställningen av Red Team- och Blue Team-rapporterna och som stöd för att formulera KPI-definitioner och denna slutrapport.

Jag skiljer mellan en generativ assistent och ett tekniskt testverktyg. Curl och Nmap ger observerbara resultat från målmiljön; AI kan hjälpa till att tolka dessa men ersätter inte själva mätningen. Jag har inte tillräckligt underlag för att hävda att ett särskilt AI-assisterat skanningsverktyg användes eller verifierade projektets fynd.

### När AI var lämpligt

Ett konkret exempel är analysen av rättighetseskaleringen. AI kan hjälpa till att förklara skillnaden mellan användaridentitet, SUID-rättigheter och faktisk kontroll över ett operativsystem. När testutdata visade appuser och efterföljande läsning av en root-skyddad fil var det viktigt att rapporteringen inte automatiskt beskrev resultatet som en root-shell. AI var användbart som diskussionsstöd för att formulera en mer precis slutsats.

En annan nytta är strukturering av tekniska rapporter. Genom att organisera fynd efter bevis, risk, åtgärd och verifiering blir dokumentationen lättare för andra att granska. AI kan också hjälpa till att omvandla tekniska resultat till verksamhetsrisker och föreslå mätetal. Detta sparar tid, förutsatt att innehållet kontrolleras mot underlaget.

### När AI var olämpligt eller otillräckligt

AI bör inte ensam avgöra om ett system är komprometterat, om en sårbarhet är åtgärdad eller om ett kommando får köras inom ett penetrationstest. Ett trovärdigt formulerat svar kan innehålla felaktiga kommandon, antaganden om miljön eller rekommendationer som går utanför Rules of Engagement.

Ett tydligt exempel är återställningsförmågan. AI kan föreslå RTO och RPO men kan inte härleda verklig återställningstid från antalet godkända infrastrukturtester. Ett påhittat mätvärde skulle ge ledningen ett missvisande beslutsunderlag. På samma sätt kan AI inte fastställa att försvarssidan reagerade på en attack enbart för att logghändelser finns dokumenterade.

### Verifiering och mänsklig kontroll

Jag har utgått från observerade HTTP-svar, terminalutdata, flaggor och teamets dokumenterade kontroller när jag bedömt resultat. För rapporteringen jämför jag AI-genererade formuleringar mot Red Team- och Blue Team-underlagen. Skillnaderna mellan testtillfällena den 20 och 27 oktober måste bevaras, och föreslagna åtgärder får inte beskrivas som genomförda utan evidens.

Vid framtida arbete bör varje tekniskt AI-förslag verifieras mot dokumentation, källkod eller ett godkänt test i rätt miljö. En AI-genererad klassificering inom CWE eller MITRE ATT&CK behöver granskas mot den faktiska svagheten respektive angriparens beteende. Slutlig riskbedömning och godkännande ska göras av ansvarig människa.

### Risker och professionella gränser

De viktigaste riskerna är hallucinationer, överdriven säkerhet i slutsatser, informationsläckage och bristande spårbarhet. Lösenord, tokens, verkliga personuppgifter och känsliga konfigurationer ska inte lämnas till en extern AI-tjänst utan godkänd informationshantering. Även innehåll från loggar och webbplatser kan vara opålitligt och får inte behandlas som instruktioner till assistenten. AI-genererad kod måste dessutom granskas för säkerhetsbrister och licensfrågor.

### Professionell slutsats

Jag ser AI som ett effektivt analys- och dokumentationsstöd, men inte som en självständig säkerhetsauktoritet. Min princip är att använda AI där resultatet kan verifieras, begränsa vilken information som delas och behålla mänskligt ansvar för testomfattning, riskbeslut och produktionsändringar. När verifiering saknas ska slutsatsen uttryckligen anges som osäker eller föreslagen.

## 8. Prioriterade rekommendationer

| Prioritet | Åtgärd | Motivering och risk | Ansvarig funktion |
| --- | --- | --- | --- |
| P0 | Åtgärda SQL-injektion, klientstyrd auktorisering, kommandoinjektion och felaktig SUID i Acme | Förhindrar verifierade vägar till administrativ och privilegierad åtkomst. Återtest krävs. | Applikationsägare och plattformsteam |
| P1 | Granska IAM centralt i Team 1:s delade GCP-projekt | Minskar risk för obehöriga molnändringar; kräver mandat utanför teamet. | Molnprojektets ägare |
| P1 | Fastställ RTO/RPO och genomför isolerad återställningsövning | Ger evidens för avbrottstid, dataförlust och återställningstäckning. | Systemägare och driftansvarig |
| P1 | Skydda intern export och profilåtkomst i Acme | Minskar risken för obehörig åtkomst till personuppgiftsfält. | Applikationsägare |
| P1 | Testa central loggning, detektion och incidentprocess | Säkerställer att registrerade händelser leder till verifierbar upptäckt och hantering. | Säkerhetsansvarig |

P0 avser omedelbar åtgärdsprioritet för den fiktiva systemägaren efter godkänt ändringsfönster. P1 avser nästa planerade förbättringsetapp. Förslagen innebär inte att åtgärderna redan är utförda.

## 9. Individuell reflektion

### Vad kan jag nu som jag inte kunde när kursen började?

Jag har fått en tydligare praktisk förståelse för hur flera sårbarheter kan kombineras till en angreppskedja. Tidigare kunde jag beskriva exempelvis bristande autentisering och kommandoinjektion som separata risker. Genom arbetet med internportalen har jag utvecklat min förmåga att analysera hur en initial åtkomst kan leda vidare till administrativa funktioner, intern dataåtkomst och privilegierad filläsning.

Jag har också utvecklat min förmåga att dokumentera tekniska bevis och avgränsa slutsatser. Ett konkret exempel är att läsning av en root-skyddad fil inte behöver innebära att jag har fått fullständig root-kontroll. Den distinktionen är viktig för att rapporten ska vara tekniskt korrekt.

### Vilket moment har förändrat mitt sätt att arbeta med cybersäkerhet mest?

Det praktiska penetrationstestet har varit det mest betydelsefulla momentet för mig. Jag har sett hur en applikation kan ge en falsk trygghet genom att uppvisa en inloggningssida eller vara placerad i ett privat nät, trots att själva behörighetskontrollen är bristfällig.

Samtidigt anser jag att momentet hade kunnat ge betydligt större kunskapsmässigt utbyte om vi hade fått en strukturerad undervisning i penetrationstestning och etisk hacking, så som det utlovades när vi sökte utbildningen. Att genomföra ett penetrationstest är inte detsamma som att få utbildning i hur ett professionellt penetrationstest planeras, genomförs och utvärderas.

En stor del av kunskapsinhämtningen har i stället fått ske genom självstudier, egna efterforskningar, praktiska försök och användning av AI som stöd. Även om detta har utvecklat min självständighet och problemlösningsförmåga, hade en tydligare pedagogisk progression med lärarledda genomgångar, praktiska demonstrationer och återkoppling på våra metoder kunnat ge en betydligt djupare förståelse för ämnet.

Jag ser därför penetrationstestningen som ett av utbildningens mest intressanta och yrkesrelevanta moment, men också som ett moment där utbildningen inte fullt ut har motsvarat de förväntningar som skapades inför utbildningsstarten.

Jag har även blivit mer uppmärksam på skillnaden mellan en genomförd säkerhetskontroll och en verifierad säkerhetsförmåga. Det gäller särskilt backup. Att en säkerhetskopia finns innebär inte att verksamheten kan återställas snabbt eller utan oacceptabel dataförlust. Detta har påverkat mitt val av KPI och förstärkt min uppfattning att professionellt säkerhetsarbete måste bygga på verifierbara resultat, snarare än antaganden om att införda säkerhetsåtgärder fungerar som avsett.

### Vad skulle jag göra annorlunda om projektet började idag?

Jag hade velat inleda projektet med en tydlig målbild, en gemensam projektstruktur, definierade roller och en test- och evidensplan. Min upplevelse är att kursens struktur och undervisningsstöd varit otillräckliga, vilket gjort att mycket av arbetet behövt organiseras och förstås på egen hand. För mig har det inneburit att teknisk problemlösning och dokumentation delvis fått ersätta en tydligt planerad utbildningsprogression.

Jag skulle därför tidigt definiera vad som ska levereras, vilka kontroller som ska verifieras och hur varje resultat ska dokumenteras. Jag hade också planerat en återställningsövning från början i stället för att först i slutrapporteringen konstatera att mätunderlag saknas. Det hade gett bättre spårbarhet och gjort det enklare att bedöma projektets faktiska effekt.

### Vad tar jag med mig till LIA och min framtida yrkesroll?

Jag tar med mig vikten av att arbeta evidensbaserat: en säkerhetsbrist ska kunna reproduceras, en åtgärd ska återtestas och en risk ska beskrivas utan att överdriva vad som har verifierats. Detta är direkt användbart vid säkerhetsgranskningar och teknisk rapportering.

Jag tar även med mig ett kontinuitetsperspektiv. I en yrkesroll vill jag kunna visa att en verksamhet har en fungerande återställningsplan, inte bara att backupjobb är konfigurerade. Genom att kombinera tekniska tester med RTO, RPO och verifierad återställning kan jag kommunicera säkerhetens betydelse för både tekniker och beslutsfattare. Slutligen vill jag använda AI som ett kontrollerat stöd, samtidigt som ansvar, källkritik och teknisk verifiering förblir mänskliga uppgifter.

## 10. Källor och referenser

- **[P]** Pentest_Rapport_Acme_Team1_2026-10-27(1).docx. Team 1, 27 oktober 2026. Ursprunglig teknisk pentest­rapport och reproduktionsunderlag.
- **[R]** Penetrationstest — Acme Corp Internportal.docx. Team 1, 4 november 2026. Fynd F-01–F-06, bevisregister, post-mortem, rekommendationer och Rules of Engagement. Loggpaketet team1_postmortem_loggar.zip och SHA-256-manifestet beskrivs i rapporten; originalpaketet har inte granskats på nytt i denna sammanställning.
- **[B]** Säkerhetsgranskning och fyndrapport, Team 1.docx. Team 1, 8 oktober 2026. Blue Team-fynd och slutverifiering.
- **[D]** Red Team-delrapport_ company-website.docx. Team 1, 20 oktober 2026. Tidigare observationer; behandlas separat från senare testresultat.
- **[K]** [kpi.md](./kpi.md). Egna föreslagna definitioner, mål och uppföljningsrutiner.
- **[L]** [lessons-learned.md](./lessons-learned.md). Individuell post-mortem och förbättringsförslag.
- **[A]** OpenAI, ChatGPT. AI-assisterad analys, rapportstruktur och formuleringar i projektets dokumentationsarbete och denna slutleverans. AI är stöd, inte självständig teknisk evidens.

Projektets sammanställda leveranser är Red_Team_Rapport_Team1.docx och Blue_Team_Rapport_Team1.docx. Följande repositoryreferenser anges i [R], bilaga B. De är projekthänvisningar, inte verifierade individuella commits: [team1-infra](https://github.com/ITSX25-Chas/team1-infra), [team1-company-website](https://github.com/ITSX25-Chas/team1-company-website), [team1-documentation](https://github.com/ITSX25-Chas/team1-documentation).

## Slutkontroll

- [x] Eget bidrag beskrivet och identifierbara rapportartefakter angivna.
- [x] Projektresultat kopplade till evidens.
- [x] Tre ledningsanpassade KPI:er med begränsningar.
- [x] Post-mortem med förbättringar och uppföljning.
- [x] Konkret AI-användning, verifiering och professionell värdering.
- [x] Prioriterade rekommendationer och individuell reflektion.
- [ ] Bekräfta individuella formuleringar och komplettera med egna commits där möjligt.
- [ ] Kontrollera repositorylänkar och att alla refererade artefakter finns tillgängliga för mottagaren.
- [ ] Kontrollera hela repositoryt för skyddsvärda uppgifter före publicering.
- [ ] Commit och push till GitHub.
