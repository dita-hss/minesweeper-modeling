# MineSweeper Model

> #### Amanda and John

[Video Presentation](https://drive.google.com/file/d/1K3ILQuIyuEs45hzJLomFeHG84I67srLA/view?usp=sharing)

## Overall Breakdown:

The file is divided into three parts: 
- The general representation
- The algorithims, which use the information available to the player to make a somewhat educated guess about where to go and where not to go
- The traces and optimizer

**The general representation:** Here we set up the constructs of the model, this includes creating the necessary sigs and populating the board. 

**The algorithms:**
The algorithms are set up as game traces of which build off of each other adding a level of inference at every newlevel.

**The Traces:** 
This assignment aimed to prove and explore the existence of imperfect information and modeling within a logical framework, such as Forge, using the game minesweeper. We have 4 main traces to attemot and display this. We will discuss these traces further down as well as in the attached video. 

## Specific Questions 

> **What tradeoffs did you make when choosing your representation? What else did you try that didn't work as well?**

The most significant tradeoff of our representation of perfect and imperfect information was that the more complicated the logic was, the longer the runtime. Since the larger game traces allowed us to show more (relatively more) complicated logic patterns, we needed to find a balance between those complicated logic patterns and runtime. As possible solutions, we implemented an optimizer, cutting down the possible number of iterations from the size of the board to the amount of possible adjacent mines. Due to this, we decided on using a input variable set in terms of runtime to be able to show the ability of the smarter algorithms to "beat out" the lower-level algorithms. 

> **What assumptions did you make about scope? What are the limits of your model?**

One of the main assumptions we made was that larger boards will still hold the logic of our model. However, due to runtime issues, it is not something that we have directly tested and/or gone through the visualizer. The largest board we have tested and checked the logic of was a 12 by 12 board and the logic appeared to be consistent. If one would like to look through larger boards, the runtime would be significant. 


> **Did your goals change at all from your proposal? Did you realize anything you planned was unrealistic or that anything you thought was unrealistic was doable?**

Our goals within runtime quickly became unrealistic, from the beginning knew that the ability to run through a full game of minesweeper (even with the optimizer) on a large board did not seem incredibly realistic. It is to note that the model can suppport larger traces with larger boards, however, the runtime increases significantly. For example, a 12 by 12 board would require about 3 minutes with the perfect information game trace which is the simplest trace. With more complicated traces, this increases past 10 minutes. Despite this drawback, we were still able to show and model the idea we had in the beggining with algorithims representing decisions making processes looking at imperfect information versus perfect information. 

> **How should we understand an instance of your model and what your visualization shows (whether custom or default)?**

All traces begin with the programmers board at the top left. This board shows what is laying underneath all of the hidden cells. Therefore, the mines and adjacent mines are highlighted. The rest of the cells show the actual game trace of the game from top to bottom and from left to right.

The four traces are called `perfectInfo`, `DumbAlgo`,`kindaSmartAlgo`,`relativelySmartestAlgo`. 

The `perfectInfo` trace is a recreation of the game Minesweeper with Traces, where every move taken is a move that will not hit a mine; this is to highlight the contrast of perfect information towards the other algorithms. The other algorithms only base their choices on the revealed squares and will make a random move when there is a situation in which they cannot make a more educated guess. (For a more in-depth explanation, look at the comments within the predicate)

The `DumbAlgo` is a basic logic algorithim that gathers as much information as possible before making a completely random move.

The `kindaSmartAlgo` takes this a step further, and after gathering the information, the algorithim will choose if it is the right move or not by checking if I know that there is a mine in the correct position based on the information of only one tile. 

The `relativelySmartestAlgo` takes this a step even further. After gathering the information and making all the decisions it can from only one tile, it makes an educated guess based on the information of two tiles, increasing the dimension of logical reasoning by one.