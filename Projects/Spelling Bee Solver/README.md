<h1 align="center">Spelling Bee Solver</h1>

The [spelling bee](https://www.nytimes.com/puzzles/spelling-bee) is an online game found on the NYT Games page. The objective of the game is to get as many points as possible by spelling out words using the letters provided. The rules of the game are:

* All words **MUST** contain the central letter.
* Words can only be made up of the letters provided. You don't have to use every letter and letters can be used multiple times.
* Words have to be at least 4 characters long
* 4 letter words are worth 1 point each. For words over 4 characters long, the points rewarded is equal to the length of the word *(i.e. 5 letter words = 5 points, etc).*
* Words that include all the given letters are known as 'panagrams' and are worth an additional 7 points!

To use the script you just need to edit the required letter and the remaining outside letters. The script will then look through the dictionary to find matching words and display how many points they are worth.

Some words that are found won't be eligible. This is because the NYT Spelling Bee word list doesn't include offensive, obscure, hyphenated or proper nouns.

I got some assistance from ChatGPT to understand how to check strings against a reference string.
