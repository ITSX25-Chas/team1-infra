# Individuell rapport Mert Asanovski

## 1. Introduktion och projektbeskrivning

I detta projekt arbetade vårt team med att förbättra och säkra en molnmiljö i Google Cloud Platform (GCP). Arbetet omfattade bland annat infrastruktur, behörigheter, nätverkssäkerhet, applikationssäkerhet och CI/CD-pipeline.

Målet var att identifiera säkerhetsbrister, genomföra förbättringar och kontrollera att åtgärderna fungerade som förväntat.

Min roll i projektet var Product Owner. Jag fokuserade främst på planering, samordning, uppföljning och att hjälpa teamet att nå projektets mål.

## 2. Mina individuella insatser

Som Product Owner deltog jag i planeringen av arbetet och följde upp teamets framsteg. Jag hjälpte till att hålla fokus på projektets krav och bidrog till att samarbetet mellan gruppmedlemmarna fungerade bra.

Jag bidrog även till kvalitetssäkringen genom GitHub och Pull Requests. Jag granskade ändringar som andra gruppmedlemmar hade gjort innan de godkändes och slogs samman med huvudgrenen. Genom detta kunde vi upptäcka möjliga fel, diskutera förbättringar och arbeta mer strukturerat.

Jag deltog också i tekniska diskussioner och säkerhetsarbetet. Under projektet utvecklade jag min förståelse för IAM-behörigheter, brandväggsregler, nätverksskydd, säker åtkomst och MITRE ATT&CK-ramverket.

När problem uppstod samarbetade jag med gruppen för att förstå situationen och hitta lösningar. Det gav mig en bättre förståelse för hur viktigt det är med kommunikation, gemensamt ansvar och samarbete inom IT-säkerhet.

## 3. Projektresultat och bevis

Gruppen identifierade totalt 20 säkerhetsbrister under projektet:

- 4 kritiska brister
- 6 höga brister
- 6 medelhöga brister
- 4 låga brister

Flera viktiga säkerhetsförbättringar genomfördes. Bland annat ersattes statiska autentiseringsnycklar med Workload Identity Federation (WIF) och OIDC. Publik SSH-åtkomst begränsades, IAM-behörigheter förbättrades och fler säkerhetskontroller infördes i CI/CD-flödet.

Verifieringen den 8 oktober visade följande resultat:

- 27 av 28 infrastrukturtester godkändes.
- 15 av 15 applikationstester godkändes.
- 4 av 4 tester av åtkomstkontroll godkändes.

Resultaten visar att teamet genomförde betydande förbättringar i miljön. De visar också vikten av att testa och granska säkerhetsåtgärder i stället för att anta att en konfiguration är säker.

Mitt individuella bidrag låg främst inom samordning, granskning av ändringar och stöd till teamets kvalitetssäkring. Jag gör därför skillnad mellan gruppens gemensamma tekniska resultat och mina egna arbetsuppgifter.

## 4. Lärdomar från projektet

En av mina viktigaste lärdomar är att IT-säkerhet kräver kontinuerlig övervakning och uppföljning. Det räcker inte att konfigurera säkerhetskontroller. Man måste också kontrollera att de fortsätter att fungera.

Jag har även lärt mig hur viktigt samarbete och kommunikation är i tekniska säkerhetsprojekt. Genom att granska Pull Requests fick jag en bättre förståelse för hur kollegial granskning kan minska risken för fel och förbättra kvaliteten på arbetet.

En annan viktig lärdom handlar om tydliga ansvarsområden. När flera personer arbetar med infrastruktur och säkerhet behöver alla förstå sina uppgifter och teamet behöver följa upp arbetet regelbundet.

## 5. Användning av AI-verktyg

Under projektet använde jag AI-verktyg som ChatGPT och Claude för att få hjälp med att förstå tekniska begrepp och arbetsflöden.

Jag använde främst AI för att:

- Få förklaringar av begrepp inom molninfrastruktur och IT-säkerhet.
- Förstå IAM-behörigheter, brandväggsregler och säker åtkomst.
- Få hjälp med att förstå GitHub, arbetsflöden och Pull Requests.
- Förtydliga teknisk information när jag behövde ytterligare förklaringar.

Jag använde AI-svar som förslag och stöd för att lära mig, inte som verifierade fakta. Jag kontrollerade relevant information mot projektets konfigurationer, dokumentation och diskussioner med gruppmedlemmarna.

En begränsning med AI är att svaren kan vara felaktiga, ofullständiga eller för generella. AI förstår inte automatiskt den exakta konfigurationen i ett projekt. Därför var mänsklig granskning och verifiering nödvändig.

Jag lärde mig också att känslig information, exempelvis lösenord, åtkomstnycklar och privata konfigurationsuppgifter, aldrig ska delas med AI-verktyg.

## 6. Reflektion och framtida utveckling

Projektet har hjälpt mig att utveckla min förståelse för hur säkerhetsarbete planeras, samordnas och kontrolleras i ett team.

I rollen som Product Owner har jag lärt mig att teknisk kunskap är viktig, men att kommunikation, prioritering, dokumentation och uppföljning också har stor betydelse. Ett framgångsrikt säkerhetsprojekt kräver både tekniska förbättringar och tydliga arbetssätt för ansvar och uppföljning.

Inför min framtida yrkesroll och LIA vill jag fortsätta utveckla mina kunskaper inom molnsäkerhet, IAM, nätverkssäkerhet och säkerhetsövervakning. Jag vill även bli bättre på att förklara tekniska säkerhetsresultat på ett tydligt sätt för personer som inte har en teknisk bakgrund.

Sammanfattningsvis har projektet gett mig värdefull erfarenhet av samarbete, kvalitetssäkring och betydelsen av kontinuerliga säkerhetsförbättringar.
