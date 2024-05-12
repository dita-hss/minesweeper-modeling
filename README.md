# minesweeper-modeling
Overall Breakdown:
The file is divided into three parts: the general representation, the algorithims, which use the information available to the player to make a somewhat educated guess about where to go and where not to go, and the traces and optimizer. 

The general representation: 
Where we build the constructs of the model for the algorithms to play around.

The algorithms: 
They build off each other, adding a level of inference with every level.

The Traces: 
4 traces, all based on the same inputs for the generation of the board and the 
There are examples of longer and more complicated traces within the video. 
This assignment aimed to prove and explore the existence of imperfect information and modeling within a logical framework, such as Forge, using the game minesweeper.

Specific Questions 
What tradeoffs did you make when choosing your representation? What else did you try that didn't work as well?

Within the tradeoffs of our representation of perfect and imperfect information, we realized that the more complicated the logic was, the longer the runtime. Since the larger game traces allowed us to show more (relatively more) complicated logic patterns, we needed to find a balance between those complicated logic patterns and runtime. We tried a large amount of different situations. Still, we ended up on a input variable set in terms of runtime and showed the ability of the smarter algorithms to "beat out" the lower-level algorithms. 

What assumptions did you make about scope? What are the limits of your model?

Did your goals change at all from your proposal? Did you realize anything you planned was unrealistic or that anything you thought was unrealistic was doable?

Our goals within runtime quickly became unrealistic, from the beginning knew that the ability to run through a full game of minesweeper (even with the optimizer) on a large board did not seem incredibly realistic. Although, hypothetically the model could support larger models and was built to be able to as we knew that we could deal with the optimizer in the future. We ended up proving the idea we had in the beggining within algorithims representing decisions making processes looking at imperfect information.

How should we understand an instance of your model and what your visualization shows (whether custom or default)?

Depending on the level of Algorithim: The top left shows what is laying underneath the hidden cells, and then the rest of the cells is showing the actual game trace of the game. 

The four traces are called (dummy, DumbAlgo,kindaSmartAlgo,relativelySmartestAlgo), 
The "dummy" algo is practically a recreation of the game Minesweeper with Traces, where every move taken is a move that will not hit a mine; this is to highlight the contrast of perfect information towards the other algorithms. 
The other algorithms only base their choices on the revealed squares and will make a random move when there is a situation in which they cannot make a more educated guess. (For an in-depth explanation, look at the comments within the predicate)

The DumbAlgo is a basic logic algorithim that gathers as much information as possible before making a completely random move.

The kindaSmartAlgo takes this a step further, and after gathering the information, the algorithim will choose if it is the right move or not by checking if I know that there is a mine in the correct position based on the information of only one tile. 

The relativelySmartestAlgo takes this a step even further. After gathering the information and making all the decisions it can from only one tile, it makes an educated guess based on the information of two tiles, increasing the dimension of logical reasoning by one.