---
title: Beispiele für Fehler im Prognosewettbewerb
date: 2022-02-12
author: Sebastia Sauer
---



1. Es wird *nicht die richtige Variable AV* (y) modelliert.
    - Achten Sie auf eine korrekt spezifizierte Regressionsformel, etwa: `y ~ x1 + x2`.
2. Es werden *leichtferti*g alle Fälle (Zeilen) mit *fehlenden Werten entfern*t.
    - Das kann im Extremfall dazu führen, dass der Datensatz sehr klein wird, etwa von 1000 auf 50 Beobachtungen. Achten Sie darauf, wie viele Fälle übrig bleiben. Im Notfall trennen Sie sich von Variablen, die fast nur aus fehlenden Werten bestehen (entfernen Sie solche "Schweizer Käse" aus dem Datensatz).
3. Die *AV (y) erscheint auf beiden Seiten der Regressionsformel*: `y ~ x1 + y`.
    - Die AV darf nur auf der linken Seite der Regressionsformel erscheinen.
4. *Nominale Variablen werden in numerisch*e umgewandelt.
    - Sagen wir, in einer Analyse gibt es die (nominale) Variable *Bundesland*, mit den bekannten 16 Werten, Bayern, Baden-Württemberg, ... Wandelt man diese Nomen in Zahlen um, so würde zwei Mal Bayern das gleiche wie Baden-Württemberg ergeben. Kein Schluss mit dem die Bürger jener Länder einfach zustimmen würden! 
5. Der Quellcode ist *nicht reproduzierbar*: Der Prüfer versucht Ihre Analyse nachzuvollziehen, scheitert aber, weil er Ihre Syntax nicht zum Laufen bekommt oder es nicht (vollständig) dokumentiert ist, was Sie gemacht haben. 
    - Achten Sie darauf, dass Ihr Code lauffähig ist, auch auf einem anderen Computer. Das bedeutet idealerweise, dass Sie keine Pfade (für Daten) verwenden, die auf Ihren Computer zeigen, da darauf ja außer Ihnen niemand Zugriff hat.
6. Es wird *keine explorative Analyse* durchgeführt, und auch keine sonstigen Methoden, um herauszufinden, welche Variablen prädiktiv sind. Stattdessen werden auf Geratewohl Modelle ausprobiert.
    - Verwenden Sie die z.B. Methoden der explorativen Datenanalyse, um herauszufinden, welche Variable z.B. viele fehlende Werte aufweisen, oder keine Streuung aufweisen oder hoch mit der AV korreliert sind.
7. Es wird ein Prognosemodell gerechnet, ohne zu prüfen, ob die *verwendeten Prädiktoren viele fehlende Werte* aufweisen.
    - Als Extrembeispiel: Sagen wird, nur 10 Zeilen im Datensatz weisen keine fehlenden Werte in den Prädiktoren Ihres Modells auf. Eine Regression wird nur diese Zeilen verwenden, also nur Zeilen mit kompletten Werte (keine fehlenden Werte). Ist es zu erwarten, dass so eine kleine Stichprobe (n=10) eine präzise Vorhersage machen wird (noch dazu, wenn es viele Prädiktoren gibt)? Leider nein! Prüfen Sie also vorab, wie viele Zeilen übrig bleiben, wenn man ein Modell mit Ihren Prädiktoren rechnet. Ohne diese Prüfung wird Ihr Modell u.U. sehr unzuverlässig sein. Auch wenn es Ihre 10 Zeilen gut beschreibt, ist es sehr fraglich, ob so eine kleine Stichprobe neue Daten gut erklären wird. 
8. Es werden *kollineare (hochkorrelierte) Prädiktoren* aufgenommen.
    - Nimmt man zwei (fast) identische Prädiktoren in eine Regression auf, so kann das das Modell "durcheinander bringen". Besser ist es, auf eine der beiden Variablen zu verzichten.
9. Die Vorhersagen werden *nicht mit der (richtigen) ID* versehen.
    - Stellen Sie sich vor, Sie sollen Noten schon Studentis vorhersagen. Jemand sagt vorher: "Schorsch wird eine 1 haben!". Schorsch hat tatsächlich eine 1. Toll! Jemand anderes sagt vorher: "Jemand wird eine 1 haben!". Tja. Schon richtig. Aber wer? Diese Vorhersage ist leider nicht wenig nütze, ihr fehlt eine ID, in dem Fall wäre die richtige (oder eine rictige) ID "Schorsch". Achten Sie darauf, für jeden Wert von `pred` eine `id` anzugeben, sonst kann die Richtigkeit Ihrer Vorhersagen nicht überprüft werden bzw. es wird kein Treffer gefunden für Ihre Vorhersagen.
10. Den *"Sanity-Check" vergessen*: Den (Train-)Datensatz anschauen, ob er zumindest auf den ersten Blick vernünftig aussieht (Anzahl der Zeilen? Anzahl der Spalten? Anzahl fehlender Werte? Konstante Spalten? ...)
11. Die einzureichenden *Dateien falsch* benennen.
    - Soll man eine Datei "cool.csv" einreichen, aber man nennt die Datei stattdessen "cool_csv", dann wird ein einfach gestricktes Computerprogramm Probleme haben, den Namen zu erkennen. Achtung vor Rechtschreibfehlern in entscheidenden Situationen, so ähnlich wie beim Eingeben einer PIN oder eines Passworts. An manchen Stellen lohnt sich ein Doppel-Check und Vorsicht. Man sollte auch keine Zip-Datei hochladen, wenn das vorab als ausgeschlossen deklariert wurde.
12. *Rechtschreibfehler* Manchmal muss man genau hinschauen, und leicht vertippt man sich: So heißt der Datensatz vielleicht `tips` und die Spalte, um die es Ihnen geht `tip` (oder war es umgekehrt?). Oder die Spalte heißt `bill_length` aber Sie schreiben `bill_lenght`.
13. *Datensatz nicht richtig importiert* Ob ein Datensatz richtig importiert ist, erkennen Sie daran, ob er im Reiter "Environment" angezeigt wird. Außerdem können Sie dort den Datensatz anklicken, um zu einer Tabellenansicht des Datensatzes zu gelangen. Dort können Sie erkennen, ob z.B. die Anzahl der Spalten korrekt ist (und nicht etwa nur eine) oder z.B. ob die Spaltennamen korrekt sind.
14. *`data(datensatz)` ohne vorher das zugehörige R-Paket gestartet zu haben*: Mit `data(datensatz)` können Sie den Datensatz `datensatz` *nur* dann verfügbar machen, wenn das Paket, in dem `datensatz` "wohnt", mit `library(paketname)` gestartet worden ist. So "wohnt" z.B. `penguins` im Datensatz `palmerpenguins`. [Hier](https://datenwerk.netlify.app/post/pfad/pfad/) finden Sie eine Übung (und weitere Erklärung) zum Importieren von Daten in R am Beispiel des Datensatzes `penguins`.
15. Verwenden einer *Funktion, ohne das zugehörige R-Paket* vorab gestartet zu haben.
16. Das Laden *zu vieler R-Pakete*, die gar nicht benötigt werden, mit dem Ergebnis, dass es mehrere Funktionen des gleichen Namens gibt (z.B. `filter()`). Das führt dann zu Verwirrung, da dann z.B. nicht die Funktion `filter` aus `tidyverse` (`dplyr`) verwendet wird, wie Sie annehmen, sondern eine Funktion gleichen Namens aus einem anderen Paket, das Sie auch gestartet haben. Tipp: Starten Sie nur die Pakete, die Sie für die Aufgabe benötigen. Zumeist sind das immer die gleichen wenigen Pakete.
17. *Fehlerhaftes Aufteilen in Train- und Test-Sample*: An sich ist es richtig (sogar oft notwendig), ein Modell in einem Datensatz zu fitten (im Train-Datensatz) und in einem zweiten Datensatz (dem Test-Sample) auf die Modellgüte hin zu prüfen (so vermeidet man Overfitting). So weit, so gut. Allerdings kann sollte das Aufteilen in Train- und Test-Sample nach dem Zufallsprinzip geschehen (idealerweise stratifiziert nach der Zielvariablen). *Falsch* wäre bei Zeitverlaufsdaten die Sommermonate in Train-Sample und die Wintermonate ins Test-Sample zu packen. Wenn die Zielvariable wetterabhängig ist, kann das Modell vom auf einmal ganz anderen Wetter  sehr überrascht sein.   
18. *Overfitting*. Angenommen Sie möchten eine Datensatz mit n=2 Beobachtungen modellieren und verwenden dazu eine Gerade. Ergebnis: 100% Erklärte Varianz! Null Vorhersagefehler! Das hört sich zu gut an, um wahr zu sein. Stimmt. Zwei Punkte können immer von einer Geraden erklärt werden, das nennt man Overfitting, ihr Modell hat zu viele Freiheitsgrade für die Daten. Das Prinzip verallgemeinert sich: Wenn Sie ein Modell mit vielen Freiheitsgraden haben (etwa ein Polynom hohen Grades oder eine ein lineares Modell mit vielen Variablen und/oder vielen Interaktionen), dann wird es dem Modell leicht fallen, die Daten im Train-Sample zu erklären - Overfitting. Leider wird bei Overfitting eine bittere Enttäuschung erleben, wenn man sich die Modellgüte im Test-Sample anschaut.


Die oben genannten Fehler sind eine umfassende Liste. Bitte lesen Sie in der entsprechenden Literatur die Details nach.


    
  
