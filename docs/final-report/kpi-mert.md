# KPI:er och säkerhetsmätningar – Blue Team Team 1

## 1. Inledning

Under Blue Team-projektet genomförde vi en säkerhetsgranskning och härdning av en infrastruktur i Google Cloud Platform (GCP). Arbetet omfattade bland annat IAM-behörigheter, nätverkssäkerhet, Kubernetes, applikationssäkerhet och CI/CD.

Under projektet identifierades totalt 20 säkerhetsfynd: 4 kritiska, 6 höga, 6 medel och 4 låga. Vi arbetade med att åtgärda bristerna och verifiera att säkerhetsförbättringarna fungerade.

För att kunna följa upp resultatet och säkerställa att säkerhetsarbetet fortsätter har vi valt tre KPI:er. De mäter olika delar av säkerhetsarbetet: förebyggande säkerhet, upptäckt av problem och åtgärdande av säkerhetsbrister.

## 2. KPI 1 – Andel nyckellös autentisering

**Syfte:**

Syftet med denna KPI är att mäta hur stor andel av autentiseringen som använder nyckellösa lösningar i stället för statiska autentiseringsnycklar. Statiska nycklar innebär en säkerhetsrisk eftersom de kan bli kvar i konfigurationer, kod eller andra lagringsplatser och användas av obehöriga.

Under projektet införde vi Workload Identity Federation (WIF) och OpenID Connect (OIDC) för att ersätta statiska nycklar med kortlivad autentisering. Vi tog även bort Editor-behörigheten från CI-kontot.

**Definition och mätmetod:**

KPI:n mäter andelen autentiseringsflöden som använder WIF/OIDC i förhållande till det totala antalet granskade autentiseringsflöden.

Formel:

Andel nyckellös autentisering = (Antal autentiseringsflöden med WIF/OIDC / Totalt antal granskade autentiseringsflöden) × 100.

**Resultat från projektet:**

- Utgångsläge: 0 %.
- Resultat efter säkerhetsförbättringar: 67 %.
- Förbättring: 67 procentenheter.

Resultatet visar att användningen av nyckellös autentisering ökade under projektet. Det innebär minskad exponering för risker kopplade till statiska nycklar.

**Datakälla:**

- GCP-konfigurationer.
- IAM-inställningar.
- CI/CD-konfigurationer.
- Dokumentation av WIF och OIDC.

**Målvärde:**

Målet är att nå 100 % nyckellös autentisering för alla autentiseringsflöden där lösningen är tekniskt möjlig.

**Uppföljning:**

KPI:n bör följas upp månadsvis genom granskning av autentiseringskonfigurationer och kontroll av att inga onödiga statiska nycklar finns kvar.

**Betydelse för verksamheten:**

En högre andel nyckellös autentisering minskar risken för att obehöriga får tillgång till infrastrukturen genom läckta eller bortglömda nycklar. Detta bidrar till bättre åtkomstkontroll och minskad risk för intrång.

## 3. KPI 2 – Tid att upptäcka trasiga säkerhetskontroller

**Syfte:**

Syftet med denna KPI är att mäta hur snabbt organisationen upptäcker när en säkerhetskontroll slutar fungera.

Under projektet upptäckte vi att SBOM-skannern inte larmade på grund av en tom inställning. Vi identifierade även att policy-controllern hade kraschat 915 gånger under tio dagar utan att problemet uppmärksammades tillräckligt snabbt.

Detta visade att det inte räcker att ha säkerhetskontroller installerade. De måste även övervakas för att säkerställa att de fungerar.

**Definition och mätmetod:**

KPI:n mäter tiden från att en säkerhetskontroll slutar fungera tills problemet upptäcks och rapporteras.

Formel:

Upptäcktstid = Tidpunkt då problemet upptäcks − Tidpunkt då problemet uppstod.

**Resultat från projektet:**

- Observerad upptäcktsfördröjning: upp till 10 dagar.
- Identifierat problem: SBOM-skannern larmade inte korrekt.
- Policy-controllern kraschade 915 gånger under tio dagar.
- Önskat mål: upptäckt inom en timme.

Resultatet visar att det fanns brister i övervakningen av säkerhetskontrollerna. Problem kunde därför kvarstå under en längre tid utan att ansvariga fick information om dem.

**Datakälla:**

- Systemloggar.
- Kubernetes-loggar.
- SBOM-skannerns konfiguration och resultat.
- Policy-controllerns loggar.
- Incidentrapporter.

**Målvärde:**

Målet är att alla kritiska säkerhetskontroller ska upptäckas som trasiga inom en timme.

**Uppföljning:**

KPI:n bör följas upp månadsvis genom att kontrollera loggar och larm samt mäta tiden från att ett fel uppstår tills det upptäcks.

Det bör även införas automatiska livstecken och larm för säkerhetskontroller. Om en kontroll slutar rapportera ska det betraktas som ett möjligt säkerhetsproblem.

**Betydelse för verksamheten:**

Snabbare upptäckt minskar tiden då organisationen saknar fungerande säkerhetsövervakning. Det gör det möjligt att agera tidigare och minskar risken för att ett säkerhetsproblem utvecklas till en större incident.

## 4. KPI 3 – Andel säkerhetsfynd som åtgärdas och verifieras

**Syfte:**

Syftet med denna KPI är att mäta hur stor andel av identifierade säkerhetsfynd som faktiskt har åtgärdats och verifierats genom omtestning.

Under Blue Team-projektet identifierades totalt 20 säkerhetsfynd med olika allvarlighetsgrader. Vi arbetade med att åtgärda bristerna och genomföra tester för att kontrollera att säkerhetsförbättringarna fungerade.

Det är viktigt att inte bara identifiera säkerhetsbrister, utan även säkerställa att de blir åtgärdade och att åtgärderna ger önskad effekt.

**Definition och mätmetod:**

KPI:n mäter andelen identifierade säkerhetsfynd som har åtgärdats och därefter verifierats genom godkänd omtestning.

Formel:

Andel verifierat åtgärdade fynd = (Antal fynd som är åtgärdade och godkända vid omtestning / Totalt antal identifierade fynd) × 100.

**Resultat från projektet:**

- Totalt identifierade fynd: 20.
- Kritiska fynd: 4.
- Höga fynd: 6.
- Medelhöga fynd: 6.
- Låga fynd: 4.
- Merparten av fynden åtgärdades enligt projektets slutredovisning.

Vid slutverifieringen den 8 oktober uppnåddes följande testresultat:

- Infrastruktur: 27 av 28 tester godkända.
- Applikation: 15 av 15 tester godkända.
- Åtkomstkontroll: 4 av 4 tester godkända.

Det saknas en fullständig sammanställning av exakt hur många av de 20 säkerhetsfynden som både åtgärdades och godkändes vid omtestning. Därför anges ingen påhittad procentsats för denna KPI.

**Datakälla:**

- Dokumenterade säkerhetsfynd.
- GitHub Issues och Pull Requests.
- Testresultat.
- Verifieringsdokumentation.
- Säkerhetsgranskningsrapporten.

**Målvärde:**

Målet är att 100 % av de kritiska och höga säkerhetsfynden ska åtgärdas och verifieras inom överenskommen tidsram.

På längre sikt bör målet vara att samtliga identifierade fynd hanteras och dokumenteras.

**Uppföljning:**

KPI:n bör följas upp månadsvis genom att granska säkerhetsfyndens status. Varje fynd ska ha en ansvarig person, en prioritering, ett planerat slutdatum och ett dokumenterat verifieringsresultat.

Kritiska och höga fynd ska prioriteras framför fynd med lägre allvarlighetsgrad.

**Betydelse för verksamheten:**

KPI:n ger ledningen en tydligare bild av hur effektivt organisationen arbetar med att minska identifierade säkerhetsrisker. Den gör det även möjligt att följa upp ansvar, prioriteringar och om säkerhetsförbättringarna verkligen fungerar.

## 5. Sammanfattning och rekommendationer

De tre KPI:erna ger tillsammans en bild av säkerhetsarbetet inom tre viktiga områden:

1. **Förebygga:** Nyckellös autentisering minskar risken för att statiska nycklar används av obehöriga.
2. **Upptäcka:** Snabbare upptäckt av trasiga säkerhetskontroller minskar tiden då organisationen saknar fungerande skydd.
3. **Åtgärda:** Uppföljning av säkerhetsfynd säkerställer att identifierade brister hanteras och verifieras.

Projektet visade att flera viktiga säkerhetsförbättringar kunde genomföras. Samtidigt identifierades kvarvarande risker, bland annat avsaknad av ett infört SIEM-system som Wazuh och behov av bättre övervakning av säkerhetskontroller.

Utifrån resultaten rekommenderar vi följande åtgärder:

- Fortsätta arbetet med att ersätta statiska autentiseringsnycklar med WIF/OIDC.
- Införa central loggning och övervakning med ett SIEM-system.
- Införa automatiska larm när säkerhetskontroller slutar fungera.
- Fortsätta granska IAM-behörigheter och minska onödigt breda behörigheter.
- Dokumentera och följa upp samtliga säkerhetsfynd tills de är åtgärdade och verifierade.

Genom att följa upp dessa tre KPI:er kan organisationen mäta om säkerhetsarbetet ger önskad effekt och upptäcka områden där ytterligare förbättringar behövs.

KPI:erna ska inte bara användas för att redovisa tekniska resultat, utan även som ett beslutsunderlag för ledningen vid prioritering av resurser och framtida säkerhetsåtgärder.
