# Snake-in-Assembly (masm)
This is the Snake game made in the Assembly language. I also added the canvas framework which is required for the visualisation of the game and the olly debugger to run the program and debug it. 
The code was written in Notepad++ and the variables and functions names are in romanian. Email me to send you an Engligh version.
You need to put all the folders in a single one. Then open Notepad++ and after that drag and drop Snake.asm in Npp. 

Since you have olly debugger you have to press:
  - F6 in order to start a debug;
  - CTRL+F6 to run;
  - CTRL+F7 to compile;
  
Implemented things:
- MOVEMENT: in order to play you need to click in the top, down, left, right part of the window that opens when you run the program in order to change the direction of the snake 
            to move up, down, left or right ( I recommend to click as close as the border of the window in order to work properly)
- WALLS: the black boxes are walls that will end the game if the snake collides with any of them
- MOVEMENT RESET: when the snake reaches the left limit it will start moving from the right side and vice versa and also when it reaches the top limit it will start to move from 
                  the bottom side and vice versa
- EATING ITSELF: you are not allowed to change the movement of the snake in the opposite direction because you will lose (ex: if the snake moves up you can't make him move down,
                 you need to change the direction to the left or to the right first and then change the direction to move down; this applies to the right and left movement as well)
- FOOD: there are two types of food ( good - yellow and bad - purple)
        1) if you eat the yellow block the snake's body will be incremented by one block. Also, if you eat 10 yellow blocks you win because this is the condition I implemented
            in order to win the game ( you can change it at line 700 where you can write insted of 10 whatever number you want)
        2) if you eat the purple one the snake's body will be decremented by one. Also, if you eat a purple block without eating one single yellow block you will lose because
            the starting score is 0 and it can't be negative
        3) the food's coordinates for both yellow and purple block are generated random
