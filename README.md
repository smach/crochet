# Experimental Overlay Mosaic Crochet Pattern Chart Generator


**What is this?** This repo contains code for my beta design tool at [https://apps.machlis.com/shiny/crochetapp/](https://apps.machlis.com/shiny/crochetapp/)that creates overlay mosaic crochet patterns. The app generates overlay mosaic grid patterns from designs users create by clicking on squares to toggle colors on and off. I coded this for myself to have some fun playing around with simple designs to see what they would look like in an overlay mosaic crochet pattern. It wasn't created with serious designers in mind! Understanding the algorithm behind how overlay mosaic patterns work helps me when I'm crocheting someone else's design.

Once I put it so much time into it, though, I figured I'd share it in case anyone else might find it interesting.

**Can I run it locally instead of using your Web version?** Yes! Download the code from the repo. You'll need R and all the packages the app uses. I also suggest running it with RStudio.

**Who created this?** I'm Sharon Machlis, a journalist and data geek who loves coding and data. I've also been crocheting on and off for many years. I just discovered overlay mosaic crochet in the Spring of 2022 and am, well, hooked.

**How do I use this app to make a design?** Options are in the left column. Choose your grid size -- number of rows must be odd and between 5 and 51; number of columns between 5 and 50. You can keep the default colors or choose colors of your own, and also choose your own pattern title. Then start clicking squares in the first table below to create your design. When you're ready to see what it looks like as a grid pattern, click the "Generate pattern!" button.

Note that the system does not save your work. **I can't guarantee that your work won't be interrupted and potentially lost because of an Internet issue on your side or server issue on my side** (this app is hosted on a $10/month Digital Ocean server and has multiple other apps as well). **USE AT YOUR OWN RISK.** If you are serious, you probably want to run this locally.

**How do I save my design?** Once you generate a grid pattern, you'll have the option to download the pattern as an HTML file.

**HTML file? I want a PDF/Word Document/Excel file.** For a variety of technical reasons, generating an HTML was easiest. Since this is a free app I coded for myself for fun, there's a limit to how much time I want to invest in it! Once you download an HTML file from here, you can easily upload that HTML file to a free converter like [cloudconvert.com](https://cloudconvert.com/html-to-pdf) to get a PDF. Other services like [Cometdocs](https://www.cometdocs.com/) can turn a PDF into an Excel file.

**Can I use this commercially?** I want to repeat that _I can't guarantee your work won't get interrupted and possibly lost when using this system!_ If you're willing to take that risk, though, feel free to use this for creating patterns you want to sell. I'd love it if you'd offer me a free copy :) but it's not required. In fact, if you make something cool with this, even if you're not selling it, I'd be interested to see it! You can email me at crochetapp @ machlis.com.

**How did you create this app?** With the R programming language including packages [DT](https://rstudio.github.io/DT/), [gt](https://gt.rstudio.com/), [dplyr](https://dplyr.tidyverse.org/), [data.table](https://r-datatable.com,), [glue](https://glue.tidyverse.org/), and a [Web framework for R called Shiny](https://shiny.rstudio.com/). 
