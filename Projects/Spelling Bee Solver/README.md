<h1 align="center">Spelling Bee Solver</h1>

The [New York TImes Spelling Bee](https://www.nytimes.com/puzzles/spelling-bee) is an online word game where the objective is to get as many points as possible by spelling out words using the letters provided. The rules of the game are:

* All words **MUST** contain the central letter.
* Words can only be made up of the letters provided. You don't have to use every letter and letters can be used multiple times.
* Words have to be at least 4 characters long.
* 4 letter words are worth 1 point each. For words over 4 characters long, the points rewarded is equal to the length of the word *(i.e. 5 letter words = 5 points, etc).*
* Words that include all the given letters are known as 'panagrams' and are worth an additional 7 points!

To use the script you just need to edit the required letter and the remaining outside letters. The script will then look through the dictionary to find matching words and display how many points they are worth.

Some words that are found won't be eligible. This is because the NYT Spelling Bee word list doesn't include offensive, obscure, hyphenated or proper nouns.

I got some assistance from ChatGPT to understand how to check strings against a reference string.

<h2>Personal notes</h2>
The first version I made was a little janky with changing the letters you wanted to use because you have to edit the values in the middle of the script.
<br />
I cleaned it up a bit in the second version by creating a function which took both the central letter and the remaining letters as a input and would then print the valid words (or words that are valid given the dictionary I'm using). I hopefully made it a bit easier to follow if I ever decide to come back and try to figure out what each part does by adding notes detailing what each part does.

<h2>Conclusion</h2>
Overall, it wasn't like this was particularly difficult or long to do, but nice to come up with an idea for a little project to do with something that I enjoy! :) 
