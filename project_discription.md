# Project Introduction #
---
This project came about to help my brother with an issue he is have regrading inventory of playing cards that he buys and sell. The card game he deal with is called *Magic the Gathering*. Not important but, just in case you are curious. 

This program will not solve his problem but it would be interesting to see how perhaps in the future with enough knowledge it can possibly turn into something that I may be able to help him with. Right now he can certainly use excel to keep inventory but this program is more a proof of concept of the program that he can ultilmatly be using for inventory. 

## The Problem ##
Right now he is using a scanner to scan the cards he buys. His scanner can export that scanned data set into a csv or excel file. He need something that will import that file and update his inventory of cards without having him to do a bunch of copy, pasting, and editing to his excel file. Then he needs a way to remove a card from his inventory, based on the quanity he has in inventory and how much he has actually sold. 

## The Program Scope ##
This program will initally create his database with the first file imported and then update with that cards he has sold and files he has imported. Thus, keeping accurate inventory of the cards he has on hand.

# Psuedocode #
---
1. Create database for card inventory
2. Create Schema for database
3. Create insert, update and remove methods for a card
4. Create a method to import csv file of cards
    1. Read/load CSV file and put data into an array
    2. Iterate through data and collect each individual card
    3. Insert each card into database
5. Create Driver code for 4 different option to either insert a card, remove a card, upadate the price of a card, and import a CSV file into the inventory.

This Psuedocode is very simple but outlines the general direction of the driver code and methods.

