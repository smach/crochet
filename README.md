# Experimental Overlay Mosaic Crochet Pattern Chart Generator

**What's in this repo?** Code for what turned out to be the most popular Web app I've ever created! Years later it's still getting a few thousand visits per month. More specifically, this repository contains code for an app to generate overlay mosaic grid patterns from designs you create by clicking on squares to toggle colors on and off. I coded this for myself to have some fun playing around with simple designs to see what they would look like in an overlay mosaic crochet pattern. It wasn't created with serious designers in mind! Understanding the algorithm behind how overlay mosaic patterns work helps me when I'm crocheting someone else's design.

Once I put it so much time into it, though, I figured I'd share it in case anyone else might find it interesting. You can see the app online at [https://apps.machlis.com/shiny/crochetapp](https://apps.machlis.com/shiny/crochetapp/).

**Who created this?** I'm Sharon Machlis, a long-time journalist and data geek who loves coding and data. I've also been crocheting on and off for many years. I discovered overlay mosaic crochet in the Spring of 2022 after seeing the incredibly cool [Azul pattern by Tinna Thórudóttir Thorvaldsdóttir](https://www.ravelry.com/patterns/library/azul-9) and I am, well, hooked.

**How would I use this app to make a design?** Options are in the left column. Choose your grid size -- number of rows must be odd and between 5 and 51; number of columns between 5 and 50. You can keep the default colors or choose colors of your own, and also choose your own pattern title. Then start clicking squares in the first table below to create your design. When you're ready to see what it looks like as a grid pattern, click the "Generate pattern!" button.

Note that the system does not save your work. If you're using the online version, **I can't guarantee that your work won't be interrupted and potentially lost because of an Internet issue on your side or server issue on my side** (the app is hosted on a $10/month Digital Ocean server and has multiple other apps as well). **USE AT YOUR OWN RISK.** If you're working on something for more than a few minutes, saving your design periodically is highly recommended.

**Can I use your code to run this app locally?** Absolutely! Download the code from GitHub and make sure you've got R installed as well as all the packages that are needed (you can see those at the top of the app.R file). I also recommend running it with RStudio.

**How do I save my design?** Once you generate a grid pattern, you'll see a button to download the pattern as an HTML file.

**HTML file? I want a PDF/Word Document/Excel file.** For a variety of technical reasons, generating an HTML was easiest. Since this is a free app I coded for myself for fun, there's a limit to how much time I want to invest in it! Once you download an HTML file from here, you can easily upload that HTML file to a free converter like [cloudconvert.com](https://cloudconvert.com/html-to-pdf) to get a PDF. Other services like [Cometdocs](https://www.cometdocs.com/) can turn a PDF into an Excel file.

**Can I use this app to create commercial designs?** I want to repeat that _I can't guarantee your work won't get interrupted and possibly lost when using this app!_ If you're willing to take that risk, though, feel free to use this for creating patterns you want to sell. I'd love it if you'd offer me a free copy :) but it's not required. In fact, if you make something cool with this, even if you're not selling it, I'd be interested to see it! You can email me at crochetapp @ machlis.com.

**How did you create this app?** With the R programming language including packages [DT](https://rstudio.github.io/DT/), [gt](https://gt.rstudio.com/), [dplyr](https://dplyr.tidyverse.org/), [data.table](https://r-datatable.com,), [glue](https://glue.tidyverse.org/), and a [Web framework for R called Shiny](https://shiny.rstudio.com/). 

You can [see the code on GitHub](https://github.com/smach/crochet).

I create this while working as a data professional doing analysis for a tech publisher with R as well as hosting the [Do More With R](https://bit.ly/domorewithR) series at InfoWorld. I also wrote [Practical R for Mass Communication and Journalism](https://www.machlis.com/R4Journalists/). Now I'm happily retired and have more time for hobby coding _and_ crochet projects.

