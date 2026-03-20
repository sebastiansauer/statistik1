


# Daten verbildlichen



```{r libs-hidden}
#| message: false
#| warning: false
#| echo: false
library(tidyverse)
library(easystats)
#library(anglr)
#library(maptools)
library(plotly)
library(scales)
library(ggpubr)
library(ggpattern)
library(exams2forms)
```


```{r}
#| include: false

source("_common.R")
```



{{< include children/colors.qmd >}}



## Einstieg










### Lernziele


- Sie können erläutern, wann und wozu das Visualisieren statistischer Inhalte sinnvoll ist.
- Sie kennen typische Arten von Datendiagrammen.
- Sie können typische Datendiagramme mit R visualisieren.
- Sie können zentrale Ergebnisse aus Datendiagrammen herauslesen.


### Benötigte R-Pakete und Daten

Neben den üblichen Paketen `tidyverse` [@wickham2019a] und `easystats` [@ludecke2022]
benötigen Sie in diesem Kapitel noch `DataExplorer` [@cui2024]
und optional `ggpubr` [@kassambara2023] und `ggstatsplot` [@patil2021].
Wir arbeiten wieder mit dem Datensatz `mariokart`, s. @sec-import-mariokart.

```{r}
#| message: false
library(tidyverse)
library(easystats)
library(DataExplorer)  # nicht vergessen zu installieren
library(ggpubr)  # optional, Datenvisualisierung
library(ggstatsplot)  # optional, Datenvisualisierung
```





::::: {.content-visible when-format="html" unless-format="epub"}

### Quiz zum Einstieg

:::: {layout="[ 80, 20 ]"}
::: {#first-column}
Vielleicht fordert Sie die Lehrkraft zu einem Einstiegsquiz auf, 
etwa mittels der Plattform [antworte.jetzt](https://antworte.jetzt/).
Alternativ überlegen Sie sich selber 10 Quiz-Aufgaben zum Stoff des letzten Kapitels.
:::

::: {#second-column}

```{r}
#| echo: false
#| out-width: "75%"
#| fig-align: center
qr <- qrcode::qr_code("https://antworte.jetzt")
plot(qr)
```
:::
::::

:::::








### Wozu das alles?





::: {.content-visible when-format="html"}

![Große Aufgaben warten … [@imgflip_kermit]](img/kermit-curse.gif){width=50%}

:::

>   [🥷]{.content-visible when-format="html"} [\emoji{ninja}]{.content-visible when-format="pdf"} Wir müssen die Galaxis retten, Kermit!

>   [🐸]{.content-visible when-format="html"} [\emoji{frog}]{.content-visible when-format="pdf"} *Schlock*





## Ein Dino sagt mehr als 1000 Worte

Es heißt, ein Bild sage mehr als 1000 Worte. 
Schon richtig, aber ein Dinosaurier sagt auch mehr als 1000 Worte [@fitzmaurice_same_2017].
In @fig-dino1 sieht man verschiedene "Bilder", also Datensätze: etwa einen Dino und einmal einen Kreis.
Obwohl die Bilder grundverschieden sind,
sind die zentralen statistischen Kennwerte (praktisch) identisch.
In dieselbe Bresche schlägt "Anscombes Quartett" [@Anscombe_1973].
Es zeigt vier Datensätze, in denen die zentralen Statistiken fast identisch sind,
also Mittelwerte, Streuungen, Korrelationen.
Aber die Streudiagramme sind grundverschieden.
Anscombes Beispiel zeigt (zugespitzt): 
Eine Visualisierung enthüllt, was der Statistik (als Kennzahl) verhüllt bleibt.
Statistische Diagramme können Einblicke geben, die sich nicht (leicht) in grundlegenden Statistiken (Kennwerten) abbilden. 
Unter visueller Cortex ist sehr leistungsfähig. 
Wir können ohne Mühe eine große Anzahl
an visuellen  Informationen aufnehmen und parallel verarbeiten.
Aus diesem Grund sind Datendiagramme eine effektive und einfache Art,
aus Daten Erkenntnisse zu ziehen.
Nutzen Sie Datendiagramme umfassend; sie sind einfach zu verstehen und doch sehr mächtig.



::: {.content-visible when-format="html"}
![Dinosaurier und Kreis: Gleiche statistische Kennwerte [@fitzmaurice_same_2017]](img/dino-corr.gif){#fig-dino1}

@fig-dino2 zeigt Anscombes Quartett.

![Anscombes Quartet: Gleiche statistischen Kennwerte in vier Datensätzen](img/anscombe.png){#fig-dino2 width=75%}
:::

::: {.content-visible when-format="pdf"}
```{r dino-pdf}
#| echo: false
#| label: fig-dino1
#| fig-cap: "Alle Diagramme haben gleiche statistische Koeffizienten, wie Mittelwert und Streuung und Korrelation, aber die Datengrundlage sind komplett verschieden."
# out-width: 50%
#| fig-asp: 0.618
#| out-width: "50%"
library("ggplot2")
library("datasauRus")

datasaurus_dozen |> 
  filter(dataset %in% c("dino", "circle", "star", "bullseye")) |> 
  ggplot(aes(x = x, y = y, colour = dataset))+
  geom_point() +
  theme_void() +
  theme(legend.position = "none")+
  facet_wrap(~dataset, ncol = 4) +
  theme(strip.text = element_text(size = 16))
```
:::



















:::{#def-datendiagramm}
### Datendiagramm
Ein *Datendiagramm* (kurz: Diagramm) ist ein Diagramm, das Daten und Statistiken zeigt, mit dem Zweck,
Erkenntnisse daraus zu ziehen.
:::





:::::{#exm-datendiagramm}

### Aus der Forschung: Ein aufwändiges (und ansprechendes) Datendiagramm


<!-- :::: {layout="[ 50, -5, 50 ]"} -->
<!-- ::: {#first-column} -->
Auf Basis des Korruptionsindex von Transparency International [-@transparency_international_corruption_2017] erstellt Wilke [-@wilke_wilkelabpracticalgg_2024] ein Diagramm zum Zusammenhang vom Entwicklungsindex (Lebenserwartung, Bildung, Einkommen; vgl. @hou_dynamics_2015) und Korruption, jeweils auf Landesebene, s. @fig-develop-corrupt. 

Es finden sich in der Literatur (im Internet) viele weitere Beispiele für handwerklich meisterhaft erstelle Datendiagramme, 
die in vielen Fällen mit R erstellt werden [vgl. @scherer_seasonal_2019]. $\square$



<!-- ::: -->

<!-- ::: {#second-column} -->

![Der Zusammenhang von Entwicklungindex und und Korruption](img/develop-corrupt.png){#fig-develop-corrupt width=75%}

<!-- ::: -->
<!-- :::: -->
:::::



@fig-many-dims zeigt ein Bild mit mehreren (5) Variablen, 
die jeweils einer "Dimension" entsprechen.
Wie man (nicht) sieht, wird es langsam unübersichtlich.
Offenbar kann man in einem Bild nicht beliebig viele Variablen sinnvoll reinquetschen.
Die "Dimensionalität" eines Diagramms hat ihre Grenzen,
vielleicht bei vier bis sechs Variablen.
Möchten wir den Zusammenhang von vielen Variablen verstehen,
kommen wir mit Bildern oft nicht weiter.
Dann brauchen wir andere Werkzeuge: Statistik, komm zu Hilfe.
Bei klaren Zusammenhängen und wenig Variablen braucht man keine (aufwändige) Statistik.
Ein Bild, also ein Datendiagramm, ist dann oft ausreichend.
Man könnte sagen, dass es Statistik nur deshalb gibt, 
weil unser Auge mit mehr als ca. vier bis sechs Variablen nicht gleichzeitig umgehen kann.
```{r}
#| echo: false
#| label: fig-many-dims
#| out-width: 75%
#| fig-cap: "Ein Diagramm kann nur eine begrenzte Anzahl von Variablen zeigen. Wenn Sie dieses Bild nicht checken: Prima. Genau das soll das Bild zeigen."
data(mariokart, package = "openintro")

mariokart |> 
  filter(total_pr < 100) |> 
  ggplot(aes(x = duration, y = total_pr, 
             color = cond, size = wheels, 
             shape = stock_photo)) +
  geom_point() +
  scale_color_manual(values = c(yellow, blue)) 

```

<!-- TODO: Eine Legende für "cond" und "stock_photo" -->

:::{#exr-anz-dims}
Wie viele Variablen sind in @fig-many-dims dargestellt?^[5]
:::



## Nomenklatur von Datendiagrammen

@tbl-nom-plots zeigt eine -- sehr kurze Nomenklatur -- von 
Datendiagrammen. Weitere Nomenklaturen sind möglich, 
aber wir halten hier die Sache einfach. 
Wer an Vertiefung interessiert ist, 
findet bei data-to-vis einen Überblick über verschiedene Typen an Diagrammen, sogar in Form einer systematischen Nomenklatur: <https://www.data-to-viz.com/>.

```{r}
#| echo: false
#| label: tbl-nom-plots
#| tbl-cap: "Ein (sehr kurze) Nomenklatur von Datendiagrammen"
nom_plots <-
  tribble(
~Erkenntnisziel, ~qualitativ, ~quantitativ,
"Verteilung", "Balkendiagramm"," Histogramm und Dichtediagramm",
"Zusammenhang", "gefülltes Balkendiagramm", "Streudiagramm",
"Unterschied", "gefülltes Balkendiagramm", "Boxplot")

nom_plots |> knitr::kable()
```






## Verteilungen verbildlichen

### Verteilung einer nominalen Variable

:::{#def-verteilung}
### Verteilung
Eine (Häufigkeits-)Verteilung einer Variablen $X$ schlüsselt auf, 
wie häufig jede Ausprägung von $X$ ist. $\square$
:::

:::{#exm-verteilung1}
@tbl-wheels-n zeigt die Häufigkeitsverteilung von `cond` (condition, also der Zustand des Artikels, neu oder gebraucht) 
aus dem Datensatz `mariokart`.
Die Variable hat 2 Ausprägungen; 
z.$\,$B. kommt die Ausprägung `new`  59 mal vor. $\square$
:::



```{r mariokart-cond-freq-tbl}
#| echo: false
#| label: tbl-wheels-n
#| tbl-cap: "Häufigkeitsverteilung von `cond` aus dem Datensatz `mariokart`"

mariokart |> 
  count(cond) %>% print_md()
```

Zugegeben, das Datendiagramm von `cond` ist nicht so aufregend, 
s. @fig-mario-n-plot-cond.
Wie man sieht, besteht so ein Diagramm aus *Balken*, daher heißt es *Balkendiagramm*. 
Man kann so ein Diagramm um 90$\,$° drehen, s. @fig-mario-n-plot-cond; 
keine Ausrichtung ist grundsätzlich besser als die andere.


:::{#def-balken}
### Balkendiagramm
Ein Balkendiagramm ist eine grafische Darstellung von Werten, 
zumeist für die Häufigkeiten bestimmter Kategorien, 
also Ausprägungen nominaler Variablen.
Dabei werden rechteckige Balken verwendet,
und die Länge eines Balkens ist proportional zur dargestellten Häufigkeit. $\square$
:::



```{r p-mariokart-n-cond}
#| echo: false
#| layout-ncol: 2
#| out-width: "75%"
#| label: fig-mario-n-plot-cond
#| fig-cap: "Häufigkeitsverteilung der Variable `cond`"
#| fig-subcap: 
#|   - horizontale Balken
#|   - vertikale Balken

mario_n1 <-
  mariokart |> 
  count(cond) |> 
  ggplot(aes(y = n, x = cond)) + 
  geom_col() +
  coord_flip() +
  theme_modern() +
  theme_large_text()

mario_n2 <-
  mariokart |> 
  count(cond) |> 
  ggplot(aes(y = n, x = cond)) + 
  geom_col()   +
  theme_modern() +
  theme_large_text()


mario_n1
mario_n2

# plots(mario_n1, mario_n2)
```




Es gibt viele Methoden, sich mit R ein Balkendiagramm ausgeben zu lassen.
Eine einfache, komfortable ist die mit dem Paket `DataExplorer`, 
s. @fig-mario-n-plot-cond;
wir betrachten gleich die Syntax.
Zuerst importieren wir die Daten, s.  @lst-mariokart.
Außerdem nicht vergessen, das Paket `DataExplorer` mit dem Befehl `library` zu starten.
(Natürlich müssen Sie das Paket einmalig installiert haben, 
bevor Sie es starten können.)
In diesem Paket "wohnen" die Befehle, die wir zum Erstellen der Datendiagramme nutzen werden. 
@lst-de1 zeigt die Syntax, um ein Balkendiagramm zu erstellen. 
Auf der Hilfeseite der Funktion finden Sie weitere Details zur Funktion.






```{r}
#| label: fig-de1
#| echo: true
#| eval: true
#| lst-label: lst-de1
#| lst-cap: "Syntax zur Erstellung eines Balkendiagramms"
#| out-width: 50%
#| fig-cap: "Ein Balkendiagramm. Unglaublich."
library(DataExplorer)

mariokart %>% 
  select(cond) %>% 
  plot_bar()

```



Die Syntax ist in @lst-de1 abgedruckt 
(Zur Erinnerung: ` %>% ` nennt man die "Pfeife und lässt sich als "und dann" übersetzen, 
vgl. @sec-pipe). 
Übersetzen wir die Syntax ins Deutsche:

```
Nimm den Datensatz `mariokart` *und dann*
  wähle die Spalte cond *und dann*
  zeichne ein Balkendiagramm. Fertig!
```  

:::{#exr-de1}
### Spalten wählen für das Balkendiagramm
Hätten wir andere Spalten ausgewählt, so würde das Balkendiagramm die Verteilung jener Variablen zeigen. 
Ja, Sie können auch mehrere Variablen auf einmal auswählen. 
Probieren Sie das doch mal aus! $\square$
:::



::::{#exr-balken}
### Visualisieren Sie die Verteilung von `stock_photo`!

Erstellen Sie ein geeignetes Diagramm, um die Häufigkeit jeder Ausprägung von `stock_photo` (Datensatz `mariokart`) darzustellen.

**Lösung**

```{r}
#| eval: !expr knitr:::is_html_output()
#| out-width: 50%
mariokart |> 
  select(stock_photo) |> 
  plot_bar()
```

Mit `plot_bar` aus `DataExplorer` kann man Balkendiagramme darstellen. $\square$

::::



<!-- So können Sie  -->


### Verteilung einer quantitativen Variable



Bei einer quantitativen Variablen mit vielen Ausprägungen wäre ein Balkendiagramm nicht so aussagekräftig, 
s. @fig-balken-hist (links). Es gibt einfach zu viele Ausprägungen.

```{r}
#| echo: false
mariokart_bar_total_pr <- 
mariokart |> 
  filter(total_pr < 200) |> 
  mutate(total_pr = round(total_pr, digits = 1)) |> 
  ggplot(aes(x = total_pr)) +
  geom_bar()
```

Die Lösung: Wir reduzieren die Anzahl der Ausprägungen, in dem wir auf ganze Dollar runden.
Oder, um noch weniger Ausprägungen zu bekommen, können wir einfach Gruppen definieren, z.$\,$B.

- Gruppe 1: 0-5 Dollar
- Gruppe 2: 6-10 Dollar
- Gruppe 3: 11-15 Dollar
- …


In @fig-balken-hist (rechts) sind z.$\,$B. die Ausprägungen des Verkaufspreises (`total_pr`) in Gruppen der Breite von 5 Dollar aufgeteilt worden. 
Zusätzlich sind noch die einzelnen Werte als schwarze Punkte gezeigt.

```{r}
#| echo: false
#| fig-cap: "Balkendiagramm vs. Histogramm für den Gesamtpreis (`total_pr`)"
#| layout-ncol: 2
#| label: fig-balken-hist
#| fig-subcap: 
#|   - Balkendiagramm
#|   - Histogramm

m1a <- 
  mariokart |> 
  filter(total_pr < 100)

mariokart_hist_total_pr <- 
m1a |> 
  ggplot(aes(x = total_pr)) +
  geom_histogram(binwidth = 5, alpha = .7, center = 0, color = "white")  +
  geom_dotplot(binwidth = 1, method = "histodot") +
  labs(caption = paste0("n = ", nrow(m1a))) +
  scale_y_continuous(
    name = "Anzahl",
    sec.axis = sec_axis(trans = ~. / 141, name = "Anteil"))

mariokart_bar_total_pr +
  theme_large_text()
mariokart_hist_total_pr +
  theme_large_text()
```



:::{#def-histogramm}

### Histogramm
Ein Histogramm ist ein Diagramm zur Darstellung der Häufigkeitsverteilung einer quantitativen Variablen. 
Die Daten werden in Gruppen (Klassen) eingeteilt, 
die dann durch einen Balken (pro Klasse) dargestellt werden.
Die Höhe der Balken zeigt die Häufigkeit der Daten in 
dieser Gruppe/in diesem Balken (bei konstanter Balkenbreite).
:::




Es gibt keine klare Regel, in wie viele Balken ein Histogramm 
gegliedert sein sollte.
Nur: Es sollten werder sehr viele noch zu wenige sein, 
s. @fig-zu-wenig-viele (links) bzw. @fig-zu-wenig-viele (rechts).
Zur Erstellung eines Histogramms können Sie die Syntax @lst-de2 nutzen, 
vgl. @fig-de-hist-density, links. 


```{r}
#| echo: false
#| label: fig-zu-wenig-viele
#| layout-ncol: 2
#| fig-cap: "Nicht zu wenig und nicht zu viele Balken im Histogramm"
#| fig-subcap: 
#|   - "Zu viele Gruppen (Balken)"
#|   - "Zu wenige Gruppen (Balken)"

p_mario_zu_viele <- 
  mariokart |> 
  filter(total_pr < 100) |> 
  ggplot(aes(x = total_pr)) +
  geom_histogram(binwidth = 1)  +
  theme_large_text()

p_mario_zu_viele

p_mario_zu_wenige <- 
  mariokart |> 
  filter(total_pr < 100) |> 
  ggplot(aes(x = total_pr)) +
  geom_histogram(bins = 2) +
  theme_large_text()

p_mario_zu_wenige
```







```{r}
#| eval: false
#| lst-cap: Syntax zur Erstellung eines Histogramms
#| lst-label: lst-de2
mariokart %>% 
  select(total_pr) %>% 
  filter(total_pr < 100) %>%  # ohne Extremwerte
  plot_histogram()
```


```{r}
#| echo: false
#| label: fig-de-hist-density
#| layout-ncol: 2
#| fig-cap: "Eine stetige Verteilung verbildlichen"
#| fig-subcap:
#|   - Histogramm
#|   - Dichtediagramm 

mariokart %>% 
  select(total_pr) %>% 
  filter(total_pr < 100) %>%  # ohne Extremwerte
  plot_histogram(ggtheme = theme_minimal())

mariokart %>% 
  select(total_pr) %>% 
  filter(total_pr < 100) %>%  # ohne Extremwerte
  plot_density(ggtheme = theme_minimal()) 
```



::::: {.content-visible when-format="html"}

::::{#exr-histo-ship-pr}

### Visualisieren Sie die Verteilung von `ship_pr` anhand eines Histogramms!


```{r}
#| eval: !expr knitr:::is_html_output()
#| out-width: 50%
mariokart |> 
  select(ship_pr) |> 
  plot_histogram()
```

::::
:::::






@fig-balken-total-pr-hist-dens fügt zum Histogramm ein *Dichtediagramm* hinzu (durchgezogene Linie). 
Ein Dichtediagramm ähnelt einem "glattgeschmirgelten" Histogramm.


:::{#def-dichtediagramm}
### Dichtediagramm
Ein Dichtediagramm visualisiert die Verteilung einer stetigen Variablen.
Im Gegensatz zum Histogramm wird der Verlauf der Kurve geglättet,
so kann Rauschen (Zufallsschwankung) besser ausgeblendet werden. (Mit *Dichte* ist die relative Anzahl der Beobachtungen pro Einheit der Variablen auf der X-Achse gemeint.)
:::



```{r}
#| echo: false
#| fig-cap: "Histogramm und Dichtediagramm (Linie) für `total_pr`"
#| label: fig-balken-total-pr-hist-dens
#| out-width: 75%

m1a |> 
  ggplot(aes(x = total_pr, y = ..density..)) +
  geom_histogram(binwidth = 5, alpha = .7, center = 0, fill = "grey20")  +
  #geom_dotplot(binwidth = 1, method = "histodot") +
  geom_density(color = yellow, size = 2)
  #geom_dotplot(binwidth = 1, method = "histodot") +
```



:::{#exr-plot-density}
Erstellen Sie das Diagramm @fig-de-hist-density, rechtes Teildiagramm!^[Grob gesagt: `mariokart %>% plot_density()`.]$\square$
:::




Verteilungen unterscheiden sich z.$\,$B. in ihrem "typischen" oder "mittleren" Wert (vgl. @sec-lage), aber auch in ihrer Streuung  (vgl. @sec-streuung).
(Diagramme von) Verteilungen können symmetrisch oder schief (nicht symmetrisch) sein, s. @fig-symm-schief.
@fig-plot-distribs zeigt verschiedene Formen von Verteilungen. "Bimodal" meint "zweigipflig" und "multimodal" entsprechend "mehrgipflig".^[Quelle: ifes/FOM Hochschule, <https://github.com/FOM-ifes/VL-Vorlesungsfolien>]

```{r}
#| echo: false
#| label: fig-symm-schief
#| layout-ncol: 2
#| fig-cap: "Symmetrische vs. schiefe Verteilung, verbildlicht"
#| fig-subcap:
#|   - "Symmetrisch (Normal)"
#|   - "Schief"
p_norm <- 
  ggplot(NULL) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1)) +
  scale_x_continuous(limits = c(-3, 3)) +
  scale_y_continuous(NULL, breaks = NULL)

p_norm

ggplot(NULL) +
  stat_function(fun = dgamma, args = list(shape = 2, rate = 3))  +
  scale_x_continuous(limits = c(0, 3)) +
  scale_y_continuous(NULL, breaks = NULL)
```




```{r plot-distribs}
#| echo: false
#| label: fig-plot-distribs
#| fig-cap: "Verschiedene Verteilungsformen"
source("funs/plot-distribs.R")
p_distribs <- plot_distribs()
p_distribs
```



::::{#exr-verteilungsform-total-pr}

### Verteilungsform von `total_pr`?

Benennen Sie die am besten passende Verteilungsform für die Variable `total_pr`.

**Lösung**



::: {.content-visible when-format="html"}

```{r}
mariokart |> 
  select(total_pr) |> 
  plot_density()
```
:::
Die Verteilung ist rechtsschief. $\square$
::::



## Spezialfall Normalverteilung

### Grundlagen

Eine Normalverteilung ist eine bestimmte Art von Verteilung einer stetigen quantitativen Variablen.
Aber sie ist besonders wichtig, 
und wird daher hier besonders hervorgehoben.
Eine Normalverteilung sehen Sie in @fig-symm-schief, links. 
Die Normalverteilung ist in der Statistik von hoher Bedeutung, 
da sie sich unter (recht häufigen) Bedingungen zwangsläufig ergeben muss und vielseitig Verwendung findet.


::: {#def-nv}
### Normalverteilung
Normalverteilungen haben eine charakteristische symmetrische Glockenform.
Normalverteilungen können sich unterscheiden in ihrem  Mittelwert $\mu$ und ihrer Streuung, $\sigma$.
Diese beiden Größen ("Parameter") determinieren den Graphen einer bestimmten Normalverteilungsfunktion, s. @fig-norms.
Sind diese beiden Parameter bekannt, so ist die Dichte jedes beliebigen Datenpunkts (aus dieser Normalverteilung) bestimmt.$\square$
:::

Eine normalverteilte Zufallsvariable $X$ mit einem bestimmten Mittelwert und einer bestimmten Streuung schreibt man kurz so:

$$X \sim \mathcal{N}(\mu, \sigma)$$

![Beispiele von Normalverteilungen mit verschiedenen Mittelwerten und Streuungen, Quelle: Wikipedia](img/normals.png){#fig-norms width=50% fig-align="center"}


:::{#exm-norm}
Beispiele für normalverteilte Variablen sind Körpergröße von Männern oder Frauen, IQ-Werte, einige Prüfungsergebnisse, Messfehler, Lebensdauer von Glühbirnen, Gewichte von Brotlaiben, Milchproduktion von Kühen, Brustumfang schottischer Soldaten [@lyon_why_2014]. $\square$
:::


:::{#def-norm}
### Normalverteilung
Eine Normalverteilung ist eine spezielle Art von Verteilung einer quantitativen Variablen. 
Sie ist symmetrisch, glockenförmig, stetig, unimodal und ihr Mittelwert, Median und Modus identisch. 
Sie lässt sich durch zwei Parameter vollständig beschreiben: Mittelwert ($\mu$) und Streuung ($\sigma$). $\square$
:::

<!-- :::{#exm-studis} -->
<!-- ### Wie groß sind Studierende? -->
<!-- ::: -->







<!-- Eine Normalverteilung lässt sich exakt beschreiben anhand zweier Parameter: ihres zentralen Werts (Mittelwerts), $\mu$, und ihrer Streuung (Standardabweichung), $\sigma$.  -->


::::: {.content-visible when-format="html" unless-format="epub"}


@fig-normal-interactive zeigt interaktive Beispiele für Normalverteilung. 
Wählen Sie einfach Mittelwert ($\mu$) und Streuung ($\sigma$) anhand der Schieberegler.^[Quelle: <https://observablehq.com/@mcmcclur/the-normal-model>]



::::{#fig-normal-interactive }

::: {.figure-content}



{{< include children/normal-distro-interactive.qmd >}}



:::

Interaktives Beispiel für Normalverteilungen.

::::

:::::









### Fläche unter der Kurve



Kennt man die beiden Parameter der Normalverteilung, Mittelwert und Streuung (SD, $\sigma$), einer Normalverteilung, 
so kann man einfach angeben, welcher Anteil der Fläche (unter der Kurve) der Normalverteilung sich in einem bestimmten Bereich befindet, 
s. @fig-norm-perc [@ainali_standard_2007].


Davon leitet sich die "68-95-99.7-Prozentregel" ab,
die angibt, in welchem Bereich sich welcher Anteil der Fläche befindet:

- $68\,\%$ im Bereich $\mu\pm 1 \cdot \sigma$ 
- $95\,\%$ im Bereich $\mu\pm 2 \cdot \sigma$ 
- $99{.}7\,\%$ im Bereich $\mu\pm 3 \cdot \sigma$ 





![Die Flächeninhalte (Wahrscheinlichkeitsmasse) einer Normalverteilung in Abhängigkeit der Streuung [@ainali_standard_2007]](img/Standard_deviation_diagram_micro.svg.png){#fig-norm-perc width=75%}







### IQ-Verteilung

Die Verteilung der Zufallsvariablen IQ ist normalverteilt mit einem Mittelwert von 100 und einer Streuung von 15, s. @fig-norm-100-15:

$IQ \sim \mathcal{N}(100,15)$

:::{#exr-iq}
### Wie schlau muss man (nicht) sein?
- Wie schlau muss man sein, um zu den unteren 75%, 50%, 25%, 5%, 1% zu gehören?
- Anders gesagt: Welcher IQ-Wert wird von 75%, 50%, ... der Leute nicht überschritten?$\square$
:::   


![Visualisierung der theoretischen IQ-Verteilung](img/normal-100-15.png){#fig-norm-100-15 width="75%"}




### Vertiefung: Entstehung einer Normalverteilung



:::{#def-normal-galton}
### Entstehung einer Normalverteilung

Wenn sich eine Variable $X$ als Summe mehrerer, unabhängiger, etwa gleich starker Summanden, dann kann man erwarten, dass sich diese Variable $X$ tendenziell normalverteilt. $\square$
:::


:::: {layout="[ 80, 20 ]"}
::: {#first-column}
Die Entstehhung einer Normalverteilung kann man gut anhand des [Galton-Bretts](https://www.youtube.com/watch?v=3m4bxse2JEQ) veranschaulichen.
:::

::: {#second-column}

```{r}
#| echo: false
#| out-width: "75%"
#| fig-align: center
qr <- qrcode::qr_code("https://www.youtube.com/watch?v=3m4bxse2JEQ")
plot(qr)
```
:::
::::







::: {.content-visible when-format="html" unless-format="epub"}

{{< video https://youtu.be/3m4bxse2JEQ >}}

:::












## Zusammenhänge verbildlichen

### Zusammenhang nominaler Variablen


:::{#exm-nom-zshg}
### Beispiele für Zusammenhänge bei nominalen Variablen

- Hängt Berufserfolg (Führungskraft ja/nein) mit dem Geschlecht zusammen?
- Hängt der Beruf des Vaters mit dem Schulabschluss des Kindes (Abitur, Realschule, Mittelschule) zusammen?
- Gibt es einen Zusammenhang zwischen der bevorzugten Automarke und der Präferenz für eine politische Partei?
$\square$
:::


Sagen wir, Sie arbeiten immer noch beim Online-Auktionshaus und Sie fragen sich,
ob ein Produktfoto wohl primär bei neuwertigen Produkten beiliegt, aber nicht bei gebrauchten?
Dazu betrachten Sie wieder die `mariokart`-Daten, s. @fig-zshg-nom1.
Tatsächlich: Es findet sich ein Zusammenhang zwischen der Tatsache, ob dem versteigerten Produkt ein Foto bei lag und ob es neuwertig oder gebraucht war (@fig-zshg-nom1, links).
Bei neuen Spielen war fast immer (ca. 90%) ein Foto dabei; 
bei gebrauchten Spielen immerhin bei gut der Hälfte der Fälle.



```{r fig-zshg-nom1}
#| echo: false
#| label: fig-zshg-nom1
#| fig-asp: 0.7
#| fig-cap: "Zusammenhang zwischen nominalskalierten Variablen verbildlichen. (a) Es findet sich ein Zusammenhang von Foto und Zustand in den Daten. (b) Es findet sich (fast) kein Zusammenhang von `wheel` und Foto in den Daten"
#| fig-subcap: 
#|   - "starker Zusammenhang"
#|   - "schwacher Zusammenhang"
#| layout: [[45,-5, 45], [100]]
#| 

mario_bar1 <- 
mariokart %>% 
  ggplot(aes(x = cond, fill = stock_photo, pattern = stock_photo)) +
  geom_bar_pattern(
    position = "fill", 
    pattern_fill = "grey30",
    pattern_color = "black") +
  scale_fill_okabeito() +
  theme(legend.position = "bottom") +
  theme_minimal() +
  theme_large_text() +
  theme(legend.position = "none") +
  scale_pattern_manual(values = c("yes" = "stripe", "no" = "circle")) +
  labs(fill = "Group", pattern = "Stock photo") # Customize legend titles

mario_bar2 <- 
mariokart %>% 
  ggplot(aes(x = wheels > 0, fill = stock_photo)) +
  geom_bar(position = "fill") +
  scale_fill_manual(values = c(yellow, blue)) +
  theme(legend.position = "bottom") +
  theme_minimal() +
  theme_large_text()

mario_bar1
mario_bar2
```


Anders sieht es aus für die Frage, ob ein (oder mehrere) Lenkräder dem Spiel beilagen (oder nicht) 
in Zusammenhang mit der Fotofrage Hier gab es fast keinen Unterschied zwischen neuen und alten Spielen, 
was die Frage nach "Foto des Produkts dabei" betraf (@fig-zshg-nom1, rechts),
der Anteil betrug jeweils ca. 70%.
Das zeigt, dass es keinen Zusammenhang zwischen Foto und Neuwertigkeit 
des Spiels gibt (laut unseren Daten).
Bildlich gesprochen: Unterscheiden sich die "Füllhöhe" in den Diagrammen, 
so gibt es einen Unterschied hinsichtlich "Foto ist dabei" zwischen 
den beiden Gruppen (linker vs. rechter Balken).
Unterscheiden sich die Anteile in den Gruppen (neuwertige vs. gebrauchte Spiele), 
so spielt z.$\,$B. die Variable "Foto dabei" offenbar eine Rolle. 
Dann hängen Neuwertigkeit und "Foto dabei" also zusammen!

So können Sie sich in R ein gefülltes Balkendiagramm ausgeben lassen, 
z.$\,$B. mit `plot_bar(mariokart, by = "cond")` (Paket `DataExplorer`). 
Diese Darstellung eignet sich, 
um Zusammenhänge zwischen zwei zweistufigen nominalskalierten Variablen zu verbildlichen. 
Die verschiedenen Werte der Füllfarbe werden den Stufen der Variablen `cond` zugewiesen, s. @lst-plot-bar.

```{r}
#| lst-cap: "R-Syntax für ein gefülltes Balkendiagramm"
#| lst-label: lst-plot-bar
#| label: fig-de-bar-filled
#| eval: !expr knitr:::is_html_output()
#| out-width: 50%
#| fig-cap: "Ein gefülltes Balkendiagramm zur Untersuchung eines Zusammenhangs zwischen nominalskalierter Variablen"
mariokart %>% 
  select(cond, stock_photo) %>% 
  plot_bar(by = "cond")  # aus dem Paket DataExplorer
```



*Gefüllte Balkendiagramme* eignen sich zur Analyse eines Zusammenhangs zwischen nominalskalierten Variablen. Allerdings sollte eine der beiden Variablen nur zwei Ausprägungen aufweisen,
sonst sind die Zusammenhänge nicht mehr so gut zu erkennen. 
Außerdem sollten die Balken auf gleiche Länge (100%) ausgerichtet sein. 


::::{#exr-zsmnhang-cond-wheels}

### Zusammenhang visualisieren

Visualisieren Sie den Zusammenhang der beiden nominalen Variablen `cond` und `wheels`!


```{r}
#| out-width: 50%
#| eval: false
mariokart |> 
  # Mache aus einer metrischen eine nominale Variable: 
  mutate(wheels = factor(wheels)) |> 
  select(cond, wheels) |> 
  plot_bar(by = "cond")
```


**Lösung**

`wheels` ist als metrische Variable (`int`: Integer, d.$\,$h. Ganzzahl) 
formatiert im Datensatz `mariokart`. 
Wir müssen Sie zunächst als Faktorvariable umformatieren, 
damit R sie als nominal skalierte Variable erkennt. $\square$
::::

### Zusammenhang bei metrischen Variablen {#sec-zshg-metr}


Den Zusammenhang zweier metrischer Variablen kann man mit einem *Streudiagramm* visualisieren (engl. scatterplot). 
@fig-streu1 links untersucht den Zusammenhang des Einstiegpreises (X-Achse) und Abschlusspreises (Y-Achse) von Geboten bei Versteigerungen des Computerspiels Mariokart.
In dem Diagramm ist eine "Trendgerade" (Regressionsgerade), 
um die Art des Zusammenhangs besser zu verdeutlichen.
Die Trendgerade steigt an (von links nach recht). 
Daraus kann man schließen: Es handelt sich um einen *gleichsinnigen* (positiven) Zusammenhang:
Je höher der Startpreis, desto *höher* der Abschlusspreis, zumindest tendenziell.
Diese Gerade verläuft "mittig" in den Daten (wir definieren das später genauer).
Diese Trendgerade gibt Aufschluss über "typische" Werte: 
Welcher Y-Wert ist "typisch" für einen bestimmten X-Wert?
@fig-streu1 rechts untersucht den Zusammenhang zwischen Anzahl der Gebote (X-Achse) und Abschlusspreises (Y-Achse).
Es handelt sich um einen negativen Zusammenhang: Je mehr Gebote, desto *geringer* der Abschlusspreis (tendenziell).
Das erkennt man an der sinkenden Trendgeraden.
Die Ellipse zeigt an, wie eng die Daten um die Trendgerade streuen. Daraus kann man ableiten, wie stark der Absolutwert des Zusammenhangs ist, vgl. @fig-cors.



```{r}
#| message: false
#| echo: false
#| fig-cap: "Streudiagramm zur Darstellung eines Zusammenhangs zweier metrischer Variablen"
#| label: fig-streu1
#| fig-subcap:
#|   - "positiver, mittelstarker Zusammenhang"
#|   - "negativer, schwacher Zusammenhang"
#| layout: [[45, -10, 45], [100]]

library(ggpubr)
mariokart %>% 
  select(total_pr, start_pr) %>% 
  filter(total_pr < 100) %>% 
  filter(start_pr > 10) %>% 
  ggscatter(x = "start_pr", 
            y = "total_pr",
            add = "reg.line",
            add.params = list(color = "blue"),
            ellipse = TRUE) +
  theme_large_text()


mariokart %>% 
  #select(total_pr, start_pr) %>% 
  filter(total_pr < 100) %>% 
  filter(start_pr > 10) %>% 
  ggscatter(x = "n_bids", 
            y = "total_pr",
            add = "reg.line",
            add.params = list(color = "blue"),
            ellipse = TRUE) +
  theme_large_text()


```


:::{#def-lin-zshg}
### Linearer Zusammenhang

Lässt sich die Beziehung zweier Variablen gut mit einer Geraden beschreiben,
so spricht man von einem linearen Zusammenhang.
Ändert man eine der beiden Variablen um einen bestimmten Wert (z.$\,$B. 1), so ändert sich die andere um einen proportionalen Wert (z.$\,$B. 0.5). 
*Gleichsinnige* (positive) Zusammenhänge erkennt man an *aufsteigenden* Trendgeraden $\nearrow$;
*gegensinnige* (negative) Zusammenhänge an *absteigenden* Trendgeraden $\searrow$. $\square$
:::

Natürlich könnte man auch nicht-lineare Zusammenhänge untersuchen,
aber der Einfachheit halber konzentrieren wir uns hier auf lineare; 
Beispiele für nicht-lineare Zusammenhänge sind in @fig-nonlinear zu sehen.


```{r}
#| label: fig-nonlinear
#| fig-cap: "Beispiele nichtlinearer Zusammenhänge"
#| echo: false
#| fig-width: 7
#| out-width: "75%"

data <- read.csv("data/nonlinear_datasets.csv")

p0 <- ggplot(data) + geom_point()  + theme_void() 

p1 <- p0 + aes(x=x1, y=y1) + ggtitle("Quadratischer Zusammenhang") 
p2 <- p0 + aes(x=x2, y=y2) + ggtitle("Exponenzieller Zusammenhang")
p3 <- p0 + aes(x=x3, y=y3) + ggtitle("Sinus-Zusammenhang")
p4 <- p0 + aes(x=x4, y=y4) + ggtitle("Logarithmischer Zusammenhang")

plots(p1, p2, p3, p4, n_rows = 2, tags = "A")
```





Starke Zusammenhänge erkennt man an schmalen Ellipsen ("Baguette" [🥖]{.content-visible when-format="html"});
schwache Zusammenhänge an breiten Ellipsen ("Torte" [🥮]{.content-visible when-format="html"}).
@fig-cors bietet einen Überblick über verschiedene Beispiele von Richtung und Stärke von Zusammenhängen.^[Quelle: Aufbauend auf FOM/ifes, Autor: Norman Markgraf]
In @fig-cors ist für jedes Teildiagramm eine Zahl angegeben: der *Korrelationskoeffizient*.
Diese Statistik quantifiziert Richtung und Stärke des Zusammenhangs (mehr dazu in Kap. @sec-zusammenhaenge).
Ein positives Vorzeichen steht für einen positiven Zusammenhang, 
ein negatives Vorzeichen für einen negativen Zusammenhang.
Der (Absolut-)Wert gibt die Stärke des linearen Zusammenhangs an.
Cohen [-@cohen_power_1992] hat folgende Faustregeln angegeben:

- $r\approx 0$: Kein Zusammenhang
- $r \pm .1$: schwacher Zusammenhang
- $r \pm .3$: mittlerer Zusammenhang
- $r \pm .5$: starker Zusammenhang
- $r = 1$: perfekter Zusammenhang

```{r}
#| message: false
#| echo: false
#| label: fig-cors
#| fig-cap: "Lineare Zusammenhänge verschiedener Stärke und Richtung"
#| out-width: "75%"
# fig-asp: 0.5
source("funs/plot-different-cors.R")
fig_cors <- plot_different_cors(plot_it = FALSE, alpha = .7)
fig_cors +
  theme_minimal() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) 
```




@fig-cors2 hat die gleiche Aussage wie @fig-cors, 
ist aber plakativer, 
indem *Stärke* (schwach, stark) 
und *Richtung* (positiv, negativ) gegenübergestellt sind.
Man sieht in @fig-cors und @fig-cors2, 
dass ein *negativer* Korrelationskoeffizient mit einer *absinkenden* Trendgerade (synonym: Regressionsgerade; blaue Linie) einhergeht.
Umgekehrt geht ein *positiver* Trend mit einer *ansteigenden* Trendgerade einher.
Zweitens erkennt man, dass *starke* Zusammenhänge mit einer *schmalen* Ellipse einhergehen
und *schwache* Zusammenhänge mit einer *breiten* Ellipse einhergehen.

```{r}
#| message: false
#| echo: false
#| label: fig-cors2
#| fig-cap: "Überblick über starke vs. schwache bzw. positive vs. negative Zusammenhänge"
#| out-width: "75%"
source("funs/plot-different-cors.R")
fig_cors2 <- plot_different_cors(plot_it = FALSE, short = TRUE)
fig_cors2
```




:::::{.content-visible when-format="html" unless-format="epub"}


@fig-scatter-interactive zeigt interaktive Beispiele für (lineare) Zusammenhänge.^[Quelle: <https://observablehq.com/d/bb7ad3ecfb1ac2a6>]



::::{#fig-scatter-interactive}

:::{.figure-content}
{{< include children/scatterplot-interactive.qmd >}}
:::

Interaktives Beispiel für Zusammenhangsdiagramme.

::::

:::::









:::{#exm-scatter}
Sie arbeiten nach wie vor bei einem Online-Auktionshaus, und manchmal gehört Datenanalyse zu Ihren Aufgaben.
Daher interessiert Sie, ob welche Variablen mit dem Abschlusspreis (`total_pr`) im Datensatz `mariokart` zusammenhängen.
Sie verbildlichen die Daten mit R, und zwar nutzen Sie das Paket `DataExplorer`.
Außerdem müssen wir noch die Daten importieren, falls noch nicht getan, s. @lst-mariokart.
So, jetzt kann die eigentliche Arbeit losgehen.
Da Sie sich nur auf einige metrische Variablen konzentrieren wollen, 
wählen Sie (mit `select`) nur diese Variablen aus.
Dann weisen Sie R an, einen Scatterplot zu malen (`plot_scatterplot`) und zwar
jeweils den Zusammenhang einer der gewählten Variablen mit dem Abschlusspreis (`total_pr`),
da das die Variable ist, die Sie primär interessiert.
Das Ergebnis sieht man in @fig-mario-scatter. $\square$
:::


```{r}
#| label: fig-mario-scatter
#| out-width: 50%
#| fig-cap: Der Zusammenhang einiger metrischer Variablen mit Abschlusspreis
mariokart %>% 
  select(n_bids, start_pr, total_pr) %>% 
  plot_scatterplot(by = "total_pr", nrow = 1)
```


Aha. Was sagt uns das Bild? Hm. Es scheint einige Extremwerte zu geben, die 
dafür sorgen, dass der Rest der Daten recht zusammengequetscht auf dem Bild erscheint.
Vielleicht sollten Sie solche Extremwerte lieber entfernen?
Sie entscheiden sich, nur Verkäufe mit einem Abschlusspreis von weniger als 100 Dollar anzuschauen (`total_pr < 100`), s. @lst-no-extreme.

```{r}
#| lst-label: lst-no-extreme
#| lst-cap: Mariokart ohne Extremwerte
mariokart_no_extreme <-
  mariokart %>% 
  filter(total_pr < 100)
```


::: {.content-visible when-format="html"}

Das Ergebnis ist in @fig-mario-scatter2 zu sehen.


```{r}
#| label: fig-mario-scatter2
#| out-width: 50%
#| fig-cap: Der Zusammenhang metrischer Variablen mit Abschlusspreis - ohne Extremwerte
mariokart_no_extreme %>% 
  select(duration, n_bids, start_pr, 
         ship_pr, total_pr, 
         seller_rate, wheels) %>% 
  plot_scatterplot(by = "total_pr")
```


:::

Ohne Extremwerte schält sich ein deutlicheres Bild hervor: Startpreis (`start_pr`) und Anzahl  der Räder (`wheels`) scheinen am stärksten mit dem Abschlusspreis zusammenzuhängen.
Das Argument `by = "total_pr"` bei `plot_scatterplot` weist R an, als Y-Variable stets `total_pr` zu verwenden. Alle übrigen Variablen kommen jeweils einmal als X-Variable vor. $\square$






:::::{.content-visible when-format="html" unless-format="epub"}

::::{#exr-zsmnhang-metrisch}
:::{.panel-tabset}
### Zuammenhang visualisieren

Visualisieren Sie den Zusammenhang der beiden metrischen Variablen `start_pr` und `total_pr`. Verwenden Sie den Datensatz ohne Extremwerte wie oben definiert.


### Lösung

```{r}
#| eval: !expr knitr:::is_html_output()
mariokart_no_extreme |> 
  select(start_pr, total_pr) |> 
  plot_scatterplot(by = "total_pr")
```

Zuerst wählt man die Spalten (mit `select`), die man visualisieren möchte, dann ruft man die Funktion `plot_scatterplot` auf. $\square$



:::
::::
:::::




:::::{.content-visible when-format="pdf"}

::::{#exr-zsmnhang-metrisch}

### Zuammenhang visualisieren

Visualisieren Sie den Zusammenhang der beiden metrischen Variablen `start_pr` und `total_pr`. Verwenden Sie den Datensatz ohne Extremwerte wie oben definiert.


**Lösung**

```{r}
#| eval: !expr knitr:::is_html_output()
#| out-width: 50%
mariokart_no_extreme |> 
  select(start_pr, total_pr) |> 
  plot_scatterplot(by = "total_pr")
```

Zuerst wählt man die Spalten (mit `select`), die man visualisieren möchte, dann ruft man die Funktion `plot_scatterplot` auf. $\square$


::::
:::::





## Unterschiede verbildlichen

### Unterschiede bei nominalen Variablen


Gute Nachrichten: Für nominale Variablen bieten sich Balkendiagramme sowohl zur Darstellung von Zusammenhängen als auch von Unterschieden an. Genau genommen zeigt ja @fig-zshg-nom1 (links) den *Unterschied* zwischen neuen und gebrauchten Spielen hinsichtlich der Frage, ob Fotos beiliegen. 
Und wie man in @fig-zshg-nom1 sieht, ist der Anteil der Spiele mit Foto bei den neuen Spielen höher als bei gebrauchten Spielen.

::: {.content-visible when-format="html"}
[Aber Freunde lassen Freunde keine Tortendiagramme verwenden](https://github.com/cxli233/FriendsDontLetFriends#10-friends-dont-let-friends-make-pie-chart).
:::








### Unterschiede bei quantitativen Variablen


Eine typische Analysefrage ist, ob sich zwei Gruppen hinsichtlich einer metrischen Zielvariablen deutlich (substanziell) unterscheiden. 
So untersucht man z.$\,$B. oft, ob sich die Mittelwerte zweier Gruppen hinsichtlich der Zielvariablen deutlich unterscheiden. 
Das hört sich abstrakt an? 
Am besten wir schauen uns einige Beispiele an, s. @fig-compare-groups1.


```{r}
#| echo: false
#| fig-cap: "Unterschiede zwischen zwei Gruppen: Metrische Y-Variable, nominale X-Variable"
#| fig-subcap:
#|   - "Histogramm pro Gruppe"
#|   - "Boxplot pro Gruppe"
#| label: fig-compare-groups1
#| message: false
#| layout-ncol: 2

ggplot(mariokart_no_extreme, aes(x = cond, y = total_pr)) +
  geom_violinhalf() +
  theme_minimal() +
  theme_large_text()


ggplot(mariokart_no_extreme, aes(x = cond, y = total_pr)) +
  geom_boxplot() +
  theme_minimal()  +
  theme_large_text()
```



Das linke Teildiagramm von @fig-compare-groups1 zeigt das Histogramm von `total_pr`, 
getrennt für neue und gebrauchte Spiele, vgl. @fig-de-hist-density.
Das rechte Teildiagramm zeigt die gleichen Verteilungen, 
aber mit einer vereinfachten, groberen Darstellungsform, 
den *Boxplot*.^[Übrigens: 
Freunde lassen Freunde nicht Balkendiagramme verwenden, um Mittelwerte darzustellen: <https://github.com/cxli233/FriendsDontLetFriends#1-friends-dont-let-friends-make-bar-plots-for-means-separation>.]
Was ein "deutlicher" (substanzieller, bedeutsamer, relevanter oder signifikanter) Zusammenhang ist, 
ist keine statistische, sondern inhaltliche Frage, 
die man mit Sachverstand zum Forschungsgegenstand beantworten muss.


```{r}
#| echo: false
#| eval: false
# fig-cap: "Unterschiede zwischen zwei Gruppen: Metrische Y-Variable, nominale X-Variable"
#| fig-subcap:
#|   - "Y: Abschlusspreis, X: Zustand"
#|   - "Y: Abschlusspreis, X: Foto dabei?"
#| label: fig-compare-groups
#| layout-ncol: 2
mariokart %>% 
  filter(total_pr < 100) %>% 
  ggpubr::ggboxplot(., x = "cond", y = "total_pr")

mariokart %>% 
  filter(total_pr < 100) %>% 
  ggpubr::ggboxplot(., x = "stock_photo", y = "total_pr")
```



<!-- Das linke Teildiagramm von @fig-compare-groups zeigt den Unterschied in den Verteilungen von `total_pr`, einmal für die neuen Computerspiele (`cond == new`) und einmal für gebrauchte Spiele (`cond == used`). -->


:::{#def-boxplot}

### Boxplot
Der Boxplot ist eine Vereinfachung bzw. eine Zusammenfassung eines Histograms.
Damit stellt der Boxplot auch eine Verteilung (einer metrischen Variablen) dar. $\square$
:::


In @fig-hist-to-box sieht man die "Übersetzung" von Histogramm (oben) zu einem Boxplot (unten). Ob der Boxplot horizontal oder vertikal steht, ist Ihrem Geschmack überlassen.



```{r}
#| label: fig-hist-to-box
#| fig-cap: "Übersetzung eines Histogramms zu einem Boxplot"
#| message: false
#| echo: false

source("funs/histogram-to-boxplot.R")
hist_to_box <- histogram_to_boxplot(mariokart_no_extreme, "total_pr", plot_it = FALSE)
hist_to_box +
  labs(caption = "Md: Median; Q1/3: 1./3. Quartil",
       x = "total_pr (Gesamtpreis)") +
 theme(plot.margin = margin(1, 0, 0, 0, "cm"))
```





Schauen wir uns die "Anatomie" des Boxplots näher an:

1. Der *dicke Strich* in der Box zeigt den Median der Verteilung, vgl. @sec-median. 
2. Die *Enden der Box* zeigen das 1. Quartil (41) bzw. das 3. Quartil (54). Damit zeigt die Breite der Box die Streuung der Verteilung an, genauer gesagt die Streuung der inneren 50% der Beobachtungen. Je breiter die Box, desto größer die Streuung. Die Breite der Box nennt man auch den *Interquartilsabstand* (IQR).
3. Die "*Antennen*" des Boxplots zeigen die Streuung in den kleinsten 25$\,$% der Werte (linke Antenne) bzw. die Streuung der größten 25$\,$% der Werte (rechte Antenne). Je länger die Antenne, desto größer die Streuung (in den äußeren Vierteln).
4. Falls es aber *Extremwerte* gibt, so sollten die lieber einzeln, separat, außerhalb der Antennen gezeigt werden. Daher ist die Antennenlänge auf die 1.5-fache Länge der Box beschränkt. Werte die außerhalb dieses Bereichs liegen (also mehr als das 1.5-fache der Boxlänge von Q3 entfernt sind) werden mittels eines Punktes dargestellt.
5. Liegt der Median-Strich in der Mitte der Box, so ist die Verteilung *symmetrisch* (bezogen auf die inneren 50$\,$% der Werte), liegt der Median-Strich nicht in der Mitte der Box, so ist die Verteilung nicht symmetrisch (d.$\,$h. sie ist *schief*). Gleiches gilt für die Antennenlängen: Sind die Antennen gleich lang, so ist der äußere Teil der Verteilung symmetrisch, andernfalls schief.


:::{#exm-Boxplots}

In einer vorherigen Analyse haben Sie den Zusammenhang von Abschlusspreis und der Anzahl der Lenkräder untersucht.
Jetzt möchten Sie eine sehr ähnliche Fragestellung betrachten:
Wie *unterscheiden* sich die Verkaufspreise je nach Anzahl der beigelegten Lenkräder?
Flink erstellen Sie dazu folgendes Diagramm, @fig-box-wheels1, links.
Es zeigt die Verteilung des Abschlusspreises, aufgebrochen nach Anzahl Lenkräder (`by = "wheels"`). $\square$
:::



Aber ganz glücklich sind Sie mit dem Diagramm nicht: 
R hat die Variable `wheels` komisch aufgeteilt. 
Es wäre eigentlich ganz einfach,
wenn R die Gruppen `0`, `1`, `2`, `3` und `4` aufteilen würde.
Aber schaut man sich die Y-Achse (im linken Teildiagramm von @fig-box-wheels1) an,
so erkennt man, 
dass R `wheels` als stetige Zahl betrachtet und nicht in ganze Zahlen gruppiert. Vielleicht wird so gruppiert, dass in jeder Gruppe gleich viele Werte sind?
Aber wir möchten jeden einzelnen Wert von `wheels` (0, 1, 2, 3, 4) als *Gruppe* verstehen.
Mit anderen Worten, wir möchten `wheels` als nominale Variable definieren.
Das kann man mit dem Befehl `factor(wheels)` erreichen (verpackt in `mutate`), s.
@fig-box-wheels1 rechts.

```{r}
#| eval: false
#| echo: true
mariokart_no_extreme |> 
  select(total_pr, wheels) %>% 
  # Probieren Sie den Code mit bzw. ohne folgender Zeile:
  mutate(wheels = factor(wheels)) |>  # wheels als nominale Variable
  plot_boxplot(by = "wheels")  # Boxplot mit "wheels" auf der Y-Achse
```


```{r}
#| label: fig-box-wheels1
#| echo: false
#| fig-cap: "Abschlusspreis nach Anzahl von beigelegten Lenkrädern"
#| fig-subcap: 
#|   - "`wheels` als metrische Variable"
#|   - "`wheels` als nominale Variable"
#| layout-ncol: 2
mariokart_no_extreme %>%  # `wheels as metrische Variable`: 
  select(total_pr, wheels) %>% 
  plot_boxplot(by = "wheels") 

mariokart_no_extreme %>%  # `wheels as nominale Variable`: 
  select(total_pr, wheels) %>% 
  mutate(wheels = factor(wheels)) %>% 
  plot_boxplot(by = "wheels")
```

Sie schließen aus dem Bild, dass Lenkräder und Preis (positiv) zusammenhängen.
Allerdings scheint es wenig Daten für `wheels == 4` zu geben.
Das prüfen Sie nach:

```{r}
mariokart_no_extreme %>% 
  count(wheels)
```

Tatsächlich gibt es (in `mariokart_no_extreme`) auch für 3 Lenkräder schon wenig Daten,
so dass wir die Belastbarkeit dieses Ergebnisses skeptisch betrachten sollten.
Übrigens bezeichnet Sie Ihre Chefin nur noch als "Datengott".


::::{#exr-diff-plot}

### Visualisieren Sie den Unterschied im Verkaufspreis zwischen gebrauchten und neuen Spielen.

Es gibt mehrere Diagrammtypen, die sich anbieten;
mehrere Lösungen sind also möglich.

**Lösung**

```{r}
#| eval: !expr knitr:::is_html_output()
#| out-width: 50%
mariokart_no_extreme |> 
  select(cond, total_pr) |> 
  plot_boxplot(by = "cond")
```

Boxplots sind eine gute Möglichkeit, die Verteilung einer metrischen Variablen, 
aufgebrochen auf mehrere Gruppen, zu visualisieren. $\square$

::::


<!-- TODO MW-Unterschiede visualisieren -->



::::{#exr-diff-plot}

### Verkaufspreis im Vergleich

Visualisieren Sie den Unterschied im Verkaufspreis abhängig von `ship_pr`;
betrachten Sie `ship_pr` als ein Gruppierungsvariable. 
Interpretieren Sie das Ergebnis.

**Lösung**

```{r}
#| eval: !expr knitr:::is_html_output()
#| out-width: 50%
mariokart_no_extreme |> 
  select(ship_pr, total_pr) |> 
  plot_boxplot(by = "ship_pr")
```

`plot_boxplot` gruppiert *metrische* Variablen, wie `ship_pr` automatisch in fünf Gruppen (mit gleichen Ranges). 
Wir müssen also nichts tun, um die metrische Variable `ship_pr` 
in eine Gruppierungsvariable (Faktorvariable) umzuwandeln.
Es sieht so aus, als würde der Median zwischen den Gruppen leicht steigen, 
mit Ausnahme der mittleren Gruppe. $\square$


::::









## So lügt man mit Statistik

Diagramme werden mitunter eingesetzt, um die Wahrheit "aufzuhübschen". 
Achsen zu stauchen, ist ein recht beliebter Trick, s. @fig-lie1.
Natürlich kann man auch durch "Abschneiden" der Y-Achse einen eindrucksvollen Effekt erzielen, s. @fig-lie2.
Scheinkorrelationen als "echte", also kausale Effekte zu verkaufen, ist ein anderer Trick, 
den man immer mal wieder beobachten kann. Ein Beispiel: 
@messerli_chocolate_2012 berichtet von einem Zusammenhang von Schokoladenkonsum 
und Anzahl von Nobelpreisen (Beobachtungseinheit: Länder), s. @fig-choc.
Das ist doch ganz klar: Schoki futtern macht schlau und Nobelpreise! (?)
Leider ist hier von einer *Scheinkorrelation* auszugehen: Auch wenn die beiden Variablen *Schokoladenkonsum* und *Nobelpreise* zusammenhängen, heißt das *nicht*, 
dass die eine Variable die Ursache und die andere die Wirkung sein muss. 
So könnte auch eine Drittvariable im Hintergrund die gleichzeitige Ursache von Schokoladenkonsum und Nobelpreise sein, etwa der *allgemeine Entwicklungsstand* des Landes: 
In höher entwickelten Ländern wird mehr Schokolade konsumiert und es werden mehr Nobelpreise gewonnen im Vergleich zu Ländern mit geringerem Entwicklungsstand.

![Schokoladenkonsum und Nobelpreise](img/choc.jpeg){#fig-choc width="75%"}




```{r}
#| echo: false
#| label: fig-lie1
#| fig-cap: "Strecken und Stauchen der Achse(n), um mit Statistik zu lügen"
#| out-width: "100%"
#| fig-subcap: 
#|   - "Oh nein, dramatischer Einbruch des Umsatzes!"
#|   - "Kaum der Rede wert, ist nur ein bisschen Schwankung!"
#| layout: [[45,-10, 45], [100]]
#| 
d <- tibble(
  Jahr = c(1, 2, 3, 4, 5),
  Umsatz = c(100, 98, 94, 93, 70)
)

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal() +
  scale_y_continuous(limits = c(0, 100)) +
   coord_fixed(ratio = .10)

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal() +
  scale_y_continuous(limits = c(0, 100)) +
  coord_fixed(ratio = .010) +
  theme_large_text()

```

```{r}
#| echo: false
#| label: fig-lie2
#| fig-cap: "Abschneiden der Y-Achse, um mit Statistik zu lügen"
#| out-width: "100%"
#| fig-subcap: 
#|   - "Oh nein, dramatischer Einbruch des Umsatzes!"
#|   - "Kaum der Rede wert, ist nur ein bisschen Schwankung!"
#| layout: [[45,-5, 45], [100]]

d <- tibble(
  Jahr = c(1, 2, 3, 4, 5),
  Umsatz = c(100, 98, 94, 93, 70)
)

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal()

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal() +
  scale_y_continuous(limits = c(0, 100))
```


## Praxisbezug


Ein, wie ich finde, schlagendes Beispiel zur Stärke von Datendiagrammen ist @fig-vaccine [@debold_battling_2015].
Das Diagramm zeigt die Häufigkeit von Masern, 
vor und nach der Einführung der Impfung.
Die Daten und die Idee zur Visualisierung gehen auf @van_panhuis_contagious_2013 zurück.



![Häufigkeit von Masern und Impfung in den USA [@moore_recreating_2015]](img/vaccine.jpg){#fig-vaccine width=75%}





In der "freien Wildbahn" findet man häufig sog. "Tortendiagramme".
Zwar sind sie beliebt, doch [von ihrer Verwendung ist zumeist abzuraten](https://www.data-to-viz.com/caveat/pie.html),
denn bei Tortenstücken ist es schwer, die Größe zu vergleichen.

::: {.content-visible when-format="html"}
Freunde lassen Freunde  [keine Tortendiagramme zeichnen](https://github.com/cxli233/FriendsDontLetFriends#10-friends-dont-let-friends-make-pie-chart).
:::


## Quiz

```{r}
#| include: false

exs_vis <- 
list(
  "exs/Achsen_Trick.Rmd",
  "exs/Praxis_Datenjudo.Rmd",
  "exs/Okabe_Ito.Rmd",
  "exs/Torten_Kritik.Rmd",
  "exs/Schein_Korr.Rmd",
  "exs/Balken_Normierung.Rmd",
  "exs/Bosplot_Schiefe.Rmd",
  "exs/Scatter_Ellipse.Rmd",
  "exs/Normal_Rechnen.Rmd",
  "exs/Plot_Wahl.Rmd",
  "exs/Anscombe_Logik.Rmd"
)
```


```{r quiz-kap-viz, message=FALSE, results="asis"}
exams2forms(exs_vis, box = TRUE, check = TRUE)
```


## Aufgaben

Die Webseite [datenwerk.netlify.app](https://datenwerk.netlify.app) stellt eine Reihe von einschlägigen Übungsaufgaben bereit. 
Sie können die Suchfunktion der Webseite nutzen, um die Aufgaben mit den folgenden Namen zu suchen:


1. [boxhist](https://sebastiansauer.github.io/datenwerk/posts/boxhist/boxhist.html)
2. [max-corr1](https://sebastiansauer.github.io/datenwerk/posts/max-corr1/max-corr1.html)
4. [max-corr2](https://sebastiansauer.github.io/datenwerk/posts/max-corr2/max-corr2.html)
3. [histogramm-in-boxplot](https://sebastiansauer.github.io/datenwerk/posts/histogramm-in-boxplot/histogramm-in-boxplot)
4. [diamonds-histogramm-vergleich2](https://sebastiansauer.github.io/datenwerk/posts/diamonds-histogramm-vergleich2/diamonds-histogramm-vergleich2)
6. [boxplot-aussagen](https://sebastiansauer.github.io/datenwerk/posts/boxplot-aussagen/boxplot-aussagen)
7. [boxplots-de1a](https://sebastiansauer.github.io/datenwerk/posts/boxplots-de1a/boxplots-de1a.html)
9. [movies-vis1](https://sebastiansauer.github.io/datenwerk/posts/movies-vis1/movies-vis1.html)
10. [movies-vis2](https://sebastiansauer.github.io/datenwerk/posts/movies-vis2/movies-vis2.html)
11. [vis-gapminder](https://sebastiansauer.github.io/datenwerk/posts/vis-gapminder/vis-gapminder)
12. [boxplots-de1a](https://sebastiansauer.github.io/datenwerk/posts/boxplots-de1a/boxplots-de1a)
13. [diamonds-histogramm-vergleich](https://sebastiansauer.github.io/datenwerk/posts/diamonds-histogramm-vergleich/diamonds-histogramm-vergleich)
14. [wozu-balkendiagramm](https://sebastiansauer.github.io/datenwerk/posts/wozu-balkendiagramm/wozu-balkendiagramm)
15. [diamonds-histogram](https://sebastiansauer.github.io/datenwerk/posts/diamonds-histogram/diamonds-histogram)
16. [n-vars-diagram](https://sebastiansauer.github.io/datenwerk/posts/n-vars-diagram/n-vars-diagram)

Weitere Aufgaben zum Thema Datenvisualisierung finden Sie im Datenwerk unter dem Tag [vis](https://sebastiansauer.github.io/Datenwerk/#category=vis).









## Vertiefung

::: {.content-visible when-format="html" unless-format="epub"}
Mehr Informationen zu `{DataExplorer}` finden Sie [hier](https://boxuancui.github.io/DataExplorer/index.html).
:::

::: {.content-visible when-format="html" unless-format="epub"}

### Animation


Eine weitere nützliche Art von Visualisierung sind *Karten*, *3D-Bilder* und *Animationen.*
So zeigt z.$\,$B. @fig-le-world die Veränderung der Lebenserwartung (in Jahren)
über die letzten Dekaden.^[Der Quellcode der Animation ist hier  zu finden: <https://gist.github.com/rafapereirabr/0d68f7ccfc3af1680c4c8353cf9ab345>.]

![Animation zur Veränderung der Lebenserwartung](img/life-exp-world.gif){#fig-le-world width="75%"}





In einigen Situation können Animationen zweckdienlich sein.
Außerdem sind sie mitunter nett anzuschauen, s. @fig-anim1.

![Veränderung des Zusammenhangs von Lebenserwartung und Bruttosozialprodukt pro Land, gegliedert nach Kontinenten](img/animate1.gif){#fig-anim1 width="75%"}


<!-- Um den gemeinsamen Zusammenhang dreier metrischer Variablen darzustellen,  -->
<!-- bietet sich ein 3D-Streudiagramm an; s. @fig-mario-3d. -->


<!-- ```{r mario3d} -->
<!-- #| echo: false -->
<!-- #| eval: !expr knitr:::is_html_output() -->
<!-- #| label: fig-mario-3d -->
<!-- #| fig-cap: "3D-Punktediagramm zum Datensatz mariokart" -->

<!-- fig2 <- plot_ly(mariokart |> filter(total_pr < 100),  -->
<!--                 x = ~duration, y = ~n_bids, z = ~total_pr,  -->
<!--                 color = ~cond, colors = c('#BF382A', '#0C4B8E')) -->
<!-- fig2 <- fig2 %>% add_markers() -->
<!-- fig2 <- fig2 %>% layout(scene = list(xaxis = list(title = 'duration'), -->
<!--                      yaxis = list(title = 'number of bids'), -->
<!--                      zaxis = list(title = 'total price'))) -->

<!-- fig2 -->
<!-- ``` -->


<!-- Leider ist @fig-mario-3d nicht sehr aufschlussreich. -->



Natürlich sind der Fantasie keine Grenzen beim Visualisieren gesetzt, 
so ist etwa [diese Animation](https://www.tylermw.com/wp-content/uploads/2019/06/featuredmeasles.mp4) ziemlich beeindruckend.
^[<https://www.tylermw.com/wp-content/uploads/2019/06/featuredmeasles.mp4>]


:::

### Schicke Diagramme

Ein Teil der Diagramme dieses Kapitels wurden mit dem R-Paket [ggpubr](https://rpkgs.datanovia.com/ggpubr/) erstellt.
Mit diesem Paket lassen sich einfach ansprechende Datendiagramme erstellen.




```{r}
#| eval: false
library(ggpubr)  # einmalig instalieren nicht vergessen
mariokart %>% 
  filter(total_pr < 100) %>% 
  ggboxplot(x = "cond", y = "total_pr")
```



Möchte man Mittelwerte vergleichen, so sind Boxplots nicht ideal, 
da diese ja nicht den Mittelwert, sondern den *Median* herausstellen.
Eine Abhilfe (also eine Darstellung des Mittelwerts) schafft man (z.$\,$B.) 
mit `ggpubr` und der Funktion `ggviolin`,
s. @fig-comp-means-ggpubr.


```{r}
#| label: fig-comp-means-ggpubr
#| out-width: 50%
#| fig-cap: Vergleich der Verteilungen zweier Gruppen mit Mittelwert und Standardabweichung pro Gruppe hervorgehoben
ggviolin(mariokart_no_extreme, 
         x = "cond", y = "total_pr", add = "mean_sd") 
```


::: {.content-visible when-format="html" unless-format="epub"}
Weitere Varianten zum Violinenplot mit `ggpubr` finden sich [hier](https://rpkgs.datanovia.com/ggpubr/reference/ggviolin.html).^[<https://rpkgs.datanovia.com/ggpubr/reference/ggviolin.html>]
:::




Ein "Violinenplot" hat die gleiche Aussage wie ein Dichtediagramm:
Je breiter die "Violine", desto mehr Beobachtungen gibt es an dieser Stelle.
Übrigens sind Modelle -- und Diagramme sind Modelle -- 
immer eine Vereinfachung,
lassen also Informationen weg.
Manchmal auch wichtige Informationen. 


::: {.content-visible when-format="html" unless-format="epub"}
[Dieses Beispiel](https://www.autodesk.com/research/publications/same-stats-different-graphs) zeigt, 
wie etwa Histogramme wichtige Informationen unter den Tisch fallen lassen.^[<https://www.autodesk.com/research/publications/same-stats-different-graphs>]
Ein weiteres R-Paket zur Erstellung ansprechender Datenvisualisierung heißt [`ggstatsplot`](https://github.com/IndrajeetPatil/ggstatsplot/blob/main/README.md).^[<https://github.com/IndrajeetPatil/ggstatsplot/blob/main/README.md>]
@fig-ggstatsplot zeigt ein [Histogramm](https://github.com/IndrajeetPatil/ggstatsplot/blob/main/README.md#gghistostats), das mit `ggstatsplot` erstellt wurde.^[<https://github.com/IndrajeetPatil/ggstatsplot/blob/main/README.md#gghistostats>]


```{r}
#| label: fig-ggstatsplot
#| fig-cap: Ein Histogramm mit ggstatsplot
library(ggstatsplot)

gghistostats(
  data       = mariokart_no_extreme,
  x          = total_pr,
  xlab       = "Verkaufspreis" 
  # results.subtitle = FALSE   # unterdrückt statist. Details
)
```

Die Menge der statistischen Kennzahlen bei `ggstatsplot` schindet ordentlich Eindruck. 
Möchte man auf die Kennzahlen verzichten, 
so nutzt man den Schalter `results.subtitle = FALSE`. 
(Weitere Hinweise finden sich auf der Hilfeseite der Funktion der Funktion.)
:::




::: {.content-visible when-format="html" unless-format="epub"}
>   [👩‍🏫]{.content-visible when-format="html"}[\emoji{student}]{.content-visible when-format="pdf"} Ich würde gerne mal Beispiele von *schlechten* Datendiagrammen sehen.

>   [🧑‍🎓]{.content-visible when-format="html"}[\emoji{teacher}]{.content-visible when-format="pdf"} Auf der Seite von [Flowingdata](https://flowingdata.com/category/visualization/ugly-visualization/) findet sich eine nette Liste mit schlechten Datendiagrammen.^[<https://flowingdata.com/category/visualization/ugly-visualization/>]
:::


### Farbwahl {#sec-farbwahl}

Einige Überlegungen zur Farbwahl findet sich bei @wilke_fundamentals_2019, Kap. 4.
Die Farbpalette von Okabe und Ito ist [vgl. @ichihara_color_2008] empfehlenswert, 
das sie über über optisch gut unterscheidbarer und klar benennbare Farben verfügt.
Außerdem erlaubt sie bei Sehschwächen die Farben noch recht gut zu unterscheiden, s. @fig-okabe.
Möchte man sie für Schwarz-Weiß-Druck verwenden, 
kann man angeben, dass als erste Farbe Schwarz verwendet werden soll;
dazu nutzt man den Paramter `palette = "black_first"`.
Alternativ kann man händisch eine helle Farbe und eine dunkle Farbe als Kontrast aussuchen.



```{r}
#| label: fig-okabe
#| out-width: 50%
#| fig-cap: "Die Farbpalette von Okabe und Ito: Geeignet bei Farbseh-Schwächen. Außerdem nett anzuschauen. Die Einkerbungen (engl. notches) zeigen ein 95%-Konfidenzintervall für den Median."

mariokart %>% 
  filter(total_pr < 100) %>% 
  ggboxplot(x = "cond", y = "total_pr", fill = "cond", notch = TRUE) +
  scale_fill_okabeito(palette = "black_first")
  #scale_fill_manual(values = c("#0072B2", "#E69F00"))
```


Mit `fill = cond` erreicht man, dass die Füllfarbe der Variable `cond` zugeordnet wird: 
Jeder Wert von `cond` (new/used) bekommt eine eigene Farbe. 
Welche das ist, hängt vom verwendeten Farbschema ab. 
Hier wird das Farbscheme von Okabe und Ito verwendet [@ichihara_color_2008].

:::{#exr-okabi-cols}
Schauen Sie sich die Farbpalette von Okabe und Ito einmal näher an, z.$\,$ so:

```{r}
#| eval: false
library(scales)
library(see)
show_col(okabeito_colors())
```

Die Füllfarbe eines Diagramms, z.$\,$ in @fig-okabe, können Sie ändern, 
indem Sie `scale_fill_okabeito` ersetzen durch `scale_fill_manual(values = c("#0072B2", "#E69F00"))`. 
Probieren Sie dabei verschiedene Farben aus. $\square$
:::

## Literaturhinweise


Sowohl `ggpubr` [@kassambara2023] als auch `DataExplorer` [@cui2024] (und viele andere R-Pakete) bauen auf dem R-Paket `ggplot2` [@wickham2016d] auf.
`ggplot2` ist eines der am weitesten ausgearbeiteten Softwarepakete zur Erstellung von Datendiagrammen.
Das Buch zur Software (vom Autor von `ggplot2`) ist empfehlenswert [@wickham2016d].
Eine neuere, gute Einführung in Datenvisualisierung findet sich bei @wilke_fundamentals_2019.
Beide Bücher sind kostenfrei online lesbar.
@wilke_fundamentals_2019 gibt einen hervorragenden Überblick über praktische Aspekte der Datenvisualisierung; gut geeignet, wenn man mit R arbeitet.
In ähnlicher Richtung geht @fisher_making_2018.

:::{.content-visible when-format="html"}

[Hier](https://www.bing.com/search?pc=OA1&q=introductory%20books%20on%20data%20visualization%20with%20DOI) ist eine Liste von Büchern zum Thema; 
dort können Sie bei Interesse tiefer suchen.

:::






