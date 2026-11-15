# Post-mortem, lessons learned och professionell sammanfattning

## Syfte och kursmål

Kursmål 9 och 13. Jag utgår från Team 1:s simulerade intrång mot Acme Corp Internportal och efterföljande analys av testbevis och försvarsloggar. Syftet är att identifiera förbättringar i förebyggande säkerhet, detektion och återställning.

## Händelse och avgränsning

I oktober 2026 genomförde Team 1 ett avgränsat penetrationstest mot en avsiktligt sårbar webbapplikation i Google Cloud. Under den senare testsessionen den 27 oktober verifierades förbikoppling av inloggning, administrativ åtkomst, kommandokörning som appuser, åtkomst till en intern exporttjänst och läsning av en root-skyddad fil via en felkonfigurerad SUID-binär. Samtliga fem flaggor återfanns. Bristerna upptäcktes genom kontrollerade HTTP-anrop och analys av svar och terminalutdata. Försvarssidans loggar, mottagna den 4 november, användes enligt Red Team-rapporten för efterhandsanalys. Min del av arbetet var den tekniska pentestanalysen, tolkning av testresultat och sammanställning av evidens och rapportering. Jag skiljer detta från operativ incidentrespons på försvarssidan, som jag inte kan styrka att jag utförde. Ändringsstoppet innebar att åtgärder på målet inte genomfördes under testet. Post-mortem gäller denna övning, inte ett verkligt intrång i produktion.

## Lesson learned 1

### Observation
SQL-injektion och manipulerad rollcookie gav alternativa vägar till administrativ åtkomst. Diagnostikfunktionen möjliggjorde därefter operativsystemskommandon. Se [R], F-01–F-03.

### Orsak
Servern litade på klientstyrd information utan tillräcklig validering eller serverbaserad auktorisering. SQL-frågor och skalexekvering hanterade användarinmatning osäkert. Det är verifierade tekniska brister; någon specifik organisatorisk rotorsak är inte fastställd.

### Konsekvens
En angripare kunde kringgå autentisering och använda applikationen som plattform för vidare åtkomst. Enbart skydd av nätverksperimetern skulle inte eliminera denna risk.

### Förbättring
Parametrisera SQL-frågor, använd verifierad serverbaserad sessionsidentitet och ta bort osäker skalexekvering. Applikationsägaren inför negativa säkerhetstester som blockerar release vid regression.

### Uppföljning
Återtesta de dokumenterade reproduktionsstegen inom godkänt testfönster. Kontrollera att otillåtna anrop nekas, att inga kommandon exekveras och att legitima funktioner fortfarande fungerar. Dokumentera godkänt återtest per fynd.

## Lesson learned 2

### Observation
Loggar från webb-, databas- och intern tjänst kunde enligt [R], avsnitt 7, korreleras med testaktiviteter. Loggarna visar däremot inte vilka händelser som utlöste larm eller uppmärksammades i realtid. Jumphostens IP identifierar en åtkomstväg, inte en enskild person.

### Orsak
Registrering av händelser och verifierad incidentdetektion är olika förmågor. Underlaget saknar fullständig larmhistorik och tidsstämplar för bekräftad upptäckt och hantering. Detta är en evidensbegränsning, inte bevis för att larm saknades.

### Konsekvens
Det går att rekonstruera delar av angreppet men inte att fastställa hur snabbt en försvarare skulle ha reagerat. En angripare kan därför hypotetiskt hinna nå ytterligare resurser innan en incident hanteras.

### Förbättring
Säkerhetsansvarig inför central loggkorrelation och dokumenterade larmregler för misstänkt autentisering, oväntad kommandokörning och åtkomst till intern export. Incidentärenden ska dokumentera upptäckt, triage, beslut och avslut.

### Uppföljning
Genomför en kontrollerad övning där testhändelser genereras, larm verifieras och tid till bekräftad upptäckt samt respons registreras. Kontrollera tidsbas, källidentitet och spårbarhet från larm till ärende. Rapportera även uteblivna larm.

## Lesson learned 3

### Observation
Angreppet gav åtkomst till intern data och en root-skyddad fil, men ingen destruktiv påverkan eller fullständig återställning testades. Blue Team dokumenterade 27 av 28 godkända infrastrukturkontroller och 15 av 15 applikationstester; dessa bevisar inte återställningsförmåga. Se [R], avsnitt 6, och [B], sammanfattning.

### Orsak
Projektets dokumenterade säkerhetskontroller och pentest fokuserade på andra förmågor än fullständig katastrofåterställning. Det tillgängliga underlaget saknar tillräckliga återställningsprotokoll för att fastställa faktisk återställningstid och möjlig dataförlust. Det innebär inte att backup saknas.

### Konsekvens
Vid ett verkligt intrång där data eller konfiguration förstörs kan organisationen inte utifrån dessa rapporter förutse avbrottets längd eller dataförlusten. En återställning från en komprometterad kopia kan dessutom återinföra brister.

### Förbättring
Systemägaren fastställer RTO och RPO samt en återställningsinventering. Driftansvarig dokumenterar backup, isolering, säkra konfigurationsberoenden och återuppbyggnad av GCP, Kubernetes och applikationsdata. Genomför en återställningsövning i isolerad miljö med funktionstest och säkerhetskontroll innan tjänsten åter tas i bruk.

### Uppföljning
Följ de tre KPI:erna i [kpi.md](./kpi.md): faktisk återställningstid, möjlig dataförlust och verifierad återställningstäckning. Registrera tid, återställningspunkt och testresultat. Upprepa kvartalsvis och efter större ändringar; behandla avvikelser som förbättringsärenden.

## Professionell sammanfattning

Team 1 genomförde ett simulerat intrång mot en avsiktligt sårbar internportal. Testet resulterade i fem verifierade flaggor och sex fyndgrupper, varav tre bedömdes som kritiska och tre som höga. En angripare kunde kringgå inloggningen, erhålla administrativa funktioner och köra kommandon i applikationens miljö. Vidare kunde intern information nås och en skyddad fil läsas. Ett fullständigt övertagande av den underliggande molnservern verifierades inte.

Resultaten visar att flera till synes separata brister kan samverka och ge betydligt större konsekvenser än en enskild sårbarhet. För verksamheten innebär detta risk för obehörig åtkomst till information och förlust av kontroll över applikationens funktioner. Första prioritet är därför att åtgärda autentisering, behörighetskontroll, osäker kommandokörning och felaktiga privilegier samt verifiera åtgärderna genom återtest.

Efterhandsanalysen av försvarsloggarna visar värdet av spårbarhet. Däremot finns inte tillräckligt underlag för att fastställa när försvaret faktiskt upptäckte angreppet. Ledningen bör därför säkerställa att loggning kompletteras med testade larm och en tydlig incidentprocess.

Teamets separata Blue Team-granskning visar goda resultat i flera säkerhetskontroller, men återställningsförmågan är inte tillräckligt dokumenterad för att bedöma kontinuitetsrisken. Jag rekommenderar att systemägaren beslutar om acceptabel avbrottstid och dataförlust och att driftorganisationen genomför en verifierad återställningsövning. Tre föreslagna KPI:er följer återställningstid, dataförlustfönster och återställningstäckning. Målen ska fastställas utifrån verksamhetsbehov, och faktiska mätvärden ska rapporteras först när de kan styrkas.

Ledningen behöver utse ansvariga för åtgärder, detektion och kontinuitet samt följa upp att kritiska brister stängs och att återställningsmålen uppnås.

## Källor

- [R] Penetrationstest av Acme Corp Internportal, Team 1, 4 november 2026, avsnitt 4–7 och 10; sammanställd Red Team-rapport.
- [B] Säkerhetsgranskning och fyndrapport, Team 1, 8 oktober 2026, sammanfattning och slutverifiering; sammanställd Blue Team-rapport.
- [kpi.md](./kpi.md), egna KPI-definitioner och föreslagna mål.

## Kontroll före commit

- [x] Händelse, avgränsning och egen roll beskrivna.
- [x] Tre lärdomar med observation, orsak, konsekvens, förbättring och uppföljning.
- [x] Professionell sammanfattning med resultat, betydelse och rekommendation.
- [ ] Bekräfta den individuella rollbeskrivningen före inlämning.
- [ ] Commit och push till GitHub.
