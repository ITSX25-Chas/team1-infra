# Post-mortem, lessons learned och professionell sammanfattning

**Namn:** Malcolm Skoglund
**Team:** Team 1, ITSX25 kurs 6, Avancerad IT-säkerhet

## Händelse och avgränsning

Post-mortem gäller det simulerade intrånget i projektets Red Team-fas: ett strukturerat penetrationstest mot en tilldelad målmiljö (en webbportal) den 20 och 27 oktober 2026. Angreppet gick från oautentiserad åtkomst, via en kedja av brister, till kommandokörning, läsning av en root-skyddad fil och åtkomst till interna personuppgifter.

Händelsen upptäcktes inte av något försvarslarm under testet. Den blev synlig först efteråt, när vi den 4 november fick ut försvarssidans loggar och kunde se att hela attacken fanns registrerad men att ingen regel hade reagerat i realtid.

Min egen roll: jag genomförde och dokumenterade attackstegen, och jag gjorde efterhandsanalysen av loggarna. Jag verifierade loggpaketets äkthet, knöt varje attacksteg till en konkret loggrad och bedömde vad som gick att belägga och inte. Den här post-mortem bygger på den analysen samt på två driftincidenter från Blue Team-fasen.

---

## Lesson learned 1: En säkerhetskontroll utan larm kan vara trasig i flera dygn

### Observation

Två skydd slutade fungera utan att någon märkte det. Vår sårbarhetsskanner skickade inga larm eftersom en inställning var tom, och minst två dagliga körningar misslyckades. En signaturkontroll var ur funktion och startade om hundratals gånger under tio dagar.

### Orsak

Vi tolkade tystnad som att allt var bra. Kontrollerna hörde bara av sig när de hittade något, och ingen övervakade om de ens kördes. En av tjänsterna var dessutom beroende av en enda server som tidvis saknade internet.

### Konsekvens

Vi var utan sårbarhetsrapporter i flera dygn och trodde oss skyddade. Under den tiden fanns ingen fungerande kontroll, bara en känsla av att det fanns en.

### Förbättring

Varje säkerhetskontroll ska skicka ett livstecken, även när den inte hittar något. Uteblivet livstecken ska i sig vara ett larm. Larma också när ett säkerhetsjobb misslyckas eller startar om upprepade gånger.

### Uppföljning

Följs upp med KPI 2 (tid innan vi upptäcker att en kontroll slutat fungera). Målet är att den tiden går från flera dygn till under ett dygn, och på sikt under en timme.

---

## Lesson learned 2: Allt loggades, men ingen reagerade. Insamling är inte detektion

### Observation

När vi efter testet granskade försvarssidans loggar fanns hela attackkedjan där, i klartext: inloggningsförbikopplingen, den förfalskade behörigheten, kommandona och den privilegierade filläsningen. Ändå hade inget larm utlösts under testet, och ingen incidentrespons påbörjats.

### Orsak

Loggarna samlades in, men ingen regel analyserade dem i realtid. Säkerhetsövervakning (SIEM) var inte infört. Att data finns i efterhand är inte samma sak som att någon upptäcker ett angrepp när det pågår.

### Konsekvens

I ett skarpt fall hade angriparen kunnat ta sig hela vägen till personuppgifter utan att någon ingrep. Bevisen fanns, men förmågan att agera på dem saknades.

### Förbättring

Inför säkerhetsövervakning som analyserar loggarna löpande, med larm för de mönster vi vet används: systemkommandon i webbanrop, en nekad åtkomst som plötsligt tillåts, och serier av misslyckade inloggningar följt av en lyckad. Komplettera webbloggar med övervakning av vad som faktiskt körs på servrarna.

### Uppföljning

Mät tiden från ett angreppssteg till larm, och testa reglerna med återkommande kontroller efter varje ändring. Dokumentera både att något registrerades, att ett larm gick och att någon agerade.

---

## Lesson learned 3: Hemligheter läcker i de manuella stegen, inte i koden

### Observation

Under projektet läckte känsliga uppgifter flera gånger, alltid i manuella arbetsmoment: en larmadress hamnade i kommandohistoriken och på skärmdumpar, en nyckel syntes på en bild, och vår egen applikation hade ett standardlösenord kvar i koden.

### Orsak

Hemligheter passerade terminal, skärm och chatt för att det var det snabbaste sättet. Vi hade ingen förteckning över vilka nycklar som fanns, och ingen kontroll av värden innan de sparades.

### Konsekvens

Varje läcka krävde att nyckeln byttes ut och kostade tid. Standardlösenordet i vår app var allvarligast: det hade gjort det möjligt att förfalska en inloggad session, samma typ av brist som vi själva utnyttjade hos måltavlan.

### Förbättring

Skicka aldrig hemligheter via terminal, skärm eller chatt. Mata in dem direkt i målsystemet utan att visa dem. För en förteckning över alla nycklar med ägare och utgångsdatum, och låt applikationer vägra starta med ett standardlösenord.

### Uppföljning

Följs upp genom regelbundna genomgångar av sparade hemligheter och genom KPI 1, som premierar att vi går mot lösningar helt utan sparade nycklar.

---

## Professionell sammanfattning

**Till:** ledningsgrupp och systemägare

Vårt lag byggde och härdade en molnmiljö och genomförde därefter ett penetrationstest mot en tilldelad målmiljö. Den här sammanfattningen gäller vad testet och det efterföljande arbetet lärde oss.

**Resultat.** Penetrationstestet visade att en angripare utan inloggning kunde ta sig hela vägen från webbsidan till interna personuppgifter. Angreppet lyckades, och lika viktigt: det upptäcktes inte medan det pågick, trots att allt fanns registrerat i loggarna i efterhand.

**Betydelse.** Den största lärdomen är skillnaden mellan att samla in information och att faktiskt upptäcka ett angrepp. Vi hade loggar, men ingen övervakning som reagerade. Vi hade säkerhetskontroller, men de kunde vara trasiga i flera dygn utan att vi visste om det. Tillsammans betyder det att vår förmåga att förhindra var starkare än vår förmåga att upptäcka och agera.

**Rekommendation, i prioritetsordning.** Organisationen bör prioritera: (1) införa säkerhetsövervakning som larmar i realtid på kända angreppsmönster, (2) ge varje säkerhetskontroll ett livstecken och larm vid fel, och (3) en rutin för att åtgärda och omtesta brister inom en bestämd tidsgräns.

**Beslut och uppföljning.** En fråga kräver beslut på ledningsnivå: breda behörigheter i den delade molnmiljön kan bara ägaren åtgärda, inte vårt lag. I övrigt följs effekten av arbetet med tre KPI:er för exponering, upptäcktsförmåga och åtgärdstakt. Se `kpi.md`.
